require 'sidekiq/web'

Rails.application.routes.draw do
  resources :reports
  resources :notices do
    get :fields, on: :collection
    get :validate, on: :member
    get :confirmation, on: :member
    patch :create_confirmation, on: :member
    patch :publish, on: :member
    patch :create_validation, on: :member
    resources :comments, only: %i[create edit update destroy]
    resources :ratings, only: %i[create]
    resources :purchases, only: %i[new]
    resources :stripe_checkouts, only: %i[create]
  end

  resources :webhooks, only: %i[create]
  resources :ad_type_stages
  resources :ad_types do
    resources :ad_type_fields
  end
  resources :stages
  resources :categories
  devise_for :users, controllers: {
    registrations: 'auth/registrations',
    invitations: 'auth/invitations',
    sessions: 'auth/sessions',
    omniauth_callbacks: 'auth/omniauth_callbacks'
  }

  resources :organizations do
    get :find, on: :collection
  end

  resources :users do
    get :photo, on: :member
    patch :approve, on: :member
    resources :user_permissions, only: %i[new create destroy]
  end

  resources :documents do
    patch '/ocr', to: 'documents#ocr', on: :member
  end

  resources :notifications, only: [:index]

  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'

    namespace :admin do
      resources :audits
      root to: "application#show" # <--- Root route
    end
  end

  devise_scope :user do
    get '/sign_up/roles', to: 'auth/registrations#roles_templates', as: :registrations_role_templates
  end

  authenticated :user do
    root to: 'home#dashboard'
  end

  root to: 'home#landing_page', as: :landing_page
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
