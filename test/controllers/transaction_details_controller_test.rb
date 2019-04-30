require 'test_helper'

class TransactionDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction_detail = transaction_details(:one)
  end

  test "should get index" do
    get transaction_details_url
    assert_response :success
  end

  test "should get new" do
    get new_transaction_detail_url
    assert_response :success
  end

  test "should create transaction_detail" do
    assert_difference('TransactionDetail.count') do
      post transaction_details_url, params: { transaction_detail: { product_id: @transaction_detail.product_id, quantity: @transaction_detail.quantity, total: @transaction_detail.total, transaction_id: @transaction_detail.transaction_id, unit_price: @transaction_detail.unit_price } }
    end

    assert_redirected_to transaction_detail_url(TransactionDetail.last)
  end

  test "should show transaction_detail" do
    get transaction_detail_url(@transaction_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_transaction_detail_url(@transaction_detail)
    assert_response :success
  end

  test "should update transaction_detail" do
    patch transaction_detail_url(@transaction_detail), params: { transaction_detail: { product_id: @transaction_detail.product_id, quantity: @transaction_detail.quantity, total: @transaction_detail.total, transaction_id: @transaction_detail.transaction_id, unit_price: @transaction_detail.unit_price } }
    assert_redirected_to transaction_detail_url(@transaction_detail)
  end

  test "should destroy transaction_detail" do
    assert_difference('TransactionDetail.count', -1) do
      delete transaction_detail_url(@transaction_detail)
    end

    assert_redirected_to transaction_details_url
  end
end
