class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.string :recolection_id
      t.string :sender_name
      t.string :sender_address
      t.string :sender_phone
      t.string :receiver_name
      t.string :receiver_address
      t.string :receiver_phone
      t.string :receiver_contact
      t.string :receiver_nit
      t.string :populated_receiver_id
      t.string :populated_origin_id
      t.string :service_type
      t.decimal :secured_amount
      t.text :observations

      t.timestamps
    end
  end
end
