class Status < ApplicationRecord
  belongs_to :parent, class_name: 'Status', foreign_key: :next, optional: true
  validates :description, presence: true

  scope :initial, -> {
    where(description: 'CREADA')
  }
end
