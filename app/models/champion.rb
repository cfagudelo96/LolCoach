class Champion < ApplicationRecord
  CHAMPION_HASH_INDEX = 1

  has_many :champion_performances

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
    update_performance_info
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

  def self.update_performance_info
    champions_info = ChampionGgAPI.new.champions_performance
    return if champions_info.code != 200
    champions_info.parsed_response.each do |performance_hash|
      slice_performance_info(performance_hash)
      champion_performance = ChampionPerformance.find_by_champion_id_and_role(performance_hash['champion_id'], performance_hash['role'])
      champion_performance.update(performance_hash) if champion_performance.present?
    end
  end

  def self.slice_performance_info(performance_hash)
    performance_hash['champion_id'] = performance_hash['_id']['championId']
    performance_hash['win_rate'] = performance_hash['winRate']
    performance_hash['ban_rate'] = performance_hash['banRate']
    performance_hash.slice('champion_id', 'role', 'win_rate', 'ban_rate')
  end

  def to_s
    name
  end

  private_class_method :update_static_info,
                       :process_static_info,
                       :slice_static_info,
                       :update_performance_info
end
