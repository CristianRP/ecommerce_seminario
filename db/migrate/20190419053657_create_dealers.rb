class CreateDealers < ActiveRecord::Migration[5.2]
  def change
    create_table :dealers do |t|
      t.string :name
      t.string :last_name
      t.string :phone
      t.string :address
      t.decimal :comission

      t.timestamps
    end
  end
end
