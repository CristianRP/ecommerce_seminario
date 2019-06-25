class Transaction < ApplicationRecord
  has_many :transaction_details, dependent: :destroy
  accepts_nested_attributes_for :transaction_details, reject_if: ->(attributes){ attributes['id'].blank? }, allow_destroy: true
  belongs_to :status, class_name: :Status, foreign_key: :status_id, optional: false
  belongs_to :dealer
  belongs_to :carrier, class_name: :Carrier, foreign_key: :carrier_id, optional: false
  belongs_to :courier, class_name: :Dealer, foreign_key: :courier_id, optional: true
  belongs_to :parameter, class_name: :Parameter, foreign_key: 'type_id'

  def closed?(tag)
    self.status == Status.closed(tag).first
  end

  def open?(tag)
    status == Status.initial(tag).first
  end
end
