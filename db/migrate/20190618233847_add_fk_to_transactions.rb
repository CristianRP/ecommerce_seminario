class AddFkToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :delivery, foreign_key: true
  end
end
