class TransactionDetail < ApplicationRecord
  belongs_to :my_transaction, class_name: "Transaction", foreign_key: "transaction_id"
  belongs_to :product
  validate :quanty_greather_than_inventory

  transaction_detail = TransactionDetail.arel_table
  scope :get_total_order, lambda { |transaction_id|
    select(transaction_detail[:total].sum.as('TOTAL_ORDER'))
      .where(transaction_detail[:transaction_id].eq(transaction_id))
      .group(transaction_detail[:transaction_id])
      .order(transaction_detail[:transaction_id])
  }

  def quanty_greather_than_inventory
    errors.add(:transaction, "La cantidad solicitada no esta disponible. En Stock: #{product.quantity}") if product.quantity < quantity
  end
end
