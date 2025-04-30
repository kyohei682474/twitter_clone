# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index' # トップページに遷移させる
  get 'following', to: 'home#following'
  resources :tweets, only: %i[new create show]
  resources :comments, only: %i[new create destroy]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :users, only: %i[show edit update]
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
