# frozen_string_literal: true

Ransack.configure do |config|
  config.add_predicate 'date_equals',
                       arel_predicate: 'eq',
                       formatter: proc { |v| v.to_date },
                       validator: proc { |v| v.present? },
                       type: :string

  config.add_predicate 'between',
                        arel_predicate: 'between',
                        formatter: proc { |v| Range.new(*v.split(' to ').map { |s| s })},
                        type: :string
end
