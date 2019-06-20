class CreateVillages < ActiveRecord::Migration[5.2]
  def change
    create_table :villages do |t|
      t.string :cod
      t.string :name
      t.string :department_id
      t.string :municipality_id

      t.timestamps
    end
  end
end
