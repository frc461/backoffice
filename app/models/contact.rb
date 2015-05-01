class Contact < ActiveLdap::Base
  ldap_mapping dn_attribute: "mail",
               prefix: "ou=Contacts",
               classes: ["inetOrgPerson"]
end
