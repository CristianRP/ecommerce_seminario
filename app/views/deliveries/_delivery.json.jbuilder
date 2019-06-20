json.extract! delivery, :id, :recolection_id, :sender_name, :sender_address, :sender_phone, :receiver_name, :receiver_address, :receiver_phone, :receiver_contact, :receiver_nit, :populated_receiver_id, :populated_origin_id, :service_type, :secured_amount, :observations, :created_at, :updated_at
json.url delivery_url(delivery, format: :json)
