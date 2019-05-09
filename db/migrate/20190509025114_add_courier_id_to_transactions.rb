class AddCourierIdToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :courier_id, :int
  end
end
