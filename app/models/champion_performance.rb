class ChampionPerformance < ApplicationRecord
  MIDDLE = 'MIDDLE'.freeze
  TOP = 'TOP'.freeze
  JUNGLE = 'JUNGLE'.freeze
  DUO_CARRY = 'DUO_CARRY'.freeze
  DUO_SUPPORT = 'DUO_SUPPORT'.freeze
  ROLES = [MIDDLE, TOP, JUNGLE, DUO_CARRY, DUO_SUPPORT].freeze

  belongs_to :champion

  validates :role, uniqueness: { scope: :champion }, inclusion: { in: ROLES }

  scope :by_role, (->(role) { where(role: role) })
  scope :ordered_by_win_rate, (-> { where.not(win_rate: nil).order(win_rate: :desc) })
end
