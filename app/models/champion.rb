class Champion < ApplicationRecord
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
