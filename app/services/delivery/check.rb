class Delivery::Check

  def self.call(transaction)
    new(transaction).call
  end

  def call
    perform
  end

  def initialize(transaction)
    @transaction = transaction
    @auth = Parameter.auth
    @client = Savon.client(wsdl: @auth.find_by_description('WSDL').text_value, log: true)
  end

  private

  def check_status
    require 'savon'
    transaction_log = TransactionLog.new
    transaction_log.tag = 'GET_TRACKING'
    transaction_log.description = 'Get tracking of an order'
    transaction_log.started_at = DateTime.now
    response = @client.call(:obtener_tracking_guia,
                              message: { 'Autenticacion' =>
                                        { 'Login' => @auth.find_by_description('LOGIN').text_value,
                                          'Password' => @auth.find_by_description('PASSWORD').text_value }}, 'NumeroGuia' => transaction.tracking_number)
  end


  #response = @client.call(:obtener_tracking_guia,message: { 'Autenticacion' =>{ 'Login' => @auth.find_by_description('LOGIN').text_value,'Password' => @auth.find_by_description('PASSWORD').text_value }}, 'NumeroGuia' => transaction.tracking_number)
end