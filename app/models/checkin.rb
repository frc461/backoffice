class Checkin < ActiveRecord::Base
    belongs_to :meeting
    def user
        User.find(self.user_dn)
    end
end
