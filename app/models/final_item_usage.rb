class FinalItemUsage < ApplicationRecord
  belongs_to :champion_performance
  belongs_to :item

  def self.reset_scores
    FinalItemUsage.update_all(score: 0)
  end

  def self.update_item_usage(champion_performance, item_id)
    item_usage = champion_performance.final_item_usages.find_by_item_id(item_id)
    if item_usage.present?
      if item_usage.score > 0
        item_usage.update(score: 1, quantity: item_usage.quantity + 1)
      else
        item_usage.update(score: 1)
      end
    else
      champion_performance.final_item_usages.create(item_id: item_id, score: 1)
    end
  end

  def to_s
    quantity > 1 ? "#{quantity} #{item}" : item.to_s
  end
end
