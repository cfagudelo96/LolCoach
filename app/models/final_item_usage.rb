class FinalItemUsage < ApplicationRecord
  belongs_to :champion_performance
  belongs_to :item

  validates :item, uniqueness: { scope: :champion_performance }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  def self.reset
    update_all(score: 0, quantity: 1)
  end

  def self.update_final_item_usages(champion_hash, champion_performance)
    items_string = champion_hash.dig('hashes', 'finalitemshashfixed',
                                     'highestCount', 'hash')
    return if items_string.blank?
    items_list = Helper.split_string(items_string)
    items_list.each do |item_id|
      update_item_usage(champion_performance, item_id)
    end
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
