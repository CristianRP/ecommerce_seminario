# frozen_string_literal: true

class Transaction::Restock
  def self.call(transaction)
    new(transaction).call
  end

  def call
    perform
  end

  private

  attr_reader :params
  def initialize(transaction)
    @transaction = transaction
    @transaction_details = transaction.transaction_details
  end

  def perform
    increment_inventory
  end

  def increment_inventory
    @transaction_details.each do |transaction_detail|
      increment(transaction_detail, transaction_detail.product)
    end
  end

  def increment(transaction_detail, product)
    product.quantity += transaction_detail.quantity
    product.balance = 0
    product.save
  end
end
