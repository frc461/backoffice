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

  def set_initial_accounts
      Account.create(code: "M", name: "Incidentals", description: "Miscellaneous money for food, shirts, etc.", user_dn: self.dn.to_s)
  end
  def Parent.list
      self.find(:all).map{|s| s.mail}
  end

  def Parent.name_list
      h = {}
      self.find(:all).each do |u|
          h[u.mail] = {cn: u.cn, gn: u.gn, sn: u.sn}
      end
      h
  end
end
