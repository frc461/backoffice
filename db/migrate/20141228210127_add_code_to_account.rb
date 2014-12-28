class AddCodeToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :code, :string
    add_index :accounts, [:code, :user_dn], unique: true
  end
end
