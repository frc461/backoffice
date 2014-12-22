class News < ActiveRecord::Base
    def user
        User.find(user_dn)
    end
end
