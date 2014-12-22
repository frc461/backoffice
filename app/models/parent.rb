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
end
