class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :description
      t.string :sku
      t.belongs_to :category, foreign_key: true
      t.boolean :active
      t.decimal :quantity
      t.decimal :price
      t.decimal :cost
      t.belongs_to :characteristic, foreign_key: true

      t.timestamps
    end
  end
end
