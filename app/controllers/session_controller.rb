class SessionController < ApplicationController
  def create
      if u = User.authenticate(params[:email], params[:password])
          session[:udn] = u.dn
          flash[:notice] = "Welcome, #{u.cn}"
      else
          flash[:error] = "Login failed."
      end
      redirect_to root_path
  end

  def destroy
      session.delete :udn
      redirect_to root_path
  end

  def reset
      if current_user && current_user.dn.to_s == params[:dn] || current_role?('passwords') || current_role?('directory') || current_role?('administrator')
          user = User.find(params[:dn])
          if params[:password] == params[:confirm]
              user.userPassword = params[:password]
              user.save
              redirect_to user_path(u.dn)
          else
              flash[:error] = "Confirmation didn't match password."
              redirect_to user_path(u.dn)
          end
      else
          flash[:error] = "You can't do that."
          redirect_to root_path
      end
  end

  def update
      if current_user && current_user.dn.to_s == params[:dn] || current_role?('directory') || current_role?('administrator')
          user = User.find(params[:dn])
          user.cn = params[:cn]
          user.sn = params[:sn]
          user.gn = params[:gn]
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
end
