class Dealer < ApplicationRecord
  validates :name, :last_name, :phone, :address, :comission, presence: true
  validates_numericality_of :comission, on: :create, message: I18n.t('errors.messages.not_a_number')
end
