require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction = transactions(:one)
  end

  test "should get index" do
    get transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_transaction_url
    assert_response :success
  end

  test "should create transaction" do
    assert_difference('Transaction.count') do
      post transactions_url, params: { transaction: { address: @transaction.address, address2: @transaction.address2, amount: @transaction.amount, carrier_id: @transaction.carrier_id, client: @transaction.client, dealer_id: @transaction.dealer_id, description: @transaction.description, phone: @transaction.phone, status_id: @transaction.status_id, tracking_number: @transaction.tracking_number, type_id: @transaction.type_id } }
    end

    assert_redirected_to transaction_url(Transaction.last)
  end

  test "should show transaction" do
    get transaction_url(@transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_transaction_url(@transaction)
    assert_response :success
  end

  test "should update transaction" do
    patch transaction_url(@transaction), params: { transaction: { address: @transaction.address, address2: @transaction.address2, amount: @transaction.amount, carrier_id: @transaction.carrier_id, client: @transaction.client, dealer_id: @transaction.dealer_id, description: @transaction.description, phone: @transaction.phone, status_id: @transaction.status_id, tracking_number: @transaction.tracking_number, type_id: @transaction.type_id } }
    assert_redirected_to transaction_url(@transaction)
  end

  test "should destroy transaction" do
    assert_difference('Transaction.count', -1) do
      delete transaction_url(@transaction)
    end

    assert_redirected_to transactions_url
  end
end
