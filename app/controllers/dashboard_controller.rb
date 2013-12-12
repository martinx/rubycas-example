class DashboardController < ApplicationController
  before_action RubyCAS::Filter

  def index
    @current_user = session[:cas_user]
    @cas_extra_attributes = session[:cas_extra_attributes]
  end
end
