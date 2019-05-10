# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_dealer!
  around_action :rescue_from_fk_constraint, only: :destroy

  def rescue_from_fk_constraint
    yield
  rescue ActiveRecord::InvalidForeignKey
    redirect_to "/#{params[:controller]}", notice: t('activerecord.errors.messages.foreign_key.violation.has_dependencies'), alert: true
  end

  def api_request?
    request.format.json?
  end
end
