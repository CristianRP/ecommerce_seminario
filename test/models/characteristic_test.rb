require 'test_helper'

class CharacteristicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'should not save characteristic without a name' do
    characteristic = Characteristic.new
    assert_not characteristic.save
  end

  test 'create new characteristic' do
    characteristic = Characteristic.new
    characteristic.name = 'Color'
    assert characteristic.save
  end
end
