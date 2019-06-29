class Municipality < ApplicationRecord
  include CustomName
  has_many :villages, class_name: :Village, foreign_key: :municipality_id, primary_key: :cod
end
