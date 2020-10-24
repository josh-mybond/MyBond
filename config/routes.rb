Rails.application.routes.draw do
  devise_for :customers
  devise_for :users

  namespace :admin do
    resources :users, :customers, :postcodes

    get  'charts/signups', to: 'charts#signups'

    root to: 'dashboard#index'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get  'step1', to: 'apply#step1', as: 'step1'
  post 'step1', to: 'apply#step1', as: 'step1_back'
  post 'step2', to: 'apply#step2', as: 'step2'
  post 'step3', to: 'apply#step3', as: 'step3'

  get 'payment_success', to: 'apply#payment_success', as: 'payment_success'
  get 'payment_failed',  to: 'apply#payment_failed',  as: 'payment_failed'

  # get  '/application', to: "index#app"

  # Callbacks

  namespace :api do
    post 'callback_moneyloop', to: 'callback#moneyloop', as: "callback_moneyloop"
  end



  root "index#index"

end
