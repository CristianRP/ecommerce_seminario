# frozen_string_literal: true

module Active
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(active: true) }
    scope :not_active, -> { where(active: false) }
  end
end
