require "application_system_test_case"

class TransactionsTest < ApplicationSystemTestCase
  setup do
    @transaction = transactions(:one)
  end

  test "visiting the index" do
    visit transactions_url
    assert_selector "h1", text: "Transactions"
  end

  test "creating a Transaction" do
    visit transactions_url
    click_on "New Transaction"

    fill_in "Address", with: @transaction.address
    fill_in "Address2", with: @transaction.address2
    fill_in "Amount", with: @transaction.amount
    fill_in "Carrier", with: @transaction.carrier_id
    fill_in "Client", with: @transaction.client
    fill_in "Dealer", with: @transaction.dealer_id
    fill_in "Description", with: @transaction.description
    fill_in "Phone", with: @transaction.phone
    fill_in "Status", with: @transaction.status_id
    fill_in "Tracking number", with: @transaction.tracking_number
    fill_in "Type", with: @transaction.type_id
    click_on "Create Transaction"

    assert_text "Transaction was successfully created"
    click_on "Back"
  end

  test "updating a Transaction" do
    visit transactions_url
    click_on "Edit", match: :first

    fill_in "Address", with: @transaction.address
    fill_in "Address2", with: @transaction.address2
    fill_in "Amount", with: @transaction.amount
    fill_in "Carrier", with: @transaction.carrier_id
    fill_in "Client", with: @transaction.client
    fill_in "Dealer", with: @transaction.dealer_id
    fill_in "Description", with: @transaction.description
    fill_in "Phone", with: @transaction.phone
    fill_in "Status", with: @transaction.status_id
    fill_in "Tracking number", with: @transaction.tracking_number
    fill_in "Type", with: @transaction.type_id
    click_on "Update Transaction"

    assert_text "Transaction was successfully updated"
    click_on "Back"
  end

  test "destroying a Transaction" do
    visit transactions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transaction was successfully destroyed"
  end
end
