# frozen_string_literal: true

Rails.application.routes.draw do
  get 'bookmarks/create'
  get 'bookmarks/destroy'
  get 'bookmarks/index'
  root 'home#index'
  get 'following', to: 'home#following'
  resources :tweets, only: %i[new create show]
  resources :comments, only: %i[new create destroy]
  resources :tweets do
    resources :comments, only: %i[create destroy]
    resources :likes, only: %i[create destroy]
    resources :retweets, only: %i[create destroy]
  end

  resources :relationships, only: %i[create destroy]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users, only: %i[show edit update]
  # post 'follow', on: :member
  # delete 'unfollow', on: :member
  # end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
