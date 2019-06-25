# frozen_string_literal: true

class Transaction::Returns
  def self.call(transaction_detail)
    new(transaction_detail).call
  end

  def call
    perform
  end

  private

  attr_reader :transaction_detail
  def initialize(transaction_detail)
    @transaction_detail = transaction_detail
    # Find product
    @product = Product.find(transaction_detail.product_id)
  end

  def perform
    increment_inventory
  end

  def increment_inventory
    @product.quantity = @product.balance
    @product.balance = @product.quantity
    @product.save
  end
end
