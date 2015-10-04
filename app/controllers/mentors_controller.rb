class MentorsController < ApplicationController
    before_action :authorize
  def index
      @mentors = Mentor.find(:all)
  end

  def show
      @mentor = Mentor.find(params[:dn])
  end

  private
  def authorize
      redirect_to root_path, error: "You can't do that." unless current_user
  end
end
