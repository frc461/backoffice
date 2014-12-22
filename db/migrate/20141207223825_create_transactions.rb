class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :poster_dn
      t.string :description
      t.string :icon
      t.money :amount
      t.integer :account_id

      t.timestamps
    end
  end
end
