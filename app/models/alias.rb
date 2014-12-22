class Alias < ActiveLdap::Base
  ldap_mapping dn_attribute: "cn",
               prefix: "ou=Aliases",
               classes: ["organizationalRole"]
end
