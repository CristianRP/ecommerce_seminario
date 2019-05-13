# frozen_string_literal: true

class Transaction::Destroy
  def self.call(params, transaction)
    new(params, transaction).call
  end

  def call
    perform
  end

  private

  attr_reader :params
  def initialize(params, transaction)
    @params = params
    @transaction = transaction
    @transaction_detail = transaction.transaction_details.find(@params[:transaction_detail_id])
    # Find product
    @product = Product.find(@params[:product_id])
  end

  def perform
    destroy_detail
    return_inventory
  end

  def destroy_detail
    # Destroy the detail line
    @transaction_detail&.destroy
  end

  def return_inventory
    increment if @transaction_detail.save
  end

  def increment
    @product.quantity += @transaction_detail.quantity
    @product.save
  end
end
