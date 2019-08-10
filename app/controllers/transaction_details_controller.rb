# frozen_string_literal: true

class TransactionDetailsController < ApplicationController
  before_action :set_transaction_detail, only: %i[show edit update destroy]
  before_action :set_transaction, only: %w[index new create edit update destroy]
  skip_before_action :not_admin

  # GET /transaction_details
  # GET /transaction_details.json
  def index
    @transaction_details = @transaction.transaction_details
    gon.current_dealer = current_dealer
    @title = if @transaction.type_id == Parameter.transaction_type_return.first.int_value
               Parameter.transaction_type_return.first.text_value
             elsif @transaction.type_id == Parameter.transaction_type_in.first.int_value
               I18n.t('modules.restock')
             else
               I18n.t('activerecord.models.transaction')
             end
  end

  # GET /transaction_details/1
  # GET /transaction_details/1.json
  def show; end

  # GET /transaction_details/new
  def new
    @transaction_detail = @transaction.transaction_details.new
    gon.transaction_type = @transaction.type_id
  end

  # GET /transaction_details/1/edit
  def edit; end

  # POST /transaction_details
  # POST /transaction_details.json
  def create
    @transaction_detail = Transaction::Create.call(transaction_detail_params, @transaction)
    respond_to do |format|
      if @transaction_detail.valid?
        format.html { redirect_to transaction_transaction_details_path(@transaction), notice: t('forms.created', model: TransactionDetail.model_name.human) }
        format.json { render :show, status: :created, location: @transaction_detail }
      else
        format.html { render :new }
        format.json { render json: @transaction_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transaction_details/1
  # PATCH/PUT /transaction_details/1.json
  def update
    respond_to do |format|
      if @transaction_detail.update(transaction_detail_params)
        format.html { redirect_to new_transaction_transaction_detail_path(@transaction), notice: t('forms.updated', model: TransactionDetail.model_name.human) }
        format.json { render :show, status: :ok, location: @transaction_detail }
      else
        format.html { render :edit }
        format.json { render json: @transaction_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_details/1
  # DELETE /transaction_details/1.json
  def destroy
    Transaction::Destroy.call(@transaction_detail)
    respond_to do |format|
      format.html { redirect_to transaction_transaction_details_url, notice: t('forms.deleted', model: TransactionDetail.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction_detail
    @transaction_detail = TransactionDetail.find(params[:id])
  end

  def set_transaction
    gon.transaction = @transaction = Transaction.find(params[:transaction_id])
    gon.closed = @transaction.closed?('SALE')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transaction_detail_params
    params.require(:transaction_detail).permit(:transaction_id, :product_id, :unit_price, :quantity, :total)
  end
end
