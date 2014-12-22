class User < ActiveLdap::Base
  ldap_mapping dn_attribute: "mail",
               prefix: "",
               classes: ["inetOrgPerson"]

  def User.authenticate(mail, password)
      user = find(:first, filter: {mail: mail})
      user.bind(password)
      user
  rescue ActiveLdap::EntryNotFound, ActiveLdap::AuthenticationError, ActiveLdap::LdapError::UnwillingToPerform 
      nil
  end

  def friendly
      "#{org}/#{cn}"
  end

  def org
      dn.rdns[-3]['ou'].chop
  end

  def student?
      org == "Student"
  end

  def mentor?
      org == "Mentor"
  end

  def parent?
      org == "Parent"
  end

  def me
      if student?
          Student.find(dn)
      elsif mentor?
          Mentor.find(dn)
      elsif parent?
          Parent.find(dn)
      else
         true 
      end
  end
end
