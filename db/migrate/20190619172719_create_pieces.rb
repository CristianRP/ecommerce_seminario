class CreatePieces < ActiveRecord::Migration[5.2]
  def change
    create_table :pieces do |t|
      t.integer :number
      t.string :type
      t.decimal :weight
      t.decimal :amount_cod
      t.belongs_to :delivery, foreign_key: true

      t.timestamps
    end
  end
end
