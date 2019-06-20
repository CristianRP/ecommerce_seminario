# frozen_string_literal: true

class Delivery < ApplicationRecord
  has_one :my_transaction, class_name: :Transaction, foreign_key: :delivery_id
  accepts_nested_attributes_for :my_transaction, reject_if: ->(attributes) { attributes['recolection_id'].blank? }, allow_destroy: true
  has_many :pieces
end
