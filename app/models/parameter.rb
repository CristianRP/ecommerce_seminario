# frozen_string_literal: true

class Parameter < ApplicationRecord
  scope :transaction_types, lambda {
    where(tag: 'TRANSACTION_TYPE')
  }

  scope :transaction_type_in, -> { where(tag: 'TRANSACTION_TYPE', int_value: 1) }

  scope :transaction_type_out, -> { where(tag: 'TRANSACTION_TYPE', int_value: 2) }
end
