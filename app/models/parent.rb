class Parent < ActiveLdap::Base
  include Person
  ldap_mapping dn_attribute: "mail",
               prefix: "ou=Parents",
               classes: ["inetOrgPerson", "organizationalPerson", "person", "top"]

  def students
      if self.seeAlso(true).count > 0
          self.seeAlso(true).flatten.map{|s| Student.find(s.to_s)}
      else
          []
      end
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

  def Parent.create(mail, opts = {})
      p = Parent.new(mail)

      p.userPassword = opts[:password] || Rails.application.secrets.default_password
      p.gn = opts[:gn]
      p.sn = opts[:sn]
      p.cn = opts[:cn] || opts[:gn] + ' ' + opts[:sn]
      p.mobile = opts[:mobile]
      p.telephoneNumber = opts[:phone]
      p.homePostalAddress = opts[:address]
      if opts[:student]
          p.seeAlso = [Student.find(opts[:student]).dn]
      elsif opts[:students]
          p.seeAlso = opts[:students].map{|s| Student.find(s).dn}
      end

      if p.save
          p
      else
          nil
      end
  end
end
