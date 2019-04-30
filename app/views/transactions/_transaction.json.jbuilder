json.extract! transaction, :id, :description, :client, :address, :address2, :phone, :amount, :status_id, :dealer_id, :type_id, :tracking_number, :carrier_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
