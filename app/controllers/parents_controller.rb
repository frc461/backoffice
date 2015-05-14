class ParentsController < ApplicationController
  def index
      redirect_to root_path, error: "You can't do that." unless current_mentor || current_role?('administrator')
      @parents = Parent.find(:all)
  end

  def show
      @parent = Parent.find(params[:dn])
      redirect_to root_path, error: "You can't do that." unless current_mentor || current_role?('administrator') || parent_of_current_child(@parent)
      @dns = [@parent.dn.to_s] + @parent.students.map{|s| s.dn.to_s}
      @accounts = Account.where(user_dn: @dns)
  end

end
