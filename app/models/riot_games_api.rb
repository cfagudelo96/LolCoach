class RiotGamesAPI
  include HTTParty
  base_uri 'https://na1.api.riotgames.com'

  def initialize
    @options = { query: { locale: 'en_US' }, headers: { 'X-Riot-Token' => ENV['X_RIOT_TOKEN'] } }
  end

  def champions_info
    self.class.get('/lol/static-data/v3/champions', @options)
  end

  def champion_info(champion_id)
    self.class.get("/lol/static-data/v3/champions/#{champion_id}", @options)
  end

  def items_info
    self.class.get('/lol/static-data/v3/items', @options)
  end

  def item_info(item_id)
    self.class.get("/lol/static-data/v3/items/#{item_id}", @options)
  end

  def summoner_spells_info
    self.class.get('/lol/static-data/v3/summoner-spells', @options)
  end

  def summoner_spell_info(summoner_spell_id)
    self.class.get("/lol/static-data/v3/summoner-spells/#{item_id}", @options)
  end
end
