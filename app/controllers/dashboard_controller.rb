# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    transaction = Transaction.arel_table
    t_detail = TransactionDetail.arel_table
    product = Product.arel_table
    transactions = current_dealer.transactions
    orders = transactions.where(transaction[:status_id].not_eq(Status.where(tag: 'SALE', description: 'FINALIZADA').first.id))
    finished_orders = transactions.where(transaction[:status_id].eq(Status.where(tag: 'SALE', description: 'FINALIZADA').first.id))
    @count_orders = orders.count
    @count_finished_orders = finished_orders.count
    @sum_orders = orders.sum(:amount)
    @sum_finished_orders = finished_orders.sum(:amount)
    @products_above_min = Product.where(product[:quantity].lteq(product[:min]))
    join_on = t_detail.create_on(t_detail[:product_id].eq(product[:id]))
    inner_join = t_detail.create_join(product, join_on)
  end
end
