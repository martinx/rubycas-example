class SessionsController < ApplicationController
  # This will allow the user to view the index page without authentication
  # but will process CAS authentication data if the user already
  # has an SSO session open.
  before_action RubyCAS::Filter, :except => :new

  def new
    @lt = RestClient.get("#{Rails.application.config.rubycas.cas_base_url}lt")
  end


  def destroy
    RubyCAS::Filter.logout(self, root_url)
  end
end
