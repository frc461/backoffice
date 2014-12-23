class Parent < ActiveLdap::Base
  ldap_mapping dn_attribute: "mail",
               prefix: "ou=Parents",
               classes: ["inetOrgPerson"]

  def groups
      Group.find(:all, filter: {member: self.dn.to_s})
  end

  def students
      [self.seeAlso].flatten.map{|s| Student.find(s.to_s)}
  end

  def user
      User.find(dn)
  end

  def accounts
      dns = [self.dn.to_s] + self.students.map{|s| s.dn.to_s}
      Account.where(user_dn: @dns)
  end
  
  def Parent.list
      self.find(:all).map{|s| s.mail}
  end
end
