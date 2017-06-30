class Matchup < ApplicationRecord
  belongs_to :champion_performance
  belongs_to :enemy_champion, class_name: 'Champion'

  def self.update_matchups(champion_hash, champion_performance)
    matchups_array = champion_hash['matchups'][champion_performance.role]
    matchups_array.each do |matchup_hash|
      matchup_hash = slice_info(matchup_hash)
      matchup = champion_performance.matchups.find_by_enemy_champion_id(matchup_hash['enemy_champion_id'])
      if matchup.present?
        matchup.update(matchup_hash)
      else
        champion_performance.matchups.create(matchup_hash)
      end
    end
  end

  def self.slice_info(matchup_hash)
    matchup_hash['enemy_champion_id'] = matchup_hash['champ1_id']
    matchup_hash['win_rate'] = matchup_hash['champ2']['winrate']
    matchup_hash['enemy_win_rate'] = matchup_hash['champ1']['winrate']
    matchup_hash['gold_earned'] = matchup_hash['champ2']['goldEarned']
    matchup_hash['enemy_gold_earned'] = matchup_hash['champ1']['goldEarned']
    matchup_hash.slice('enemy_champion_id', 'win_rate', 'enemy_win_rate',
                       'gold_earned', 'enemy_gold_earned')
  end

  private_class_method :slice_info
end
