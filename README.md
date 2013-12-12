CAS使用说明

## 修改Gemfile

```
gem 'rubycas-client',github: 'unionpaysmart/rubycas-client'
gem 'rubycas-client-rails',github: 'unionpaysmart/rubycas-client-rails'

gem 'activerecord-session_store', github: 'rails/activerecord-session_store'
gem 'rest-client'
```

## 修改 config/application.rb

```
config.rubycas.local_login = true
config.rubycas.cas_base_url = 'http://192.168.88.148:10021/'
config.rubycas.enable_single_sign_out = true
config.rubycas.logger = Rails.logger
config.allow_forgery_protection = false
```

其中

* local_login  开启本地登陆
* cas_base_url 为CAS验证中心
* enable_single_sign_out 是否开启单点登出
* allow_forgery_protection  开启单点登出必须设置为false

## 使用DB存储Session Store

修改

```
config/initializers/session_store.rb
```

为db存储

```
****::Application.config.session_store :active_record_store
```


## 更新 Controller

* 在需要验证的Controller上加上验证

```
before_action RubyCAS::Filter
```

**不要直接加在ApplicationController上

* 修改登入/登出 Controller#action **

```
class SessionsController < ApplicationController
  before_action RubyCAS::Filter, :except => :new

  def new
    @lt = RestClient.get("#{Rails.configuration.rubycas.cas_base_url}lt")
  end

  def destroy
    RubyCAS::Filter.logout(self, "#{request.protocol.to_s}#{request.host_with_port}")
  end
end

```

* 可以直接从session中获得用户信息

```
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
```


* 获取额外的登陆信息(从CAS Server返回)

```
params[:cas_message]
params[:Cas_mistype]
...
```