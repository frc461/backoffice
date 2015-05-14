class AddNotesToCheckin < ActiveRecord::Migration
  def change
    add_column :checkins, :notes, :text
  end
end
