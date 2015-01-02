class Meeting < ActiveRecord::Base
    has_many :checkins
    def attendance_list
        if required
            (Student.all.map{|s| s.dn.to_s} + checkins.map{|c| c.user_dn}).uniq
        else
            checkins.map{|c| c.user_dn}
        end
    end
end
