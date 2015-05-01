class GroupController < ApplicationController
  def index
      if current_mentor || current_role?("administrator")
        @groups = Group.find(:all)
      else
          @groups = Group.find(:all, filter: "(!(businessCategory=hidden))")
      end
  end

  def show
      @group = Group.find(params[:dn])
  end

  def update
      @group = Group.find(params[:dn])
      @group.member = params[:members].map{|m| User.find(m).dn}
      @group.save
      redirect_to group_path(dn: @group.dn)
  end

  private
end
