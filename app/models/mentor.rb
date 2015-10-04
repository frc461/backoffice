class Mentor < ActiveLdap::Base
  include Person
  ldap_mapping dn_attribute: "mail",
               prefix: "ou=Mentors",
               classes: ["inetOrgPerson"]
  
  def set_initial_accounts
      Account.create(code: "M", name: "Incidentals", description: "Miscellaneous money for food, shirts, etc.", user_dn: self.dn.to_s)
  end

  def Mentor.list
      self.find(:all).map{|s| s.mail}
  end

  def Mentor.name_list
      h = {}
      self.find(:all).each do |u|
          h[u.mail] = {cn: u.cn, gn: u.gn, sn: u.sn}
      end
      h
  end

  def Mentor.create mail, opts={}
      m = Mentor.new mail

      m.userPassword = opts[:password] || Rails.application.secrets.default_password
      m.gn = opts[:gn]
      m.sn = opts[:sn]
      m.cn = opts[:cn] || opts[:gn] + ' ' + opts[:sn]
      m.mobile = opts[:mobile]
      m.telephoneNumber = opts[:phone]

      if m.save
          m
      else
          nil
      end
  end
end
