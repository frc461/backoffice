class Student < ActiveLdap::Base
  include Person
  ldap_mapping dn_attribute: "mail",
               prefix: "ou=Students",
               classes: ["inetOrgPerson", "organizationalPerson", "person", "top"], 
               scope: :sub

  def parents
      Parent.find(:all, filter: {seeAlso: self.dn.to_s})
  end

  
  def set_initial_accounts
      Account.create(code: "D", name: "Team Dues", description: "Do your part to keep the team running", user_dn: self.dn.to_s)
  end

  def graduated?
      dn.to_s.match /,ou=Graduated,/
  end
  
  def recruit?
      dn.to_s.match /,ou=Recruits,/
  end

  def dropped?
      dn.to_s.match /,ou=Dropped,/
  end

  def orphan?
      parents.count == 0
  end

  def Student.create mail, opts={}
      s = Student.new mail

      s.userPassword = opts[:password] || Rails.application.secrets.default_password
      s.gn = opts[:gn]
      s.sn = opts[:sn]
      s.cn = opts[:cn] || opts[:gn] + ' ' + opts[:sn]
      s.roomNumber = opts[:grad]
      s.mobile = opts[:mobile]
      s.telephoneNumber = opts[:phone]
      s.homePostalAddress = opts[:address]
      s.set_initial_accounts

      if s.save
          s
      else
          nil
      end
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
