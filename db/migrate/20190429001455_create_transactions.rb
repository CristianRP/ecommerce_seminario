class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :description
      t.string :client
      t.string :address
      t.string :address2
      t.string :phone
      t.decimal :amount
      t.references :status, foreign_key: true
      t.references :dealer, foreign_key: true
      t.integer :type_id
      t.string :tracking_number
      t.references :carrier, foreign_key: true

      t.timestamps
    end
    add_index :transactions, :type_id
  end
end
