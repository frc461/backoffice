class Sponsor < ActiveLdap::Base
    include Person

  ldap_mapping dn_attribute: "o",
               prefix: "ou=Sponsors",
               classes: ["organization"]

  def transactions
      Transaction.where(sponsor_dn: dn.to_s)
  end

  def Sponsor.create o, opts={}
      m = Sponsor.new o

      m.description = opts[:description]
      m.l = opts[:l]
      m.postalAddress = opts[:postalAddress] 
      m.telephoneNumber = opts[:telephoneNumber]

      if m.save
          m
      else
          nil
      end
  end

end
