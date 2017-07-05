class Tip < ApplicationRecord
  validates :tip, presence: true
  validates :role, inclusion: { in: [ChampionPerformance::MIDDLE,
                                     ChampionPerformance::TOP,
                                     ChampionPerformance::JUNGLE,
                                     ChampionPerformance::DUO_CARRY,
                                     ChampionPerformance::DUO_SUPPORT,
                                     nil] }
  validate :tip_about_champion, :tip_about_item,
           :tip_about_role, :tip_against_champion

  def tip_about_champion
    if champion_id.present? && (item_id.present? || role.present?)
      errors.add(:champion_id,
                 "can't be present if the tip is about an item or role")
    end
  end

  def tip_about_item
    if item_id.present? && (champion_id.present? || role.present?)
      errors.add(:item_id,
                 "can't be present if the tip is about a champion or role")
    end
  end

  def tip_about_role
    if role.present? && (champion_id.present? || item_id.present?)
      errors.add(:role,
                 "can't be present if the tip is about a champion or item")
    end
  end

  def tip_against_champion
    if against && champion_id.blank?
      errors.add(:against, "can't be present if the tip is not about a champion")
    end
  end

  def self.ramdom_general_tip
    tips = Tip.where("champion_id IS ? AND item_id IS ? AND role IS ?", nil, nil, nil)
    if tips.size>1
      tips[rand((tips.size)).floor ].attributes['tip']
    else
      return a = 'No hay tips'
    end
  end

  def self.ramdom_rol_tip
    tips = Tip.where.not("role IS ?", nil)
    if tips.size>1
      tips[rand((tips.size)).floor ].attributes['tip']
    else
      return a = 'No hay tips'
    end

  end

  def self.ramdom_champion_tip
    tips = Tip.where.not("champion_id IS ?", nil, nil, nil)
    if tips.size>1
      tips[rand((tips.size)).floor ].attributes['tip']
    else
      return a = 'No hay tips'
    end
  end
end
