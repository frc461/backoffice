class Account < ActiveRecord::Base
    monetize :balance_cents
    has_many :transactions

    def friendly_user
        if self.user_dn.empty?
            "System/System"
        else
            User.find(self.user_dn).friendly
        end
    end

    def user
        User.find(self.user_dn).me
    end
end
