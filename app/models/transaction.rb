class Transaction < ActiveRecord::Base
    belongs_to :account
    monetize :amount_cents

    def poster
        User.find(poster_dn)
    end
    
    def sponsor
        Sponsor.find(sponsor_dn)
    end
end
