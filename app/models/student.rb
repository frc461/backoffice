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
      Account.where(user_dn: self.dn.to_s)
  end

  def set_initial_accounts
      Account.create(code: "D", name: "Team Dues", description: "Do your part to keep the team running", user_dn: self.dn.to_s)
      Account.create(code: "M", name: "Incidentals", description: "Miscellaneous money for food, shirts, etc.", user_dn: self.dn.to_s)
  end

  def grade
      case self.roomNumber
      when 7
          '7th Grade'
      when 8
          '8th Grade'
      when 9
          'Freshman'
      when 10
          'Sophomore'
      when 11
          'Junior'
      when 12
          'Senior'
      when 99
          'Alumnus'
      else
          "Undefined"
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
