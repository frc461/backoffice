class Meeting < ActiveRecord::Base
    has_many :checkins
    def attendance_list
        checkins.map{|c| c.user}
    end
end
