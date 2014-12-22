class GroupController < ApplicationController
    before_filter :authorize
  def index
      @groups = Group.find(:all)
  end

  def show
      @group = Group.find(params[:dn])
  end

  private
  def authorize
      redirect_to root_path, error: "You can't do that." unless current_mentor || current_role?('administrator')
  end
end
