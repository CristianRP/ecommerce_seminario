class Transaction < ApplicationRecord
  has_many :transaction_details, dependent: :destroy
  accepts_nested_attributes_for :transaction_details, reject_if: ->(attributes){ attributes['id'].blank? }, allow_destroy: true
  belongs_to :status
  belongs_to :dealer
  belongs_to :carrier
  belongs_to :dealer, class_name: :Dealer, foreign_key: :courier_id, optional: true
end
