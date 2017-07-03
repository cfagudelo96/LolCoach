require 'test_helper'

class ChampionTest < ActiveSupport::TestCase
  test 'name should be present' do
    champion = Champion.new(title: 'Test')
    assert_not champion.save
  end

  test 'name should be unique' do
    champion = Champion.new(name: 'MyString', title: 'Test')
    assert_not champion.save
  end

  test 'should save' do
    champion = Champion.new(name: 'Test', title: 'Test')
    assert champion.save
  end
end
