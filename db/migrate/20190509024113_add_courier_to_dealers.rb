class AddCourierToDealers < ActiveRecord::Migration[5.2]
  def change
    add_column :dealers, :courier, :boolean, default: false
  end
end
