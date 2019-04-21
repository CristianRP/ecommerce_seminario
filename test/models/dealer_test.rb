require 'test_helper'

class DealerTest < ActiveSupport::TestCase
  test 'validate presence of attributes' do
    dealer = Dealer.new
    assert_not dealer.save, 'No presence of required attributes'
  end

  test 'validate new dealer' do
    dealer = Dealer.new
    dealer.name = 'Cristian'
    dealer.last_name = 'Ramirez'
    dealer.phone = '34235235'
    dealer.address = 'Vh1'
    dealer.comission = 10
    assert dealer.save, 'Saved successfull'
  end
end
