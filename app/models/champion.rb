class Champion < ApplicationRecord
  CHAMPION_HASH_INDEX = 1

  has_many :champion_performances

  scope :by_name_like, (->(name) { where('name like ?', "%#{name}%") })

  def self.highest_win_rate_champions(role, limit = 5)
    if role.present?
      Champion.joins(:champion_performances)
              .merge(ChampionPerformance.by_role(role))
              .merge(ChampionPerformance.ordered_by_win_rate).limit(limit)
    else
      Champion.joins(:champion_performances)
              .merge(ChampionPerformance.ordered_by_win_rate).limit(limit)
    end
  end

  def self.update_champions
    update_static_info
    update_variable_info
  end

  def self.update_static_info
    champions_info = RiotGamesAPI.new.champions_info
    return if champions_info.code != 200
    champions_hash = champions_info.parsed_response['data']
    process_static_info(champions_hash)
  end

  def self.process_static_info(champions_hash)
    champions_hash.each do |champion_array|
      champion_hash = slice_static_info(champion_array[CHAMPION_HASH_INDEX])
      begin
        Champion.find(champion_hash['id']).update(champion_hash)
      rescue ActiveRecord::RecordNotFound
        Champion.create(champion_hash)
      end
    end
  end

  def self.slice_static_info(champion_hash)
    champion_hash.slice('id', 'name', 'title')
  end

  def self.update_variable_info
    champions_info = ChampionGgAPI.new.champions_variable_info
    return if champions_info.code != 200
    Item.reset_usages_scores
    champions_info.parsed_response.each do |champion_hash|
      update_performance_info(champion_hash)
    end
  end

  def self.update_performance_info(champion_hash)
    performance_hash = slice_performance_info(champion_hash)
    champion_performance = ChampionPerformance.find_by_champion_id_and_role(performance_hash['champion_id'], performance_hash['role'])
    if champion_performance.present?
      champion_performance.update(performance_hash)
    else
      champion_performance = ChampionPerformance.create(performance_hash)
    end
    update_item_usages(champion_hash, champion_performance)
  end

  def self.slice_performance_info(champion_hash)
    champion_hash['champion_id'] = champion_hash['_id']['championId']
    champion_hash['win_rate'] = champion_hash['winRate']
    champion_hash['ban_rate'] = champion_hash['banRate']
    champion_hash.slice('champion_id', 'role', 'win_rate', 'ban_rate')
  end

  def self.update_item_usages(champion_hash, champion_performance)
    update_initial_items(champion_hash, champion_performance)
    update_final_items(champion_hash, champion_performance)
  end

  def self.update_initial_items(champion_hash, champion_performance)
    items_string = champion_hash.dig('hashes', 'firstitemshash',
                                     'highestCount', 'hash')
    return if items_string.blank?
    items_list = split_string(items_string)
    items_list.each do |item_id|
      InitialItemUsage.update_item_usage(champion_performance, item_id)
    end
  end

  def self.update_final_items(champion_hash, champion_performance)
    items_string = champion_hash.dig('hashes', 'finalitemshashfixed',
                                     'highestCount', 'hash')
    return if items_string.blank?
    items_list = split_string(items_string)
    items_list.each do |item_id|
      FinalItemUsage.update_item_usage(champion_performance, item_id)
    end
  end

  def self.split_string(string)
    list = string.split('-')
    list.shift
    list
  end

  def to_s
    name
  end

  private_class_method :update_static_info, :process_static_info,
                       :slice_static_info, :update_variable_info,
                       :update_performance_info, :slice_performance_info,
                       :update_item_usages, :update_initial_items,
                       :update_final_items, :split_string
end
