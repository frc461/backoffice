class Poll < ActiveRecord::Base
    has_many :votes, dependent: :destroy


    def can_vote?(user)
        return false if closed
        permissions.each_line do |opt|
            os = opt.split ':'
            return true if case os[0]
                when 'ou'
                    user.dn.to_s.include?('ou=' + os[1])
                when 'group'
                    user.groups.collect{|g| g.cn}.include?(os[1])
                else
                    false
            end 
        end
        false
    end

    alias_method :can_vote, :can_vote?
end
