class Product < ApplicationRecord
  include Active
  has_many_attached :images
  belongs_to :category, optional: false
  belongs_to :characteristic, optional: false
  validates_presence_of %w[price weight], on: :create, message: "No puede estar vacío."

  def custom_name
    [sku, description].join(' | ')
  end

  def custom_name_order
    [description, characteristic.name].join(' | ')
  end
end
