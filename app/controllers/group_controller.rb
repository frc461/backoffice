class GroupController < ApplicationController
  def index
      redirect_to root_path, alert: "You can't do that." unless current_mentor || current_role?('administrator') || ()
      @groups = Group.find(:all)
  end

  def show
      @group = Group.find(params[:dn])
      redirect_to root_path, alert: "You can't do that." unless current_mentor || current_role?('administrator') || (@group.list.include?(current_user.mail))
  end

  private
end
