class Parameter < ApplicationRecord

  scope :transaction_types, -> {
    where(tag: 'TRANSACTION_TYPE')
  }
end
