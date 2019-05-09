class AddAttributesToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :balance, :decimal
    add_column :products, :min, :decimal
    add_column :products, :max, :decimal
  end
end
