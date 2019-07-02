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
                        elsif @transaction.courier.nil?
                          Parameter.transaction_type_out.first.int_value
                        else
                          Parameter.transaction_type_in.first.int_value
                        end
    @status = Status.initial('SALE').first
    @current_dealer = current_dealer
    @delivery_params = params[:transaction][:delivery].permit(:recolection_id, :sender_name, :sender_address,
                                                              :sender_phone, :receiver_name, :receiver_address, :receiver_phone, :receiver_contact,
                                                              :receiver_nit, :populated_receiver_id, :populated_origin_id, :service_type,
                                                              :secured_amount, :observations)
    @sender_info = Parameter.sender_info
    @sender_name = @sender_info.find_by_description('SENDER_NAME').text_value
    @sender_address = @sender_info.find_by_description('SENDER_ADDRESS').text_value
    @sender_phone = @sender_info.find_by_description('SENDER_PHONE').text_value
    @sender_village = @sender_info.find_by_description('SENDER_VILLAGE_COD').text_value
  end

  def perform
    create_transaction
    @transaction
  end

  def create_transaction
    @transaction.type_id = @transaction_type
    @transaction.status = @status
    @transaction.dealer_id = @current_dealer.id
    @transaction.save
    unless @delivery_params.nil?
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
      pieces_params = @params[:transaction][:delivery][:piece].permit(:weight)
      unless pieces_params.nil?
        @piece = @del.pieces.new
        @piece.number_p = 1
        @piece.type_p = 2
        @piece.weight = pieces_params[:weight]
        @piece.save
      end
    end
  end
end
