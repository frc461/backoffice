class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :start
      t.datetime :finish
      t.boolean :required, default: false
      t.boolean :verified, default: false

      t.timestamps
    end
  end
end
