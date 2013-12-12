#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :init_cas_params

  def init_cas_params
    URI.parse(params[:service]).query.split("&").map{|item| key,value = item.split('=');params[key] = CGI.unescape(value)}
  end
end
