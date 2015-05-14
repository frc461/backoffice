task :rollover => :environment do
    Meeting.all.each {|e| e.delete}
    Poll.all.each {|e| e.delete}
end
