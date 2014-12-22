class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :content
      t.string :user_dn
      t.string :icon, default: 'newspaper-o'
      t.boolean :public, default: false

      t.timestamps
    end
  end
end
