# frozen_string_literal: true

module CustomName
  extend ActiveSupport::Concern

  included do
    def custom_name
      [cod, name].join(' | ')
    end
  end
end
