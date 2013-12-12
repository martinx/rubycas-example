CasDemo::Application.routes.draw do
  root "console#index"
  resources :sessions
end
