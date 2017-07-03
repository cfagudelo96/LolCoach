class Champion < ApplicationRecord
  extend Speech
  include Speech

  CHAMPION_HASH_INDEX = 1

  has_many :champion_performances
  has_many :tips

  validates :name, presence: true, uniqueness: true

  scope :by_name_like, (->(name) { where('name like ?', "%#{name}%") })

  def champion_performance(role)
    if champion_performances.size == 1
      champion_performances.first
    else
      champion_performances.find_by_role(role)
    end
  end

  def role_not_specified_response
    champion_roles = champion_performances.pluck(:role)
    champion_roles_text = list_to_text(champion_roles, 'or maybe')
    speech = "Which role are you playing #{name}: #{champion_roles_text}"
    display_text = "Which role are you playing #{name}: #{champion_roles_text}"
    { speech: speech, displayText: display_text }
  end

  def self.champion_not_found_response(champion_name)
    speech = "I couldn't find the champion that you were referring to"
    champions_like = by_name_like(champion_name)
    display_text = if champions_like.empty? || champion_name.blank?
                     "I couldn't find the champion that you were referring to"
                   else
                     "Maybe you were referring to #{list_to_text(champions_like,
                                                                 'or')}"
                   end
    { speech: speech, displayText: display_text }
  end

  def self.highest_win_rate_champions(role, limit = 5)
    if role.present?
      joins(:champion_performances)
        .merge(ChampionPerformance.by_role(role))
        .merge(ChampionPerformance.ordered_by_win_rate).limit(limit)
    else
      joins(:champion_performances)
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
        find(champion_hash['id']).update(champion_hash)
      rescue ActiveRecord::RecordNotFound
        create(champion_hash)
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
      ChampionPerformance.update_performance_info(champion_hash)
    end
  end

  def to_s
    name
  end

  private_class_method :update_static_info, :process_static_info,
                       :slice_static_info, :update_variable_info
end
