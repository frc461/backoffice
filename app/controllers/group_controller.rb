class GroupController < ApplicationController
  def index
      @groups = Group.find(:all)
  end

  def show
      @group = Group.find(params[:dn])
  end

  private
end
