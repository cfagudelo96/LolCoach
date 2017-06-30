class ChampionGgAPI
  include HTTParty
  base_uri 'api.champion.gg'

  def initialize
    @options = { query: { api_key: ENV['CHAMPION_GG_API_KEY'] } }
  end

  def champions_variable_info
    @options[:query][:limit] = 200
    @options[:query][:champData] = 'winRate,hashes,matchups'
    self.class.get('/v2/champions', @options)
  end
end
