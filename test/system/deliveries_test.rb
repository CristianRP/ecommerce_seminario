require "application_system_test_case"

class DeliveriesTest < ApplicationSystemTestCase
  setup do
    @delivery = deliveries(:one)
  end

  test "visiting the index" do
    visit deliveries_url
    assert_selector "h1", text: "Deliveries"
  end

  test "creating a Delivery" do
    visit deliveries_url
    click_on "New Delivery"

    fill_in "Observations", with: @delivery.observations
    fill_in "Populated origin", with: @delivery.populated_origin_id
    fill_in "Populated receiver", with: @delivery.populated_receiver_id
    fill_in "Receiver address", with: @delivery.receiver_address
    fill_in "Receiver contact", with: @delivery.receiver_contact
    fill_in "Receiver name", with: @delivery.receiver_name
    fill_in "Receiver nit", with: @delivery.receiver_nit
    fill_in "Receiver phone", with: @delivery.receiver_phone
    fill_in "Recolection", with: @delivery.recolection_id
    fill_in "Secured amount", with: @delivery.secured_amount
    fill_in "Sender address", with: @delivery.sender_address
    fill_in "Sender name", with: @delivery.sender_name
    fill_in "Sender phone", with: @delivery.sender_phone
    fill_in "Service type", with: @delivery.service_type
    click_on "Create Delivery"

    assert_text "Delivery was successfully created"
    click_on "Back"
  end

  test "updating a Delivery" do
    visit deliveries_url
    click_on "Edit", match: :first

    fill_in "Observations", with: @delivery.observations
    fill_in "Populated origin", with: @delivery.populated_origin_id
    fill_in "Populated receiver", with: @delivery.populated_receiver_id
    fill_in "Receiver address", with: @delivery.receiver_address
    fill_in "Receiver contact", with: @delivery.receiver_contact
    fill_in "Receiver name", with: @delivery.receiver_name
    fill_in "Receiver nit", with: @delivery.receiver_nit
    fill_in "Receiver phone", with: @delivery.receiver_phone
    fill_in "Recolection", with: @delivery.recolection_id
    fill_in "Secured amount", with: @delivery.secured_amount
    fill_in "Sender address", with: @delivery.sender_address
    fill_in "Sender name", with: @delivery.sender_name
    fill_in "Sender phone", with: @delivery.sender_phone
    fill_in "Service type", with: @delivery.service_type
    click_on "Update Delivery"

    assert_text "Delivery was successfully updated"
    click_on "Back"
  end

  test "destroying a Delivery" do
    visit deliveries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Delivery was successfully destroyed"
  end
end
