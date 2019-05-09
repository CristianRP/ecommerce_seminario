class AddInternalToCarriers < ActiveRecord::Migration[5.2]
  def change
    add_column :carriers, :internal, :boolean, default: false
  end
end
