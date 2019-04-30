json.extract! transaction_detail, :id, :transaction_id, :product_id, :unit_price, :quantity, :total, :created_at, :updated_at
json.url transaction_detail_url(transaction_detail, format: :json)
