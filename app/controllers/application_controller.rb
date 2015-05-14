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

    def parent_of_current_child(parent)
        current_student && current_user.parents.include?(parent)
    end

    def user_path dn
       '/u?dn=' + dn.to_s
    end

    def nice_contact_attr attr
        case attr
        when 'cn'
            "Full Name"
        when 'mobile'
            "Cell Phone"
        when 'mail'
            "Email Address"
        when 'pager'
            "Other Phone"
        when 'homePostalAddress'
            "Home Address"
        when 'telephoneNumber'
            "Home Phone"
        when 'st'
            "Shirt Size"
        end
    end

    helper_method :current_user, :current_role?, :current_mentor, :current_student, :user_path, :child_of_current_parent, :parent_of_current_child, :nice_contact_attr
end
