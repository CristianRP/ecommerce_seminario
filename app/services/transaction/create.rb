# frozen_string_literal: true

class Transaction::Create
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
    # Find product
    @product = Product.find(@params[:product_id])
  end

  def perform
    create_detail
    reduce_inventory
  end

  def create_detail
    # Create the detail line
    @transaction_detail = TransactionDetail.new(@params)
    @transaction_detail.transaction_id = @transaction.id
    @transaction_detail.product_id = @product.id
    @transaction_detail.unit_price = @product.price
    @transaction_detail.total = (@product.price * @params[:quantity].to_f)
  end

  def reduce_inventory
    reduce if @transaction_detail.save
  end

  def reduce
    @product.quantity -= @transaction_detail.quantity
    @product.save
  end
end
