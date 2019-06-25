class AddGrocerToDealers < ActiveRecord::Migration[5.2]
  def change
    add_column :dealers, :grocer, :boolean, default: false
  end
end
