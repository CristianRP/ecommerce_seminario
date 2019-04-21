require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'validate presence of name' do
    category = Category.new
    assert_not category.save, "You can't create a category without a name"
  end

  test 'validate create new category' do
    category = Category.new
    category.name = 'Ropa'
    assert category.save
  end
end
