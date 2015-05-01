class DashboardController < ApplicationController
  def index
      @news = (current_user ? News : News.where(:public => true)).order('created_at DESC')
  end

  def me
      if current_user
          case current_user
          when Mentor
              @mentor = current_user
              render 'mentors/show'
          when Student
              @student = current_user
              render 'students/show'
          when Parent
              @parent = current_user
              render 'parents/show'
          else
              redirect_to root_path, error: "Who are you???"
          end
      else
          redirect_to root_path, alert: "You can't do that."
      end
  end

  def user
        begin
            if u = User.find(params[:dn])
                redirect_to case u.me
                when Mentor
                    mentor_path(dn: u.dn)
                when Student
                    student_path(dn: u.dn)
                when Parent
                    parent_path(dn: u.dn)
                else
                    mentor_path(dn: u.dn)
                end
            else
               raise ActionController::RoutingError.new('User DN Not Found')
            end
        rescue
            raise ActionController::RoutingError.new('User DN Not Found')
        end

  end

  def uimg
      @user = User.find(params[:dn])
      render text: 'data:image/jpeg;base64,' + Base64.encode64(@user.jpegPhoto)
  end
end
