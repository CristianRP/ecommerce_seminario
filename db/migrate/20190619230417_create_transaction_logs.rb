class CreateTransactionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_logs do |t|
      t.string :tag
      t.string :description
      t.string :started_at
      t.string :ended_at
      t.text :messages

      t.timestamps
    end
  end
end
