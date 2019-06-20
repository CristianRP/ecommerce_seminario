require 'test_helper'

class DeliveriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @delivery = deliveries(:one)
  end

  test "should get index" do
    get deliveries_url
    assert_response :success
  end

  test "should get new" do
    get new_delivery_url
    assert_response :success
  end

  test "should create delivery" do
    assert_difference('Delivery.count') do
      post deliveries_url, params: { delivery: { observations: @delivery.observations, populated_origin_id: @delivery.populated_origin_id, populated_receiver_id: @delivery.populated_receiver_id, receiver_address: @delivery.receiver_address, receiver_contact: @delivery.receiver_contact, receiver_name: @delivery.receiver_name, receiver_nit: @delivery.receiver_nit, receiver_phone: @delivery.receiver_phone, recolection_id: @delivery.recolection_id, secured_amount: @delivery.secured_amount, sender_address: @delivery.sender_address, sender_name: @delivery.sender_name, sender_phone: @delivery.sender_phone, service_type: @delivery.service_type } }
    end

    assert_redirected_to delivery_url(Delivery.last)
  end

  test "should show delivery" do
    get delivery_url(@delivery)
    assert_response :success
  end

  test "should get edit" do
    get edit_delivery_url(@delivery)
    assert_response :success
  end

  test "should update delivery" do
    patch delivery_url(@delivery), params: { delivery: { observations: @delivery.observations, populated_origin_id: @delivery.populated_origin_id, populated_receiver_id: @delivery.populated_receiver_id, receiver_address: @delivery.receiver_address, receiver_contact: @delivery.receiver_contact, receiver_name: @delivery.receiver_name, receiver_nit: @delivery.receiver_nit, receiver_phone: @delivery.receiver_phone, recolection_id: @delivery.recolection_id, secured_amount: @delivery.secured_amount, sender_address: @delivery.sender_address, sender_name: @delivery.sender_name, sender_phone: @delivery.sender_phone, service_type: @delivery.service_type } }
    assert_redirected_to delivery_url(@delivery)
  end

  test "should destroy delivery" do
    assert_difference('Delivery.count', -1) do
      delete delivery_url(@delivery)
    end

    assert_redirected_to deliveries_url
  end
end
