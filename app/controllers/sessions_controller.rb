class SessionsController < ApplicationController
  before_action RubyCAS::Filter, :except => :new

  def new
    @lt = RestClient.get("#{Rails.configuration.rubycas.cas_base_url}lt")
  end

  def destroy
    RubyCAS::Filter.logout(self, "#{request.protocol.to_s}#{request.host_with_port}")
  end
end