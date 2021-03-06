# frozen_string_literal: true

class Dealer < ApplicationRecord

  has_many :transactions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :trackable
  validates :name, :last_name, :phone, :address, :comission, presence: true
  validates_numericality_of :comission, on: :create, message: I18n.t('errors.messages.not_a_number')

  scope :couriers, -> { where(courier: true) }

  def custom_name
    [id, [name, last_name].join(' ')].join(' | ')
  end

  def self.grocer?
    grocer == false
  end
end
