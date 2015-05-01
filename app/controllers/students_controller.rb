class StudentsController < ApplicationController
  def index
      @students = Student.find(:all).sort_by{|s| [s.roomNumber.to_i, s.sn]}
  end

  def show
      @student = Student.find(params[:dn])
  end


  private
  def authorize
      redirect_to root_path, alert: "You can't do that." unless current_mentor || current_role?('administrator') || current_role?('exec')
  end
end
