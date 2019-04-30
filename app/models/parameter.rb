class Parameter < ApplicationRecord

  scope :transaction_types, lambda {
    where(tag: 'TRANSACTION_TYPE')
  }

  scope :transaction_type_in, lambda { where(tag: 'TRANSACTION_TYPE', int_value: 1)}
  
  scope :transaction_type_out, lambda { where(tag: 'TRANSACTION_TYPE', int_value: 2)}
end
