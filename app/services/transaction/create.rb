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
    return increment_inventory if @transaction.type_id == Parameter.transaction_type_in.first.int_value
    return reduce_inventory if @transaction.type_id == Parameter.transaction_type_out.first.int_value
  end

  def create_detail
    # Create the detail line
    @transaction_detail = TransactionDetail.new(@params.except(:product_cost))
    @transaction_detail.transaction_id = @transaction.id
    @transaction_detail.product_id = @product.id
    @transaction_detail.unit_price = @params[:unit_price]
    @transaction_detail.total = (@params[:unit_price].to_f * @params[:quantity].to_f)
  end

  def reduce_inventory
    reduce if @transaction_detail.save
    @transaction_detail.save
    @transaction_detail
  end

  def reduce
    @product.balance = @product.quantity
    @product.quantity -= @transaction_detail.quantity
    @product.save
  end

  def increment_inventory
    increment if @transaction.save(validate: false)
    @transaction_detail.save(validate: false)
    @transaction_detail
  end

  def increment
    @product.quantity += @transaction_detail.quantity
    @product.balance = @product.quantity
    @product.old_price = @product.price
    @product.old_cost = @product.cost
    @product.price = @params[:unit_price]
    @product.cost = @params[:product_cost]
    @product.save
  end
end
