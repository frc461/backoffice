class Student < ActiveLdap::Base
  ldap_mapping dn_attribute: "mail",
               prefix: "ou=Students",
               classes: ["inetOrgPerson"]

  def groups
      Group.find(:all, filter: {member: self.dn.to_s})
  end
  
  def parents
      Parent.find(:all, filter: {seeAlso: self.dn.to_s})
  end

  def user
      User.find(dn)
  end
end
