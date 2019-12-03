class ReportsController < ApplicationController
  def index
    if current_dealer.admin?
      @transactions_query = Transaction.where(type: Parameter.transaction_type_out).order(id: :desc).ransack(params[:q])
      @transactions_query_report = Transaction.report_all.where(type: Parameter.transaction_type_out).order(id: :desc).ransack(params[:q])
    elsif current_dealer.grocer?
      @transactions_query = Transaction.pending_to_packing('SALE').ransack(params[:q])
      @transactions_query_report = Transaction.report_all.pending_to_packing('SALE').ransack(params[:q])
    elsif current_dealer.courier?
      @transactions_query = Transaction.pending_to_deliver('SALE', current_dealer.id).ransack(params[:q])
      @transactions_query_report = Transaction.report_all.pending_to_deliver('SALE', current_dealer.id).ransack(params[:q])
    else
      @transactions_query = current_dealer.transactions.ransack(params[:q])
      @transactions_query_report = current_dealer.transactions.report_all.ransack(params[:q])
    end
    @transactions = @transactions_query.result(distinct: true).page(params[:page])
    @transactions_report = @transactions_query_report.result(distinct: true).page(params[:page])
    #raise
    #unless params[:q].present?
    #  @transactions = @transactions_query.result.where('DATE(CREATED_AT) = ?', Date.today)
    #end
    gon.status_filter = params[:q][:status_id] unless params[:q].nil?
    #raise @transactions_report.to_json
    respond_to do |format|
      format.html
      format.csv { send_data Transaction.to_csv(@transactions_report), filename: "transactions-#{DateTime.now}.csv" }
    end
  end
end