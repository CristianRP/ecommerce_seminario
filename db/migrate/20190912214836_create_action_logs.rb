class CreateActionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :action_logs do |t|
      t.integer :transaction_id
      t.integer :user_id
      t.string :user_name
      t.string :action
      t.string :date_time

      t.timestamps
    end
  end
end
