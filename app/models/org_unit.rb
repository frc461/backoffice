class OrgUnit
    class << self
        def all
            ActiveLdap::Base.search(base: 'dc=boilerinvasion,dc=org', filter: 'objectClass=organizationalUnit').map{|d| d[0]}
        end
    end
end
