require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  test 'should not save status without a description' do
    status = Status.new
    assert_not status.save
  end

  test 'should save status' do
    status = Status.new
    status.description = 'Active'
    assert status.save
  end
end
