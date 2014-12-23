class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    def current_user
        @current_user ||= (session[:udn] ? User.find(session[:udn]).me : nil)
    end

    def current_role? r
        if current_user
            [current_user.employeeType].flatten.include? r
        else
            false
        end
    end

    def current_mentor
        current_user && current_user.is_a?(Mentor)
    end

    def current_student
        current_user && current_user.is_a?(Student)
    end

    def current_parent
        current_user && current_user.is_a?(Parent)
    end

    def child_of_current_parent(student)
        current_parent && current_user.students.include?(student) 
    end

    def user_path dn
        begin
            if u = User.find(dn)
                case u.me
                when Mentor
                    mentor_path(dn: u.dn)
                when Student
                    student_path(dn: u.dn)
                when Parent
                    parent_path(dn: u.dn)
                else
                    "mailto:#{u.mail}"
                end
            else
               "#" 
            end
        rescue
            Rails.logger.error "INVALID DN ATTEMPT: #{dn}"
            return '#'
        end
    end

    helper_method :current_user, :current_role?, :current_mentor, :user_path
end
