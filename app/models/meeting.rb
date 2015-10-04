class Meeting < ActiveRecord::Base
    has_many :checkins, dependent: :destroy
    def attendance_list
        checkins.map{|c| c.user}
    end

    def list
        l = []
        attendance_list.each do |u|
            l << u.mail
            if u.student?
                u.me.parents.each do |p|
                    l << p.mail
                end
            end
        end
        l
    end

    def name_list
        h = {}
        attendance_list.each do |u|
            h[u.mail] = {cn: u.cn, gn: u.gn, sn: u.sn}
            if u.student?
                u.me.parents.each do |p|
                    h[p.mail] = {cn: p.cn, gn: p.gn, sn: p.sn}
                end
            end
        end
        h
    end
end
