json.extract! product, :id, :description, :sku, :category_id, :active, :quantity, :price, :cost, :characteristic_id, :created_at, :updated_at
json.url product_url(product, format: :json)
