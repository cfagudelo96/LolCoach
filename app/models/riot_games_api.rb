class RiotGamesAPI
  include HTTParty
  base_uri 'https://na1.api.riotgames.com'

  def initialize
    @options = { query: { locale: 'en_US' }, headers: { 'X-Riot-Token': ENV['X_Riot_Token'] } }
  end

  def champion_info(champion_id)
    self.class.get("/lol/static-data/v3/champions/#{champion_id}", @options)
  end
end
