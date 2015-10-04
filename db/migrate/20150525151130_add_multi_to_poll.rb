class AddMultiToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :multiple, :boolean
  end
end
