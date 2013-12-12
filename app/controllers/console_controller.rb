class ConsoleController < ApplicationController
  before_action RubyCAS::Filter
  before_action :init_cas_params

  def index
  end

  private
  def init_cas_params
    @current_user = session[:cas_user]
    @cas_extra_attributes = session[:cas_extra_attributes]
    begin
      URI.parse(params[:service]).query.split("&").map { |item| key, value = item.split('='); params["cas_#{key.to_s}".to_sym] = CGI.unescape(value) } if params[:service].present?
    rescue => e
      logger.error "parse cas service error:#{e.message}"
      #ignore
    end
  end
end