Rails.application.routes.draw do
  resources :service_registrations, except: [:new, :create]
  resources :services

  root to: 'dashboard#index'

  post '/api/v0/register_service', to: 'v0/api#register_service'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
