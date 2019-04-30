require "application_system_test_case"

class TransactionDetailsTest < ApplicationSystemTestCase
  setup do
    @transaction_detail = transaction_details(:one)
  end

  test "visiting the index" do
    visit transaction_details_url
    assert_selector "h1", text: "Transaction Details"
  end

  test "creating a Transaction detail" do
    visit transaction_details_url
    click_on "New Transaction Detail"

    fill_in "Product", with: @transaction_detail.product_id
    fill_in "Quantity", with: @transaction_detail.quantity
    fill_in "Total", with: @transaction_detail.total
    fill_in "Transaction", with: @transaction_detail.transaction_id
    fill_in "Unit price", with: @transaction_detail.unit_price
    click_on "Create Transaction detail"

    assert_text "Transaction detail was successfully created"
    click_on "Back"
  end

  test "updating a Transaction detail" do
    visit transaction_details_url
    click_on "Edit", match: :first

    fill_in "Product", with: @transaction_detail.product_id
    fill_in "Quantity", with: @transaction_detail.quantity
    fill_in "Total", with: @transaction_detail.total
    fill_in "Transaction", with: @transaction_detail.transaction_id
    fill_in "Unit price", with: @transaction_detail.unit_price
    click_on "Update Transaction detail"

    assert_text "Transaction detail was successfully updated"
    click_on "Back"
  end

  test "destroying a Transaction detail" do
    visit transaction_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transaction detail was successfully destroyed"
  end
end
