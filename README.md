# BackOffice

[![Join the chat at https://gitter.im/frc461/backoffice](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/frc461/backoffice?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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
