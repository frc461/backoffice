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
end
