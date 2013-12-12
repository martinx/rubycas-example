require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # Bundler.require(:default, :assets, Rails.env)
end

module CasDemo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.rubycas.local_login = true
    # case base url
    config.rubycas.cas_base_url = 'http://localhost:10021/'
    # Enable single sign out
    config.rubycas.enable_single_sign_out = true
    # Instruct the client to log to the default rails logger
    config.rubycas.logger = Rails.logger
    # In order for the CAS single sign out to work, allow_forgery_protection must be set to false (at least for the actions behind the CAS filter)
    config.allow_forgery_protection = false
  end
end
