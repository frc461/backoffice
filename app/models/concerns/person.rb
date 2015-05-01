module Person
    extend ActiveSupport::Concern
  def groups
      Group.find(:all, filter: {member: self.dn.to_s})
  end
  
  def accounts
      Account.where(user_dn: self.dn.to_s)
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
      org == "Student"
  end

  def mentor?
      org == "Mentor"
  end

  def parent?
      org == "Parent"
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

end
