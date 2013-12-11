CasDemo::Application.routes.draw do
  root "dashboard#index"
  resources :sessions
end
