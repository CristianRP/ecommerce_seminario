require 'test_helper'

class CarrierTest < ActiveSupport::TestCase
  test 'validate presence of name' do
    carrier = Carrier.new
    assert_not carrier.save
  end

  test 'validate create new' do
    carrier = Carrier.new
    carrier.name = 'DHL'
    assert carrier.save
  end
end
