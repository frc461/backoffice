class Mentor < ActiveLdap::Base
  ldap_mapping dn_attribute: "mail",
               prefix: "ou=Mentors",
               classes: ["inetOrgPerson"]
  def groups
      Group.find(:all, filter: {member: self.dn.to_s})
  end
  
  def user
      User.find(dn)
  end
  
  def accounts
      Account.where(user_dn: self.dn.to_s)
  end

  def Mentor.list
      self.find(:all).map{|s| s.mail}
  end
end
