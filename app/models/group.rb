class Group < ActiveLdap::Base
  ldap_mapping dn_attribute: "cn",
               prefix: "ou=Groups",
               classes: ["groupOfNames"]
  def parents 
      [self.member].flatten.map{|m| Parent.find(:first, m.to_s)}.delete_if{|l| l == nil}
  end

  def mentors 
      [self.member].flatten.map{|m| Mentor.find(:first, m.to_s)}.delete_if{|l| l == nil}
  end

  def students
      [self.member].flatten.map{|m| Student.find(:first, m.to_s)}.delete_if{|l| l == nil}
  end

  def list
      [self.member].flatten.map{|u| User.find(u.to_s).mail}
  end

end
