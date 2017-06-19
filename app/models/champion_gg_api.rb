class ChampionGGAPI
  include HTTParty
  base_uri 'api.champion.gg'

  def initialize
    @options = { query: { api_key: ENV['CHAMPION_GG_API_KEY'] } }
  end

  def champions
    self.class.get('/v2/champions', @options)
  end
end
