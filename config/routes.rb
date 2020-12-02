Rails.application.routes.draw do
  devise_for :customers
  devise_for :users

  namespace :admin do
    resources :users, :postcodes, :terms_and_conditions,
              :privacy_policies, :contacts

    resources :customers do
      resources :contracts, controller: 'customers/contracts' do
        get  'pay_by_credit_card'
        post 'pay_by_credit_card'
      end

    end

    get  'charts/signups', to: 'charts#signups'

    root to: 'dashboard#index'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Static routes
  get 'how_to_apply', to: 'apply#how_to_apply'
  get  'step1', to: 'apply#step1', as: 'step1'
  get  'step2',  to: 'apply#step2'
  post 'step2',  to: 'apply#step2'

  # Stripe
  get 'pay_by_credit_card/:guid', to: 'apply#pay_by_credit_card', as: 'pay_by_credit_card'
  get  'step3', to: 'apply#step3'
  post 'step3', to: 'apply#step3'
  get 'payment_success', to: 'apply#payment_success', as: 'payment_success'
  get 'payment_failed',  to: 'apply#payment_failed',  as: 'payment_failed'

  # Split
  get  'invitation', to: 'apply#invitation'
  post 'invitation', to: 'apply#invitation'

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
  get  'calculator',          to: 'contract#calculator',           as: 'calculator'
  post 'calculator',          to: 'contract#calculator_calculate', as: 'calculator_calculate'

  # Socker server
  mount ActionCable.server => '/cable'

  root "index#index"

end
