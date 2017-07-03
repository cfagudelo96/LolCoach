class Item < ApplicationRecord
  ITEM_HASH_INDEX = 1

  has_many :tips

  validates :name, presence: true, uniqueness: true

  def self.update_items
    items_info = RiotGamesAPI.new.items_info
    return if items_info.code != 200
    items_hash = items_info.parsed_response['data']
    process_info(items_hash)
  end

  def self.process_info(items_hash)
    items_hash.each do |items_array|
      item_hash = slice_info(items_array[ITEM_HASH_INDEX])
      begin
        find(item_hash['id']).update(item_hash)
      rescue ActiveRecord::RecordNotFound
        create(item_hash)
      end
    end
  end

  def self.slice_info(items_hash)
    items_hash['plain_text'] = items_hash['plaintext']
    items_hash.slice('id', 'name', 'plain_text')
  end

  def self.reset_usages_scores
    InitialItemUsage.reset
    FinalItemUsage.reset
  end

  def to_s
    name
  end

  private_class_method :process_info,
                       :slice_info
end
