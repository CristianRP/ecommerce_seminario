# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %w[show edit update destroy close_order change_status devolucion not_delivery view_tracking asign_courier return_to_stock]
  skip_before_action :not_admin

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions_query = if current_dealer.admin?
                            Transaction.where(type: Parameter.transaction_type_out).order(id: :desc).ransack(params[:q])
                          elsif current_dealer.grocer?
                            Transaction.pending_to_packing('SALE').ransack(params[:q])
                          elsif current_dealer.courier?
                            Transaction.pending_to_deliver('SALE', current_dealer.id).ransack(params[:q])
                          else
                            current_dealer.transactions.ransack(params[:q])
                          end
    @transactions = @transactions_query.result(distinct: true)
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show; end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    gon.type_param = type_param
    gon.is_grocer = current_dealer.grocer?
    if type_param[:type].to_i == Parameter.transaction_type_in.first.int_value
      @transaction.status = Status.initial('SALE').first
      @transaction.type = Parameter.transaction_type_in.first
      @transaction.dealer = current_dealer
      if @transaction.save
        redirect_to transaction_transaction_details_path(@transaction)
      end
    end
  end

  # GET /transactions/1/edit
  def edit
    gon.type_param = @transaction.type
    gon.is_grocer = current_dealer.grocer?
    gon.internal_delivery = @transaction.carrier.internal
    gon.carrier_id = @transaction.carrier_id
  end

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
      if @transaction.type_id == Parameter.transaction_type_out.first.int_value && @transaction.carrier.name == 'Cargo Expreso'
        @transaction.amount = TransactionDetail.get_total_order(@transaction.id).first.total_order
        @transaction.status = @transaction.status.parent
        @transaction.save
        delivery_ok = Delivery::Send.call(@transaction)
        respond_to do |format|
          if delivery_ok
            format.html { redirect_to transactions_path }
            format.json { render :show, status: :created, location: @transaction_detail }
          else
            format.html { redirect_to transaction_transaction_details_path(@transaction), notice: 'Error generando la guía a cargo expreso.', alert: true }
            format.json { render json: @transaction_detail.errors, status: :unprocessable_entity }
          end
        end && return
      end
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
    @transaction_liq = @transaction.status.parent
    @transaction.status = @transaction.status.parent
    respond_to do |format|
      if @transaction.save
        if !@transaction_liq.nil? && @transaction_liq.description == 'LIQUIDADA'
          format.html { redirect_to pendings_path }
        else
          format.html { redirect_to transactions_path }
        end
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

  # POST /transactions/change_status
  def not_delivery
    # TODO: THIS CAN BE HANDLE BY A BETTER WAY, GETS THE DESCRIPTION TEXT OF THE BUTTON
    # AFTER SEND AS A PARAMETER AND GETS IN THIS METHOD
    # ALSO THIS METHOD CAN BE ELIMINATED AND USE ONLY CHANGE_STATUS
    @transaction.status = Status.find_by_description('NO ENTREGADA')
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

  def asign_courier
    courier = Dealer.find_by_id(transaction_params[:courier_id])
    @transaction.courier = courier
    @transaction.status = @transaction.status.parent
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_path, turbolinks: false }
      else
        format.json { render json: courier.to_json, status: :not_found }
      end
    end
  end

  def delivered
    @transactions_query = Transaction.delivered_courier('SALE', current_dealer.id).ransack(params[:q])
    @transactions = @transactions_query.result(distinct: true)
  end

  def pendings
    @transactions_query = Transaction.delivered_liq('SALE').ransack(params[:q])
    @transactions = @transactions_query.result(distinct: true)
    @not_pendings = false
  end

  def pendings_not
    @transactions_query = Transaction.not_delivered_liq('SALE').ransack(params[:q])
    @transactions = @transactions_query.result(distinct: true)
    @not_pendings = true
    render :pendings
  end

  def on_route
    @transactions_query = Transaction.watching_to_deliver('SALE').ransack(params[:q])
    @pending_to_deliver = @transactions_query.result(distinct: true)
  end

  def return_to_stock
    @transaction.transaction_details.each do |td|
      product = Product.find(td.product.id)
      product.quantity += td.quantity
      product.balance = product.quantity
      product.save
    end
    @transaction.status = @transaction.status.parent
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_path }
      else
        format.html { redirect_to transactions_path, alert: 'Hubo un error' }
      end
    end
  end

  def restocks
    @transactions_query = Transaction.where(type: Parameter.transaction_type_in).ransack(params[:q])
    @transactions = @transactions_query.result(distinct: true)
  end

  def change_status_expreso
    # TODO VALIDACION
  end

  def view_tracking
    if @transaction.status.parent == Transaction.find_by_description('EN RUTA')
      respond_to do |format|
        format.html { redirect_to delivery_path }
      end
    end
    @transaction.status = @transaction.status.parent
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction.url_reference.nil? ? transactions_path : @transaction.url_reference }
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
        @transaction.type_id = 2
        @transaction.status = @transaction.status.parent
        @transaction.save
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
