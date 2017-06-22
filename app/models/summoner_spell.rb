class SummonerSpell < ApplicationRecord
  SUMMONER_SPELL_HASH_INDEX = 1
  validates :name, presence: true
  validates :description, presence: true

  def self.update_summoner_spells
    update_static_info
    SummonerSpell.all
  end

  def self.update_static_info
    summoner_spell_info = RiotGamesAPI.new.summoner_spells_info
    return if summoner_spell_info.code != 200
    summoner_spell_hash = summoner_spell_info.parsed_response['data']
    process_static_info(summoner_spell_hash)
  end

  def self.process_static_info(summoner_spell_hash)
    summoner_spell_hash.each do |summoner_spell_array|
      summoner_spell_hash = slice_static_info(summoner_spell_array[SUMMONER_SPELL_HASH_INDEX])
      begin
        SummonerSpell.find(summoner_spell_hash['id']).update(summoner_spell_hash)
      rescue ActiveRecord::RecordNotFound
        SummonerSpell.create(summoner_spell_hash)
      end
    end
  end

  def self.slice_static_info(summoner_spell_hash)
    summoner_spell_hash.slice('id', 'name', 'description')
  end

  def to_s
    name
  end

  private_class_method :update_static_info,
                       :process_static_info,
                       :slice_static_info
end
