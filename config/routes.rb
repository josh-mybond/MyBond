Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users

    get  'charts/signups', to: 'charts#signups'

    root to: 'dashboard#index'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "index#index"
  get  '/application', to: "index#app"

  # admin routes

end
