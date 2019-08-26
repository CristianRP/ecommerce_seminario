# frozen_string_literal: true

class Transaction::Destroy
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
    transaction = transaction_detail.my_transaction
    @restock = transaction.type == Parameter.transaction_type_in.first
    # Find product
    @product = Product.find(transaction_detail.product_id)
  end

  def perform
    destroy_detail
    increment_inventory
  end

  def destroy_detail
    # Destroy the detail line
    @transaction_detail&.destroy
  end

  def increment_inventory
    @product.quantity += @transaction_detail.quantity
    @product.balance = @product.quantity
    if @restock
      @product.price = @product.old_price
      @product.cost = @product.old_cost
    end
    @product.save
  end
end
