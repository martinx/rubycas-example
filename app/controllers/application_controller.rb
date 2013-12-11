class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_current_user_instance
    @current_user = session[:cas_user]
    @cas_extra_attributes = session[:cas_extra_attributes]
  end

  def root_url
    uri = URI.parse(self.request.referer)
    uri.scheme.to_s + '://' + uri.host.to_s + ':' + uri.port.to_s
  end
end
