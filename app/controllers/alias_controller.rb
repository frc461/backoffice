class AliasController < ApplicationController
  def index
      @aliases = Alias.find(:all)
  end

  def show
      @alias = Alias.find(params[:dn])
  end

  private
  def authorize
      redirect_to root_path, error: "You can't do that." unless current_mentor || current_role?('administrator')
  end
end
