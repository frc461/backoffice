class Sponsor < ActiveLdap::Base
    include Person

  ldap_mapping dn_attribute: "o",
               prefix: "ou=Sponsors",
               classes: ["organization"]

  def transactions
      Transaction.where(sponsor_dn: dn.to_s)
  end
end
