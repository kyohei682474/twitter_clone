# frozen_string_literal: true

Rails.application.routes.draw do
<<<<<<< HEAD
  root 'home#index' # トップページに遷移させる
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

=======
  devise_for :users
>>>>>>> d0c9501 (deviseを導入した)
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
