class AddUrlConsultaToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :url_reference, :text
    add_column :transactions, :url_recolection, :text
  end
end
