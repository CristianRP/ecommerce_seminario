class Product < ApplicationRecord
  include Active
  has_many_attached :images
  belongs_to :category
  belongs_to :characteristic

  def custom_name
    [sku, description].join(' | ')
  end
end
