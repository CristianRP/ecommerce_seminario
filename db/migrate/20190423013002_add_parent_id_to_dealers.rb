class AddParentIdToDealers < ActiveRecord::Migration[5.2]
  def change
    add_column :dealers, :parent_id, :integer
  end
end
