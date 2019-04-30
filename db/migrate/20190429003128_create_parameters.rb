class CreateParameters < ActiveRecord::Migration[5.2]
  def change
    create_table :parameters do |t|
      t.string :tag
      t.string :description
      t.integer :int_value
      t.string :text_value

      t.timestamps
    end
    add_index :parameters, :tag
  end
end
