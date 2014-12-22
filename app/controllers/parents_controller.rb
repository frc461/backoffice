class ParentsController < ApplicationController
    before_action :authorize
  def index
      @parents = Parent.find(:all)
  end

  def show
      @parent = Parent.find(params[:dn])
      @dns = [@parent.dn.to_s] + @parent.students.map{|s| s.dn.to_s}
      @accounts = Account.where(user_dn: @dns)
  end

  private
  def authorize
      redirect_to root_path, error: "You can't do that." unless current_mentor || current_role?('administrator')
  end
end
