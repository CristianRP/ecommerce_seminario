class AddLoginAttributesToDealers < ActiveRecord::Migration[5.2]
  def change
    add_column :dealers, :email, :string
    add_column :dealers, :password, :string
    add_column :dealers, :admin, :boolean, default: false
    add_index :dealers, %i[email password]
  end
end
