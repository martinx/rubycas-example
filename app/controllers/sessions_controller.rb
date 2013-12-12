class SessionsController < ApplicationController
  before_action RubyCAS::Filter, :except => :new

  def new
    @lt = RestClient.get("#{Rails.application.config.rubycas.cas_base_url}lt")
  end


  def destroy
    RubyCAS::Filter.logout(self, root_url)
  end

  def root_url
    uri = URI.parse(self.request.referer)
    uri.scheme.to_s + '://' + uri.host.to_s + ':' + uri.port.to_s
  end
end
