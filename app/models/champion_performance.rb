class ChampionPerformance < ApplicationRecord
  MIDDLE = 'MIDDLE'.freeze
  TOP = 'TOP'.freeze
  JUNGLE = 'JUNGLE'.freeze
  DUO_CARRY = 'DUO_CARRY'.freeze
  DUO_SUPPORT = 'DUO_SUPPORT'.freeze
  ROLES = [MIDDLE, TOP, JUNGLE, DUO_CARRY, DUO_SUPPORT].freeze

  belongs_to :champion
  has_many :initial_item_usages
  has_many :final_item_usages
  has_many :matchups

  validates :role, uniqueness: { scope: :champion }, inclusion: { in: ROLES }

  scope :by_role, (->(role) { where(role: role) })
  scope :ordered_by_win_rate, (-> { where.not(win_rate: nil).order(win_rate: :desc) })

  def counters(limit = 3)
    counters = []
    counter_matchups = matchups.order(enemy_win_rate: :desc).limit(limit)
    counter_matchups.each do |matchup|
      counters << matchup.enemy_champion
    end
    counters
  end

  def self.update_performance_info(champion_hash)
    performance_hash = slice_performance_info(champion_hash)
    champion_performance = find_by_champion_id_and_role(performance_hash['champion_id'],
                                                        performance_hash['role'])
    if champion_performance.present?
      champion_performance.update(performance_hash)
    else
      champion_performance = create(performance_hash)
    end
    InitialItemUsage.update_initial_item_usages(champion_hash, champion_performance)
    FinalItemUsage.update_final_item_usages(champion_hash, champion_performance)
    Matchup.update_matchups(champion_hash, champion_performance)
  end

  def self.slice_performance_info(champion_hash)
    champion_hash['champion_id'] = champion_hash['_id']['championId']
    champion_hash['win_rate'] = champion_hash['winRate']
    champion_hash['ban_rate'] = champion_hash['banRate']
    champion_hash.slice('champion_id', 'role', 'win_rate', 'ban_rate')
  end

  def to_s
    "#{champion} #{role}"
  end

  private_class_method :slice_performance_info
end
