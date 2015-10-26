# BackOffice

Team management & email lists & stuff.  Powered by LDAP & MailGun.

## Getting Started
````
bundle install
cp config/database.yml.sample config/database.yml
cp config/secrets.yml.sample config/secrets.yml

#set up config values in config/app.yml, config/database.yml, config/secrets.yml

rake db:migrate
rails server
````
