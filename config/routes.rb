Rails.application.routes.draw do
  devise_for :customers
  devise_for :users

  namespace :admin do
    resources :users, :customers, :postcodes, :terms_and_conditions,
              :privacy_policies, :contacts

    get  'charts/signups', to: 'charts#signups'

    root to: 'dashboard#index'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get  'step1', to: 'apply#step1', as: 'step1'
  post 'step1', to: 'apply#step1', as: 'step1_back'
  post 'step2', to: 'apply#step2', as: 'step2'

  # Stripe
  post 'step3', to: 'apply#step3', as: 'step3'
  get 'payment_success', to: 'apply#payment_success', as: 'payment_success'
  get 'payment_failed',  to: 'apply#payment_failed',  as: 'payment_failed'

  # Split
  get  'invitation', to: 'apply#invitation', as: 'invitation_back'
  post 'invitation', to: 'apply#invitation', as: 'invitation'

  get 'success/:contract_id', to: 'apply#success'
  get 'failure/:contract_id', to: 'apply#failure'
  get 'cancel/:contract_id',  to: 'apply#cancel'

  # webhooks

  post 'webhooks/split',      to: 'webhooks#split'

  # get  '/application', to: "index#app"

  # Callbacks

  namespace :api do
    post 'callback_moneyloop', to: 'callback#moneyloop', as: "callback_moneyloop"
  end

  get "privacy_policy",       to: 'index#privacy_policy',       as: 'privacy_policy'
  get "terms_and_conditions", to: 'index#terms_and_conditions', as: 'terms_and_conditions'
  get "contact",              to: 'index#contact',              as: 'contact'
  post "contact",             to: 'index#contact',              as: 'contact_form'


  root "index#index"

end
