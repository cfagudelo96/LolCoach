class Champion < ApplicationRecord
  def self.update_champions
    champions_info = RiotGamesAPI.new.champions_info
    if champions_info.code == 200
      champions = champions_info.parsed_response['data']
      champions.each do |champion_key, champion_value|
        begin
          Champion.find(champion_value[:id]).update(champion_value)
        rescue ActiveRecord::RecordNotFound
          Champion.create(champion_value)
        end
      end
    end
    Champion.all
  end

  def update_champion(id)
    champion_info = RiotGamesAPI.new.champion_info(id)
    champion = nil
    if champion_info.code == 200
      begin
        champion = Champion.find(id)
        champion.update(champion_info.parsed_response)
      rescue ActiveRecord::RecordNotFound
        champion = Champion.create(champion_info.parsed_response)
      end
    end
    champion
  end
end
