class Meeting < ActiveRecord::Base
    has_many :checkins
    def attendance_list
        if required
            (Student.all.sort_by{|s| [s.roomNumber.to_i, s.sn]}.map{|s| s.dn.to_s} + checkins.map{|c| c.user_dn}).uniq
        else
            checkins.map{|c| c.user_dn}
        end
    end
end
