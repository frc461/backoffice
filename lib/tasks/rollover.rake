task :rollover => :environment do
    Meeting.all.each(&:delete)
    Poll.all.each(&:delete)
    Account.all.each(&:rollover)
end
