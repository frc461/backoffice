class Poll < ActiveRecord::Base
    has_many :votes, dependent: :destroy


    def can_vote?(user)
        return false if closed
        permissions.each_line do |opt|
            os = opt.split ':'
            case os[0]
                when 'ou'
                    return true if user.dn.to_s.include?('ou=' + os[1])
                when 'group'
                    return true if user.groups.collect{|g| g.cn}.include?(os[1])
                when '*'
                    return true
            end 
        end
        false
    end

    alias_method :can_vote, :can_vote?
end
