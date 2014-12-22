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
      if current_user
          if params[:password] == params[:confirm]
              current_user.userPassword = params[:password]
              current_user.save
          else
              flash[:error] = "Confirmation didn't match password."
          end
      else
          flash[:error] = "You can't do that."
      end
      redirect_to me_path
  end
end
