class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  belongs_to :characteristic
end
