# frozen_string_literal: true

class DashboardController < ApplicationController
  skip_before_action :not_admin
  before_action :not_dealer

  def index
    redirect_to transactions_path if current_dealer.grocer?
    transaction = Transaction.arel_table
    t_detail = TransactionDetail.arel_table
    product = Product.arel_table
    transactions = current_dealer.transactions
    orders = transactions.where(transaction[:status_id].not_eq(Status.where(tag: 'SALE', description: 'LIQUIDADA').first.id))
    finished_orders = transactions.where(transaction[:status_id].eq(Status.where(tag: 'SALE', description: 'LIQUIDADA').first.id))
    @count_orders = orders.count
    @count_finished_orders = finished_orders.count
    @sum_orders = orders.sum(:amount)
    @sum_finished_orders = finished_orders.sum(:amount)
    @products_above_min = Product.where(product[:quantity].lteq(product[:min]))
  end
end
