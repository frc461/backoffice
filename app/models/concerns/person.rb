module Person
    extend ActiveSupport::Concern
    def groups
        Group.find(:all, filter: {member: self.dn.to_s})
    end

    def accounts
        Account.where(user_dn: self.dn.to_s)
    end

    def set_initial_accounts
    end

    def user
        User.find(dn)
    end

    def dns
        dn.to_s
    end

    def friendly
        "#{org}/#{cn}"
    end

    def org
        dn.rdns[-3]['ou'].chop
    end

    def student?
        dn.to_s.match /,ou=Students,/
    end

    def mentor?
        dn.to_s.match /,ou=Mentors,/
    end

    def parent?
        dn.to_s.match /,ou=Parents,/
    end

    def me
        if student?
            Student.find(dn)
        elsif mentor?
            Mentor.find(dn)
        elsif parent?
            Parent.find(dn)
        else
            true 
        end
    end

    def attending?(meeting)
        meeting.checkins.where(:user_dn => self.dn.to_s).count > 0
    end

    def move new_ou
        old_dn = self.dn
        new_rdn = self.dn.to_s.split(',').first
        target = new_rdn.split('=').last
        ActiveLdap::Base.connection.modify_rdn dn.to_s, new_rdn, true, new_ou
        new_target = self.class.find(target)

        if old_dn.to_s.match /,ou=Students,/
            Parent.find(:all, filter: {seeAlso: old_dn.to_s}).each do |p|
                Rails.logger.info "Parent: #{p.cn}"
                s = p.seeAlso(true)
                s.delete old_dn
                s << new_target.dn
                p.seeAlso = s
                p.save
            end
        end

        Group.find(:all, filter: {member: old_dn.to_s}).each do |g|
            Rails.logger.info "Group: #{g.cn}"
            m = g.member(true)
            m.delete old_dn
            m << new_target.dn
            g.member = m
            g.save
        end

        Alias.find(:all, filter: {roleOccupant: old_dn.to_s}).each do |a|
            Rails.logger.info "Alias: #{a.cn}"
            r = a.roleOccupant(true)
            r.delete old_dn
            r << new_target.dn
            a.roleOccupant = r
            a.save
        end

        Account.where(user_dn: old_dn.to_s).each do |a|
            a.user_dn = new_target.dn.to_s
            a.save
        end

        Vote.where(user_dn: old_dn.to_s).each do |v|
            v.user_dn = new_target.dn.to_s
            v.save
        end

        Checkin.where(user_dn: old_dn.to_s).each do |c|
            c.user_dn = new_target.dn.to_s
            c.save
        end

        new_target
    end

    def reset_groups
        groups.each do |g|
            m = g.member
            m.delete dn
            g.member = m
            g.save
        end
    end

    def cleanup
        if is_a? Student
            parents.each do |p|
                if p.seeAlso(true).length > 1
                    logger.info "Removing Link between #{p.friendly} and #{friendly}"
                    s = p.seeAlso
                    s.delete dn
                    p.seeAlso = s
                    p.save
                else
                    logger.info "Deleting #{p.friendly} for #{friendly}"
                    p.delete
                end
            end
        end
        Account.where(user_dn: dn.to_s).each{|a| a.delete}
        Vote.where(user_dn: dn.to_s).each{|v| v.delete}
        Checkin.where(user_dn: dn.to_s).each{|v| v.delete}
        reset_groups
    end
end
