class AddIndexForCheckins < ActiveRecord::Migration
  def change
      add_index "checkins", ["user_dn", "meeting_id"], :unique => true
  end
end
