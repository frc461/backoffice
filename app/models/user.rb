class User < ActiveLdap::Base
    include Person
  ldap_mapping dn_attribute: "mail",
               prefix: "",
               classes: ["inetOrgPerson"]

  def User.CONTACT_ATTRS
      ['cn', 'mobile', 'mail', 'fax', 'pager', 'homePostalAddress', 'telephoneNumber', 'st']
  end
  def User.authenticate(mail, password)
      user = find(:first, filter: {mail: mail})
      user.bind(password)
      user
  rescue ActiveLdap::EntryNotFound, ActiveLdap::AuthenticationError, ActiveLdap::LdapError::UnwillingToPerform, NoMethodError
      nil
  end

  def User.list
      Student.list + Mentor.list + Parent.list
  end

  def User.name_list
      Student.name_list.merge(Mentor.name_list).merge(Parent.name_list)
  end

end
