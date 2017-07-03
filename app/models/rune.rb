class Rune < ApplicationRecord
  RUNE_HASH_INDEX = 1
  
  validates :name, presence: true
  validates :description, presence: true

  def self.update_runes
    runes_info = RiotGamesAPI.new.runes_info
    return if runes_info.code != 200
    runes_hash = runes_info.parsed_response['data']
    process_info(runes_hash)
  end

  def self.process_info(runes_hash)
    runes_hash.each do |runes_array|
      rune_hash = slice_info(runes_array[RUNE_HASH_INDEX])
      begin
        find(rune_hash['id']).update(rune_hash)
      rescue ActiveRecord::RecordNotFound
        create(rune_hash)
      end
    end
  end

  def self.slice_info(rune_hash)
    rune_hash['tier'] = rune_hash['rune']['tier']
    rune_hash['color'] = rune_hash['rune']['type']
    rune_hash.slice('id', 'name', 'description', 'tier', 'color')
  end

  def to_s
    name
  end

  private_class_method :process_info,
                       :slice_info
end
