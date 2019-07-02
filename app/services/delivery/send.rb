# frozen_string_literal: true

class Delivery::Send
  def self.call(transaction)
    new(transaction).call
  end

  def call
    perform
  end

  def initialize(transaction)
    @transaction = transaction
    initialize_delivery #if @transaction.courier.nil? && (@transaction_type != 3 && @transaction_type != 1)
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
      #@ref1 += [' ] ', t.product.custom_name_order].join('[')
    end
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
                                           'FormatoImpresion' => nil,
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
    @transaction.save
  end
end