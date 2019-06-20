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
    created = Delivery::Create.call(params, current_dealer, transaction_params)
    #@transaction = Transaction.new(transaction_params)
    #@transaction.type_id = Parameter.transaction_type_in.first.int_value
    #@transaction.status = Status.initial('SALE').first
    #@transaction.dealer = current_dealer
    #delivery_params = params[:transaction][:delivery].permit(:recolection_id, :sender_name, :sender_address,
    #                                                         :sender_phone, :receiver_name, :receiver_address, :receiver_phone, :receiver_contact,
    #                                                         :receiver_nit, :populated_receiver_id, :populated_origin_id, :service_type,
    #                                                         :secured_amount, :observations)
    #unless delivery_params.nil?
    #  del = Delivery.create(delivery_params)
    #  del.my_transaction = @transaction
    #  pieces_params = params[:transaction][:delivery][:piece].permit(:weight)
    #  unless pieces_params.nil?
    #    piece = del.pieces.new
    #    piece.number = 1
    #    piece.type = 2
    #    piece.weight = pieces_params[:weight]
    #    piece.save
    #  end
    #end
    respond_to do |format|
      if created
        
    
        #response = client.call(:generar_guia,
        #                       message: { 'Autenticacion' =>
        #                        { 'Login' => 'WSCOMERCIALIZADORA',
        #                          'Password' => '449079bd0fed25041b39edb59d2ab50e' },
        #                        'ListaRecolecciones' => {
        #                          'DatosRecoleccion' => {
        #                            'RecoleccionID' => @transaction.id,
        #                            'RemitenteNombre' => sender_info.find_by_description('SENDER_NAME').text_value,
        #                            'RemitenteDireccion' => sender_info.find_by_description('SENDER_ADDRESS').text_value,
        #                            'RemitenteTelefono' => sender_info.find_by_description('SENDER_PHONE').text_value,
        #                            'DestinatarioNombre' => @transaction.client,
        #                            'DestinatarioDireccion' => @transaction.address2,
        #                            'DestinatarioTelefono' => @transaction.phone,
        #                            'DestinatarioNit' => del.receiver_nit,
        #                            'CodigoPobladoDestino' => del.populated_receiver_id,
        #                            'CodigoPobladoOrigen' => del.populated_origin_id,
        #                            'TipoServicio' => del.service_type,
        #                            'CodigoCredito' => 0,
        #                            'MontoAsegurado' => del.secured_amount,
        #                            'Observaciones' => del.observations,
        #                            'Piezas' => {
        #                              'Pieza' => {
        #                                'NumeroPieza' => piece.number,
        #                                'TipoPieza' => piece.type,
        #                                'PesoPieza' => piece.weight,
        #                                'MontoCOD' => piece.amount_cod.nil? ? 0 : piece.amount_cod
        #                              }
        #                            }
        #                          }
        #                        } })
        #if response.success?
        #  puts response.to_json
        #  format.html { redirect_to transaction_transaction_details_path(@transaction), notice: t('forms.created', model: Transaction.model_name.human) }
        #  format.json { render :show, status: :created, location: @transaction }
        #end
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
end
