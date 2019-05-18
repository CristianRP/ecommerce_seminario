class Product < ApplicationRecord
  include Active
  has_many_attached :images
  belongs_to :category
  belongs_to :characteristic
end
