require 'test_helper'

class InitialItemUsageTest < ActiveSupport::TestCase
  test 'champion performance and item should be unique' do
    item_usage = InitialItemUsage.new(champion_performance_id: 2,
                                      item_id: 2,
                                      score: 1,
                                      quantity: 1)
    assert_not item_usage.save
  end

  test 'quantity should be 1 or greater' do
    item_usage = InitialItemUsage.new(champion_performance_id: 1,
                                      item_id: 1,
                                      score: 1,
                                      quantity: 0)
    assert_not item_usage.save
  end

  test 'should save' do
    item_usage = InitialItemUsage.new(champion_performance_id: 1,
                                      item_id: 1,
                                      score: 1,
                                      quantity: 1)
    assert item_usage.save
  end
end
