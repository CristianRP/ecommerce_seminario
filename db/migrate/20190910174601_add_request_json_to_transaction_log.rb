class AddRequestJsonToTransactionLog < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_logs, :request_json, :text
  end
end
