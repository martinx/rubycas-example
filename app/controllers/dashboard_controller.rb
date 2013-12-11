class DashboardController < ApplicationController
  before_action RubyCAS::Filter

  def index
    puts session
    set_current_user_instance
  end
end
