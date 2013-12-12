CAS使用说明

## 修改Gemfile

```
gem 'rubycas-client-rails',github: 'unionpaysmart/rubycas-client-rails'
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'
gem 'rest-client'
```

## 修改 config/application.rb

```
config.rubycas.login_url = 'http://localhost:5001/sessions/new'
config.rubycas.cas_base_url = 'http://192.168.88.148:10021/'
config.rubycas.enable_single_sign_out = true
config.rubycas.logger = Rails.logger
config.allow_forgery_protection = false
```

其中

* login_url 为登陆地址
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

* 修改登入/登出 Controller#action

```
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

```

* 可以直接从session中获得用户信息

```
class DashboardController < ApplicationController
  before_action RubyCAS::Filter

  def index
    @current_user = session[:cas_user]
    @cas_extra_attributes = session[:cas_extra_attributes]
  end
end
```


* 获取额外的登陆信息(从CAS Server返回)

```
  before_action :init_cas_params

  def init_cas_params
    URI.parse(params[:service]).query.split("&").map{|item| key,value = item.split('=');params[key] = CGI.unescape(value)}
  end
```