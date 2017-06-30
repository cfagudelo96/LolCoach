class RiotGamesAPI
  include HTTParty
  base_uri 'https://na1.api.riotgames.com'

  def initialize
    @options = { query: { locale: 'en_US' }, headers: { 'X-Riot-Token' => ENV['X_RIOT_TOKEN'] } }
  end

  def champions_info
    self.class.get('/lol/static-data/v3/champions', @options)
  end

  def items_info
    self.class.get('/lol/static-data/v3/items', @options)
  end

  def summoner_spells_info
    self.class.get('/lol/static-data/v3/summoner-spells', @options)
  end

  def runes_info
    self.class.get('/lol/static-data/v3/runes', @options)
  end
end
