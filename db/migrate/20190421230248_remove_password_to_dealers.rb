class RemovePasswordToDealers < ActiveRecord::Migration[5.2]
  def change
    remove_column :dealers, :password
  end
end
