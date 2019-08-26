class AddOldAttrsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :old_price, :decimal
    add_column :products, :old_cost, :decimal
  end
end
