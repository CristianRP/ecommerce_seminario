# frozen_string_literal: true

class Api::V1::InventoryUtilsController < ApplicationController

  protect_from_forgery with: :null_session, if: :api_request?, fallback: :none
  skip_before_action :authenticate_dealer!

  def check_inventory_qty
    render json: Product.find(inventory_utils_params[:productId])
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def inventory_utils_params
    params.permit(:productId)
  end
end
