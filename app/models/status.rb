class Status < ApplicationRecord
  validates :description, presence: true
end
