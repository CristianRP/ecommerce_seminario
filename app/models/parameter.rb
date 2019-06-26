# frozen_string_literal: true

class Parameter < ApplicationRecord
  has_many :transactions, class_name: :Transaction, primary_key: 'int_value', foreign_key: 'type_id'
  scope :transaction_types, lambda {
    where(tag: 'TRANSACTION_TYPE')
  }

  scope :transaction_type_in, -> { where(tag: 'TRANSACTION_TYPE', int_value: 1) }

  scope :transaction_type_out, -> { where(tag: 'TRANSACTION_TYPE', int_value: 2) }

  scope :transaction_type_return, -> { where(tag: 'TRANSACTION_TYPE', int_value: 3) }

  scope :service_types, -> { where(tag: 'SERVICE_TYPE') }
  scope :sender_info, -> { where(tag: 'SENDER_INFO') }
  scope :auth, -> { where(tag: 'AUTHENTICATION') }
end
