# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %w[show edit update destroy close_order change_status]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = current_dealer.admin? ? Transaction.all : current_dealer.transactions
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show; end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit; end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.type_id = Parameter.transaction_type_in.first.int_value
    @transaction.status_id = Status.initial('SALE').first.id
    @transaction.dealer_id = current_dealer.id
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transaction_transaction_details_path(@transaction), t('forms.created', model: Transaction.model_name.human) }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /transactions/close_order
  def close_order
    if @transaction.transaction_details.empty?
      respond_to do |format|
        format.html { redirect_to transaction_transaction_details_path(@transaction), notice: t('activerecord.errors.messages.must_have_child'), alert: true }
        format.json { render json: @transaction_detail.errors, status: :unprocessable_entity }
      end
    else
      @transaction.amount = TransactionDetail.get_total_order(@transaction.id).first.total_order
      @transaction.status = @transaction.status.next
      respond_to do |format|
        if @transaction.save
          format.html { redirect_to transactions_path }
          format.json { render :show, status: :created, location: @transaction_detail }
        else
          format.html { render :new }
          format.json { render json: @transaction_detail.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # POST /transactions/change_status
  def change_status
    @transaction.status = @transaction.status.next
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_path }
        format.json { render :show, status: :created, location: @transaction_detail }
      else
        format.html { render :new }
        format.json { render json: @transaction_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transactions_path, notice: t('forms.updated', model: Transaction.model_name.human) }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: t('forms.deleted', model: Transaction.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id].present? ? params[:id] : params[:transaction_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transaction_params
    params.require(:transaction).permit(:description, :client, :address, :address2, :phone, :amount, :status_id, :dealer_id, :type_id, :tracking_number, :carrier_id, :courier_id)
  end
end
