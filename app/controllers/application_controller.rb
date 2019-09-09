# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include RansackMemory::Concern
  protect_from_forgery with: :exception
  before_action :authenticate_dealer!
  around_action :rescue_from_fk_constraint, only: :destroy
  before_action :not_admin
  before_action :save_and_load_filters

  def rescue_from_fk_constraint
    yield
  rescue ActiveRecord::InvalidForeignKey
    redirect_to "/#{params[:controller]}", notice: t('activerecord.errors.messages.foreign_key.violation.has_dependencies'), alert: true
  end

  def api_request?
    request.format.json?
  end

  def not_admin
    redirect_to transactions_path unless current_dealer.admin?
  end

  def not_dealer
    redirect_to transactions_path if current_dealer.grocer? || current_dealer.courier?
  end
end
