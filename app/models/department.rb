class Department < ApplicationRecord
  include CustomName

  has_many :municipalities, class_name: :Municipality, foreign_key: :department_id, primary_key: :cod
end
