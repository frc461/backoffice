class Account < ActiveRecord::Base
    monetize :balance_cents
    has_many :transactions

    def friendly_user
        if self.user_dn.empty?
            "System/System"
        else
            if x = User.find(:first, self.user_dn)
                x.friendly
            else
                nil
            end
        end
    end

    def user
       if x = User.find(:first, self.user_dn)
           x.me
       else
           nil
       end
    end
end
