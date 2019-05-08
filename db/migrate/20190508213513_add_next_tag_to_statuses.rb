class AddNextTagToStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :statuses, :next, :int
    add_column :statuses, :tag, :string
  end
end
