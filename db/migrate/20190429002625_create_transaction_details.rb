class CreateTransactionDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_details do |t|
      t.belongs_to :transaction, foreign_key: true
      t.belongs_to :product, foreign_key: true
      t.decimal :unit_price
      t.decimal :quantity
      t.decimal :total

      t.timestamps
    end
  end
end
