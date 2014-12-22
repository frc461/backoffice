class StudentsController < ApplicationController
    before_action :authorize
  def index
      if current_mentor
      @students = Student.find(:all)
      else
      redirect_to root_path, notice: "You aren't allowed to do that." unless current_mentor
      end
  end

  def show
      @student = Student.find(params[:dn])
  end


  private
  def authorize
      redirect_to root_path, error: "You can't do that." unless current_mentor || current_role?('administrator') || current_role?('exec')
  end
end
