# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %w[show edit update destroy close_order change_status devolucion]
  skip_before_action :not_admin

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = if current_dealer.admin?
                      Transaction.all
                    elsif current_dealer.grocer?
                      Transaction.pending_to_packing('SALE')
                    elsif current_dealer.courier?
                      Transaction.pending_to_deliver('SALE')
                    else
                      current_dealer.transactions
                    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show; end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    gon.type_param = type_param
  end

  # GET /transactions/1/edit
  def edit; end

  # POST /transactions
  # POST /transactions.json
  def create
    created = Delivery::Create.call(params, current_dealer, transaction_params)
    respond_to do |format|
      if created
        format.html { redirect_to transaction_transaction_details_path(created), notice: t('forms.created', model: Transaction.model_name.human) }
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
      @transaction.status = @transaction.status.parent
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
    if @transaction.status.parent == Transaction.find_by_description('EN RUTA')
      respond_to do |format|
        format.html { redirect_to delivery_path }
      end
    end
    @transaction.status = @transaction.status.parent
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

  # POST /transactions/change_status
  def devolucion
    # TODO: THIS CAN BE HANDLE BY A BETTER WAY, GETS THE DESCRIPTION TEXT OF THE BUTTON
    # AFTER SEND AS A PARAMETER AND GETS IN THIS METHOD
    # ALSO THIS METHOD CAN BE ELIMINATED AND USE ONLY CHANGE_STATUS
    @transaction.status = Status.find_by_description('DEVOLUCION')
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
    @transaction.transaction_details.each do |td|
      Transaction::Destroy.call(td)
    end
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
    params.require(:transaction).permit(:description, :client, :address, :address2, :phone, :amount, :status_id, :dealer_id, :type_id, :tracking_number,
                                        :carrier_id, :courier_id, :populated_receiver_id, :populated_origin_id, :service_type)
  end

  def type_param
    params.permit(:type)
  end
end
