class UserController < ApplicationController
    before_action :authorize
    def new
    end

    def create
        nu = nil
        ph = {gn: params[:gn], sn: params[:sn], mail: params[:mail]}
        case params[:add_type]
        when 'my_parent'
            nu = Parent.create(params[:mail], ph.merge({student: params[:student]}))
        when 'student'
            nu = Student.create(params[:mail], ph)
        when 'mentor'
            nu = Mentor.create(params[:mail], ph)
        when 'parent'
            nu = Parent.create(params[:mail], ph)
        end
        if nu
            nu.set_initial_accounts
            redirect_to user_path(nu.dn), notice: "Created user."
        else
            redirect_to new_user_path, error: nu.errors.to_s
        end
    end

    def update
            user = User.find(params[:dn])
        if current_user && current_user.dn.to_s == params[:dn] || current_role?('directory') || current_role?('administrator') || parent_of_current_child(user) || child_of_current_parent(user) 
            user.cn = params[:cn]
            user.sn = params[:sn]
            user.gn = params[:gn]
            user.roomNumber = params[:roomNumber]
            user.homePhone = params[:homePhone]
            user.homePostalAddress = params[:homePostalAddress]
            user.mobile = params[:mobile]
            user.st = params[:st]
            user.fax = params[:fax]
            user.save
            redirect_to user_path(user.dn)
        else
            flash[:error] = "You can't do that."
            redirect_to root_path
        end
    end

    def reset
        if current_user && current_user.dn.to_s == params[:dn] || current_role?('passwords') || current_role?('directory') || current_role?('administrator')
            user = User.find(params[:dn])
            if params[:password] == params[:confirm]
                user.userPassword = params[:password]
                user.save
                redirect_to user_path(user.dn)
            else
                flash[:error] = "Confirmation didn't match password."
                redirect_to user_path(u.dn)
            end
        else
            flash[:error] = "You can't do that."
            redirect_to root_path
        end
    end

    def move
        user = User.find(params[:dn])
        mail = user.mail
        if OrgUnit.all.include?(params[:ou])
            u = user.move(params[:ou])
            redirect_to user_path(u.dn)
        else
            redirect_to user_path(dn: user.dn), notice: "Oops."
        end
    end

    def destroy
        if(current_role?('administrator') || current_role?('directory'))
            user = User.find(params[:dn]).me
            user.cleanup
            user.delete
            redirect_to root_path, notice: 'User removed.'
        else
            redirect_to root_path, error: 'You can\'t do that.'
        end
    end

   private
    def authorize
      redirect_to root_path, alert: "You can't do that." unless current_user
  end
end
