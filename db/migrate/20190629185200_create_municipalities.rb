class CreateMunicipalities < ActiveRecord::Migration[5.2]
  def change
    create_table :municipalities do |t|
      t.string :cod
      t.string :name
      t.string :department_id
      t.string :header_id

      t.timestamps
    end
  end
end
