Rails.application.routes.draw do
  devise_for :customers
  devise_for :users

  namespace :admin do
    resources :users, :customers

    get  'charts/signups', to: 'charts#signups'

    root to: 'dashboard#index'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get  'step1', to: 'apply#step1', as: 'step1'
  post 'step1', to: 'apply#step1', as: 'step1_back'
  post 'step2', to: 'apply#step2', as: 'step2'
  post 'step3', to: 'apply#step3', as: 'step3'

  # get  '/application', to: "index#app"

  root "index#index"

end
