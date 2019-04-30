class Status < ApplicationRecord
  validates :description, presence: true

  scope :initial, -> {
    where(description: 'CREADA')
  }
end
