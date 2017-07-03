class SummonerSpell < ApplicationRecord
  SUMMONER_SPELL_HASH_INDEX = 1
  
  validates :name, presence: true
  validates :description, presence: true

  def self.update_summoner_spells
    summoner_spells_info = RiotGamesAPI.new.summoner_spells_info
    return if summoner_spells_info.code != 200
    summoner_spells_hash = summoner_spells_info.parsed_response['data']
    process_info(summoner_spells_hash)
  end

  def self.process_info(summoner_spells_hash)
    summoner_spells_hash.each do |summoner_spells_array|
      summoner_spell_hash = slice_info(summoner_spells_array[SUMMONER_SPELL_HASH_INDEX])
      begin
        find(summoner_spell_hash['id']).update(summoner_spell_hash)
      rescue ActiveRecord::RecordNotFound
        create(summoner_spell_hash)
      end
    end
  end

  def self.slice_info(summoner_spell_hash)
    summoner_spell_hash.slice('id', 'name', 'description')
  end

  def to_s
    name
  end

  private_class_method :process_info,
                       :slice_info
end
