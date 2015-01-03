class Parent < ActiveLdap::Base
  include Person
  ldap_mapping dn_attribute: "mail",
               prefix: "ou=Parents",
               classes: ["inetOrgPerson"]

  def students
      [self.seeAlso].flatten.map{|s| Student.find(s.to_s)}
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
