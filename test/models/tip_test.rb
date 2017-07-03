require 'test_helper'

class TipTest < ActiveSupport::TestCase
  test 'should be only about a champion' do
    tip = Tip.new(champion_id: 1, item_id: 1, tip: 'Test')
    assert_not tip.save
  end

  test 'should be only about an item' do
    tip = Tip.new(champion_id: 1, item_id: 1, tip: 'Test')
    assert_not tip.save
  end

  test 'should be only about a role' do
    tip = Tip.new(role: ChampionPerformance::TOP, item_id: 1, tip: 'Test')
    assert_not tip.save
  end

  test 'role should be valid' do
    tip = Tip.new(role: 'Test', tip: 'Test')
    assert_not tip.save
  end

  test 'should have a tip' do
    tip = Tip.new(champion_id: 1)
    assert_not tip.save
  end

  test 'should be against a champion' do
    tip = Tip.new(item_id: 1, tip: 'Test', against: true)
    assert_not tip.save
  end

  test 'should save a tip' do
    tip = Tip.new(tip: 'Test')
    assert tip.save
  end

  test 'should save a tip about a champion' do
    tip = Tip.new(champion_id: 1, tip: 'Test', against: true)
    assert tip.save
  end

  test 'should save a tip about an item' do
    tip = Tip.new(item_id: 1, tip: 'Test')
    assert tip.save
  end

  test 'should save a tip about a role' do
    tip = Tip.new(role: ChampionPerformance::MIDDLE, tip: 'Test')
    assert tip.save
  end
end
