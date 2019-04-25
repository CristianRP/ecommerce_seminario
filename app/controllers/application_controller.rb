class ApplicationController < ActionController::Base
  around_action :rescue_from_fk_constraint, only: :destroy

  def rescue_from_fk_constraint
    begin
      yield
    rescue ActiveRecord::InvalidForeignKey
      redirect_to "/#{params[:controller]}",  notice: t('activerecord.errors.messages.foreign_key.violation.has_dependencies'), alert: true
    end
  end  
end
