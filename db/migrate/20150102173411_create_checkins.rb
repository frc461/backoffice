class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :meeting_id
      t.string :user_dn

      t.timestamps
    end
  end
end
