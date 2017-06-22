class Item < ApplicationRecord
  ITEM_HASH_INDEX = 1

  validates :name, presence: true
  validates :plain_text, presence: true

  def self.update_items
    update_static_info
    Item.all
  end

  def self.update_static_info
    items_info = RiotGamesAPI.new.items_info
    return if items_info.code != 200
    items_hash = items_info.parsed_response['data']
    process_static_info(items_hash)
  end

  def self.process_static_info(items_hash)
    items_hash.each do |items_array|
      item_hash = slice_static_info(items_array[ITEM_HASH_INDEX])
      begin
        Item.find(item_hash['id']).update(item_hash)
      rescue ActiveRecord::RecordNotFound
        Item.create(item_hash)
      end
    end
  end

  def self.slice_static_info(items_hash)
    plain_text = items_hash['plaintext']
    items_hash.delete('plaintext')
    items_hash['plain_text'] = plain_text
    items_hash.slice('id', 'name', 'plain_text')
  end

  def to_s
    name
  end

  private_class_method :update_static_info,
                       :process_static_info,
                       :slice_static_info
end
