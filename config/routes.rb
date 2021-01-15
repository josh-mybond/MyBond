Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :customers
  devise_for :users

  namespace :admin do
    get  'charts/signups', to: 'charts#signups'
    root to: 'dashboard#index'
  end

  # Application form
  post 'calculator_handler', to: "apply#calculator_handler"
  get  'how_to_apply',       to: 'apply#how_to_apply'
  get  'application',        to: 'apply#application'

  get  'step1', to: 'apply#step1'
  post 'step1', to: 'apply#step1'
  get  'step2', to: 'apply#step2'
  post 'step2', to: 'apply#step2'

  get  'invitation', to: 'apply#invitation'
  post 'invitation', to: 'apply#invitation'


  # Static routes
  get "privacy_policy",       to: 'index#privacy_policy',       as: 'privacy_policy'
  get "terms_and_conditions", to: 'index#terms_and_conditions', as: 'terms_and_conditions'
  get "contact",              to: 'index#contact',              as: 'contact'
  post "contact",             to: 'index#contact',              as: 'contact_form'


  # root "index#index"
  root "contract#calculator"
end
