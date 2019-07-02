class RemoveNumberTypeToPieces < ActiveRecord::Migration[5.2]
  def change
    remove_column :pieces, :number
    remove_column :pieces, :type
    add_column :pieces, :number_p, :integer
    add_column :pieces, :type_p, :string
  end
end
