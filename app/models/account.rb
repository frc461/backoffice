class Account < ActiveRecord::Base
    monetize :balance_cents
    has_many :transactions, dependent: :destroy

    def Account.CODES
        {
            '0' => 'Testing',
            'D' => 'Dues',
            'X' => 'General Team',
            'M' => 'Miscellaneous'
        }
    end

    def full_name
        "#{code} - #{name} - #{user_dn.empty? ? "System" : friendly_user}"
    end

    def income
        q = transactions.where('amount_cents > 0')
        if q.count > 0
            q.map(&:amount_cents).inject(:+)
        else
            0
        end
    end

    def expenses
        q = transactions.where('amount_cents < 0')
        if q.count > 0
            q.map(&:amount_cents).inject(:+)
        else
            0
        end
    end

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

    def rollover
        if code == "D"
            balance_cents = 0
            transactions.all.each(&:delete)
            save
        else
            b = balance
            transactions.all.each(&:delete)
            t = transactions.build(poster_dn: nil, amount: b, icon: 'calendar', description: 'Starting Balance')
            t.save
            save
        end
    end
end
