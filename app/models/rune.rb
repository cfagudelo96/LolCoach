class Rune < ApplicationRecord
  RUNE_HASH_INDEX = 1
  validates :name, presence: true
  validates :description, presence: true

  def self.update_runes
    update_static_info
    Rune.all
  end

  def self.update_static_info
    rune_info = RiotGamesAPI.new.runes_info
    return if rune_info.code != 200
    rune_hash = rune_info.parsed_response['data']
    process_static_info(rune_hash)
  end

  def self.process_static_info(rune_hash)
    rune_hash.each do |rune_array|
      rune_hash = slice_static_info(rune_array[RUNE_HASH_INDEX])
      begin
        Rune.find(rune_hash['id']).update(rune_hash)
      rescue ActiveRecord::RecordNotFound
        Rune.create(rune_hash)
      end
    end
  end

  def self.slice_static_info(rune_hash)
    rune_hash['tier'] = rune_hash['rune']['tier']
    rune_hash['type'] = rune_hash['rune']['type']
    rune_hash.slice('id', 'name', 'description', 'tier', 'type')
  end

  def to_s
    name
  end

  private_class_method :update_static_info,
                       :process_static_info,
                       :slice_static_info
end
