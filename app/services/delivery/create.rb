# frozen_string_literal: true

class Delivery::Create
  def self.call(params, current_dealer, transaction_params)
    new(params, current_dealer, transaction_params).call
  end

  def call
    perform
  end

  private

  attr_reader :params, :current_dealer, :transaction_params
  def initialize(params, current_dealer, transaction_params)
    @params = params
    @transaction = Transaction.new(transaction_params)
    @transaction_type = if transaction_params['type_id'].present? && transaction_params['type_id'].to_i == 3
                          Parameter.transaction_type_return.first.int_value
                        elsif !@transaction.courier.nil?
                          Parameter.transaction_type_out.first.int_value
                        else
                          Parameter.transaction_type_in.first.int_value
                        end
    @status = Status.initial('SALE').first
    @current_dealer = current_dealer
    initialize_delivery if @transaction.courier.nil? && @transaction_type != 3
  end

  def initialize_delivery
    @transaction_type = Parameter.transaction_type_out.first.int_value
    @delivery_params = params[:transaction][:delivery].permit(:recolection_id, :sender_name, :sender_address,
                                                              :sender_phone, :receiver_name, :receiver_address, :receiver_phone, :receiver_contact,
                                                              :receiver_nit, :populated_receiver_id, :populated_origin_id, :service_type,
                                                              :secured_amount, :observations)
    @pieces_params = params[:transaction][:delivery][:piece].permit(:weight)
    @sender_info = Parameter.sender_info
    @credito = Parameter.where(tag: 'CREDIT_OWNER').first.text_value
    @sender_name = @sender_info.find_by_description('SENDER_NAME').text_value
    @sender_address = @sender_info.find_by_description('SENDER_ADDRESS').text_value
    @sender_phone = @sender_info.find_by_description('SENDER_PHONE').text_value
    @auth = Parameter.auth
    @client = Savon.client(wsdl: @auth.find_by_description('WSDL').text_value, log: true)
  end

  def perform
    create_transaction
    generate
    @transaction
  end

  def create_transaction
    @transaction.type_id = @transaction_type
    @transaction.status = @status
    @transaction.dealer_id = @current_dealer.id
    if @delivery_params.nil?
      @transaction.save
    else
      @del = Delivery.create(@delivery_params)
      @del.sender_name = @sender_name
      @del.sender_address = @sender_address
      @del.sender_phone = @sender_phone
      @del.receiver_name = @transaction.client
      @del.receiver_address = @transaction.address2
      @del.receiver_phone = @transaction.phone
      @del.my_transaction = @transaction
      @transaction.save
      @del.recolection_id = @transaction.id
      @del.save
      pieces_params = @params[:transaction][:delivery][:piece].permit(:weight)
      unless pieces_params.nil?
        @piece = @del.pieces.new
        @piece.number = 1
        @piece.type = 2
        @piece.weight = pieces_params[:weight]
        @piece.save
      end
    end
  end

  def generate
    generate_guide if @transaction.save && @transaction.carrier && @transaction.carrier.internal == false
  end

  def generate_guide
    require 'savon'
    transaction_log = TransactionLog.new
    transaction_log.tag = 'GENERA_GUIA'
    transaction_log.description = 'Generación guia pedido'
    transaction_log.started_at = DateTime.now
    response = @client.call(:generar_guia,
                            message: { 'Autenticacion' =>
                             { 'Login' => @auth.find_by_description('LOGIN').text_value,
                               'Password' => @auth.find_by_description('PASSWORD').text_value },
                                       'ListaRecolecciones' => {
                                         'DatosRecoleccion' => {
                                           'RecoleccionID' => @transaction.id,
                                           'RemitenteNombre' => @sender_name,
                                           'RemitenteDireccion' => @sender_address,
                                           'RemitenteTelefono' => @sender_phone,
                                           'DestinatarioNombre' => @transaction.client,
                                           'DestinatarioDireccion' => @transaction.address2,
                                           'DestinatarioTelefono' => @transaction.phone,
                                           'DestinatarioContacto' => nil,
                                           'DestinatarioNIT' => @del.receiver_nit,
                                           'ReferenciaCliente1' => nil,
                                           'ReferenciaCliente2' => nil,
                                           'CodigoPobladoDestino' => @del.populated_receiver_id,
                                           'CodigoPobladoOrigen' => @del.populated_origin_id,
                                           'TipoServicio' => @del.service_type,
                                           'MontoCOD' => 0,
                                           'FormatoImpresion' => nil,
                                           'CodigoCredito' => @credito,
                                           'MontoAsegurado' => @del.secured_amount,
                                           'Observaciones' => @del.observations,
                                           'CodigoReferencia' => 0,
                                           'Piezas' => {
                                             'Pieza' => {
                                               'NumeroPieza' => @piece.number,
                                               'TipoPieza' => @piece.type,
                                               'PesoPieza' => @piece.weight,
                                               'MontoCOD' => @piece.amount_cod.nil? ? 0 : @piece.amount_cod,
                                               'TarifaPorPieza' => 0
                                             }
                                           }
                                         }
                                       } })

    if response.success?
      response_json = JSON.parse(response.to_json)
      if response_json['generar_guia_response']['resultado_generar_guia']['resultado_operacion_multiple']['resultado_exitoso']
        save_tracking_number(response_json['generar_guia_response']['resultado_generar_guia'])
      end
    end
    transaction_log.ended_at = DateTime.now
    transaction_log.messages = response.body
    transaction_log.save
  end

  def save_tracking_number(response_body)
    tracking_number = response_body['lista_recolecciones']['datos_recoleccion']['numero_guia']
    return if tracking_number.nil?

    @transaction.tracking_number = tracking_number
    @transaction.save
  end
end
