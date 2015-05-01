class Vote < ActiveRecord::Base
    belongs_to :poll

    def user
        if x = User.find(:first, self.user_dn)
            x.me
        else
            nil
        end
    end
end
