class Matchup < ApplicationRecord
  belongs_to :champion_performance
  belongs_to :enemy_champion, class_name: 'Champion'

  validates :enemy_champion, uniqueness: { scope: :champion_performance }
  validates :win_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :enemy_win_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :gold_earned, numericality: { greater_than_or_equal_to: 0 }
  validates :enemy_gold_earned, numericality: { greater_than_or_equal_to: 0 }

  def self.update_matchups(champion_hash, champion_performance)
    matchups_array = champion_hash['matchups'][champion_performance.role]
    matchups_array.each do |matchup_hash|
      matchup_hash = slice_info(matchup_hash, champion_performance)
      matchup = champion_performance.matchups.find_by_enemy_champion_id(matchup_hash['enemy_champion_id'])
      if matchup.present?
        matchup.update(matchup_hash)
      else
        champion_performance.matchups.create(matchup_hash)
      end
    end
  end

  def self.slice_info(matchup_hash, champion_performance)
    identify_matchup_champions(matchup_hash, champion_performance)
    matchup_hash['win_rate'] = matchup_hash[@champion]['winrate']
    matchup_hash['enemy_win_rate'] = matchup_hash[@enemy]['winrate']
    matchup_hash['gold_earned'] = matchup_hash[@champion]['goldEarned']
    matchup_hash['enemy_gold_earned'] = matchup_hash[@enemy]['goldEarned']
    matchup_hash.slice('enemy_champion_id', 'win_rate', 'enemy_win_rate',
                       'gold_earned', 'enemy_gold_earned')
  end

  def self.identify_matchup_champions(matchup_hash, champion_performance)
    if matchup_hash['champ1_id'] == champion_performance.champion.id
      @champion = 'champ1'
      @enemy = 'champ2'
      matchup_hash['enemy_champion_id'] = matchup_hash['champ2_id']
    else
      @champion = 'champ2'
      @enemy = 'champ1'
      matchup_hash['enemy_champion_id'] = matchup_hash['champ1_id']
    end
  end

  private_class_method :slice_info, :identify_matchup_champions
end
