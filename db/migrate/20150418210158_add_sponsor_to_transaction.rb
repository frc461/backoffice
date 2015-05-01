class AddSponsorToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :sponsor_dn, :string
  end
end
