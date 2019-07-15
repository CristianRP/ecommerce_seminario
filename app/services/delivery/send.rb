# frozen_string_literal: true

class Delivery::Send
  def self.call(transaction, params)
    new(transaction, params).call
  end

  def call
    perform
  end

  def initialize(transaction, params)
    @transaction = transaction
    @params = params
    initialize_delivery # if @transaction.courier.nil? && (@transaction_type != 3 && @transaction_type != 1)
  end

  def initialize_delivery
    @credito = Parameter.where(tag: 'CREDIT_OWNER').first.text_value
    @delivery = @transaction.delivery
    @auth = Parameter.auth
    @client = Savon.client(wsdl: @auth.find_by_description('WSDL').text_value, log: true)
    @weight = 0
    @ref1 = ''
    @amount = 0
    @transaction.transaction_details.each do |t|
      @weight += (t.product.weight * t.quantity)
      @amount += t.product.price.nil? ? 0 : t.product.price
      # @ref1 += [' ] ', t.product.custom_name_order].join('[')
    end
    @transaction_type = if @transaction.type_id.present? && @transaction.type_id.to_i == 3
                          Parameter.transaction_type_return.first.int_value
                        elsif @transaction.type_id.present? && @transaction.type_id.to_i == 1
                          Parameter.transaction_type_in.first.int_value
                        else
                          Parameter.transaction_type_out.first.int_value
                        end
    if @transaction_type == Parameter.transaction_type_out.first.int_value # && @transaction.courier.nil?
      @delivery_params = @params[:transaction][:delivery].permit(:recolection_id, :sender_name, :sender_address,
                                                                :sender_phone, :receiver_name, :receiver_address, :receiver_phone, :receiver_contact,
                                                                :receiver_nit, :populated_receiver_id, :populated_origin_id, :service_type,
                                                                :secured_amount, :observations)
    end
    @status = Status.initial('SALE').first
    @sender_info = Parameter.sender_info
    @sender_name = @sender_info.find_by_description('SENDER_NAME').text_value
    @sender_address = @sender_info.find_by_description('SENDER_ADDRESS').text_value
    @sender_phone = @sender_info.find_by_description('SENDER_PHONE').text_value
    @sender_village = @sender_info.find_by_description('SENDER_VILLAGE_COD').text_value
    @ref1 = @transaction.transaction_details.first.product.custom_name_order
    @ref2 = @transaction.transaction_details.second.nil? ? '' : @transaction.transaction_details.second.product.custom_name_order
  end

  def perform
    generate
  end

  private

  def generate
    generate_guide
  end

  def generate_guide
    @transaction.status = @status.parent
    @transaction.save
    @del = Delivery.create(@delivery_params)
    @del.sender_name = @sender_name
    @del.sender_address = @sender_address
    @del.sender_phone = @sender_phone
    @del.receiver_name = @transaction.client
    @del.receiver_address = @transaction.address2
    @del.receiver_phone = @transaction.phone
    @del.my_transaction = @transaction
    @del.populated_origin_id = @sender_village
    @transaction.save
    @del.recolection_id = @transaction.id
    @del.save
    @delivery = @transaction.delivery
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
                                           'RemitenteNombre' => @delivery.sender_name,
                                           'RemitenteDireccion' => @delivery.sender_address,
                                           'RemitenteTelefono' => @delivery.sender_phone,
                                           'DestinatarioNombre' => @transaction.client,
                                           'DestinatarioDireccion' => @transaction.address2,
                                           'DestinatarioTelefono' => @transaction.phone,
                                           'DestinatarioContacto' => nil,
                                           'DestinatarioNIT' => @delivery.receiver_nit,
                                           'ReferenciaCliente1' => @ref1,
                                           'ReferenciaCliente2' => @ref2,
                                           'CodigoPobladoDestino' => @delivery.populated_receiver_id,
                                           'CodigoPobladoOrigen' => @delivery.populated_origin_id,
                                           'TipoServicio' => @delivery.service_type,
                                           'MontoCOD' => @amount,
                                           'FormatoImpresion' => 1,
                                           'CodigoCredito' => @credito,
                                           'MontoAsegurado' => @amount,
                                           'Observaciones' => @delivery.observations,
                                           'CodigoReferencia' => 0,
                                           'Piezas' => {
                                             'Pieza' => {
                                               'NumeroPieza' => '1',
                                               'TipoPieza' => '2',
                                               'PesoPieza' => @weight.to_s,
                                               'MontoCOD' => @amount,
                                               'TarifaPorPieza' => 0
                                             }
                                           }
                                         }
                                       } })

    if response.success?
      response_json = JSON.parse(response.to_json)
      if response_json['generar_guia_response']['resultado_generar_guia']['resultado_operacion_multiple']['resultado_exitoso']
        if response_json['generar_guia_response']['resultado_generar_guia']['resultado_operacion_multiple']['mensaje_error'].include?('Recolecciones Fallidas=1')
          return false
        else
          save_tracking_number(response_json['generar_guia_response']['resultado_generar_guia'])
        end
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
    @transaction.url_recolection = response_body['lista_recolecciones']['datos_recoleccion']['url_recoleccion']
    @transaction.url_reference = response_body['lista_recolecciones']['datos_recoleccion']['url_consulta']
    @transaction.save
  end
end
