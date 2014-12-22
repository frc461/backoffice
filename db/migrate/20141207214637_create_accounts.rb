class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.text :description
      t.money :balance
      t.string :user_dn

      t.timestamps
    end
  end
end
