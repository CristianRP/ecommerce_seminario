# frozen_string_literal: true

class Status < ApplicationRecord
  belongs_to :parent, class_name: 'Status', foreign_key: :next, optional: true
  validates :description, presence: true

  before_save :upcase_attributes

  scope :initial, lambda {
    where(description: 'CREADA')
  }

  private

  def upcase_attributes
    self.description = description.upcase
    self.tag = tag.upcase
  end
end
