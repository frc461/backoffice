class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.text :content
      t.text :options
      t.text :permissions
      t.boolean :closed

      t.timestamps
    end
  end
end
