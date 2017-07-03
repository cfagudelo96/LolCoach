require 'test_helper'

class MatchupTest < ActiveSupport::TestCase
  test 'enemy champion and champion performance should be unique' do
    matchup = Matchup.new(champion_performance_id: 2,
                          enemy_champion_id: 1,
                          win_rate: 0.5,
                          enemy_win_rate: 0.5,
                          gold_earned: 1,
                          enemy_gold_earned: 1)
    assert_not matchup.save
  end

  test 'should save' do
    matchup = Matchup.new(champion_performance_id: 1,
                          enemy_champion_id: 1,
                          win_rate: 0.5,
                          enemy_win_rate: 0.5,
                          gold_earned: 1,
                          enemy_gold_earned: 1)
    assert matchup.save
  end
end
