class Checkin < ActiveRecord::Base
    def user
        User.find(self.user_dn)
    end
end
