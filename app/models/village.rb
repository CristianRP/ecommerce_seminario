# frozen_string_literal: true

class Village < ApplicationRecord
  def custom_name
    [cod, name].join(' | ')
  end
end
