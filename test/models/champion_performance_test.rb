require 'test_helper'

class ChampionPerformanceTest < ActiveSupport::TestCase
  test 'role should be in list' do
    champion_performance = ChampionPerformance.new(champion_id: 1,
                                                   role: 'Test',
                                                   win_rate: 0.5,
                                                   ban_rate: 0.5)
    assert_not champion_performance.save
  end

  test 'role should be unique' do
    champion_performance = ChampionPerformance.new(champion_id: 1,
                                                   role: ChampionPerformance::TOP,
                                                   win_rate: 0.5,
                                                   ban_rate: 0.5)
    assert_not champion_performance.save
  end

  test 'win rate should be positive' do
    champion_performance = ChampionPerformance.new(champion_id: 1,
                                                   role: ChampionPerformance::TOP,
                                                   win_rate: -0.5,
                                                   ban_rate: 0.5)
    assert_not champion_performance.save
  end

  test 'ban rate should be positive' do
    champion_performance = ChampionPerformance.new(champion_id: 1,
                                                   role: ChampionPerformance::TOP,
                                                   win_rate: 0.5,
                                                   ban_rate: -0.5)
    assert_not champion_performance.save
  end

  test 'should save' do
    champion_performance = ChampionPerformance.new(champion_id: 1,
                                                   role: ChampionPerformance::JUNGLE,
                                                   win_rate: 0.5,
                                                   ban_rate: 0.5)
    assert champion_performance.save
  end
end
