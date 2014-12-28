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

  def accounts
      Account.where(user_dn: self.dn)
  end

  def Student.list
      self.find(:all).map{|s| s.mail}
  end

  def Student.name_list
      h = {}
      self.find(:all).each do |u|
          h[u.mail] = {cn: u.cn, gn: u.gn, sn: u.sn}
      end
      h
  end
end
