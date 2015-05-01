class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :poll_id
      t.string :user_dn
      t.string :value

      t.timestamps
    end
  end
end
