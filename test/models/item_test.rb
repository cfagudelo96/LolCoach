require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'should not save without name' do
    item = Item.new
    assert_not item.save
  end

  test 'should save' do
    item = Item.new(name: 'Test')
    assert item.save
  end
end
