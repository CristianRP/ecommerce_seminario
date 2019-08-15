class Transaction < ApplicationRecord
  has_many :transaction_details, dependent: :destroy
  accepts_nested_attributes_for :transaction_details, reject_if: ->(attributes){ attributes['id'].blank? }, allow_destroy: true
  belongs_to :status, class_name: :Status, foreign_key: :status_id, optional: false
  belongs_to :dealer
  belongs_to :carrier, class_name: :Carrier, foreign_key: :carrier_id, optional: true
  belongs_to :courier, -> { where courier: true }, class_name: :Dealer#, foreign_key: :id, optional: true
  belongs_to :type, -> { where tag: 'TRANSACTION_TYPE' }, class_name: :Parameter, foreign_key: 'type_id', primary_key: 'int_value'
  belongs_to :delivery, class_name: :Delivery, foreign_key: :delivery_id

  def closed?(tag)
    status == Status.closed(tag).first
  end

  def open?(tag)
    status == Status.initial(tag).first
  end

  def on_route?(tag)
    status == Status.on_route(tag).first
  end

  def not_delivery?(tag)
    status == Status.not_delivery(tag).first
  end

  def delivered?(tag)
    status == Status.delivered(tag).first
  end

  scope :pending_to_packing, ->(tag) { where(status: Status.closed(tag), type_id: 2) }
  scope :pending_to_deliver, ->(tag, courier_id) { where(status: Status.on_route(tag), courier_id: courier_id) }
  scope :delivered_courier, ->(tag, courier_id) { where(status: [Status.not_delivery(tag).first, Status.delivered(tag).first], courier_id: courier_id) }
  scope :watching_to_deliver, ->(tag) { where(status: Status.on_route(tag)) }
  scope :delivered, ->(tag) { where(status: [Status.not_delivery(tag).first, Status.delivered(tag).first]) }
  scope :delivered_liq, ->(tag) { where(status: Status.delivered(tag).first) }
  scope :not_delivered_liq, ->(tag) { where(status: Status.not_delivery(tag).first) }
  scope :pending_to_close, ->(tag) { where(status: Status.finished(tag)) }

  ransacker :created_at do
    Arel.sql('date(created_at)')
  end
end
