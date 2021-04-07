# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :upvote
      post :downvote
    end
  end

  namespace :api do
    namespace :v1 do
      resource :profiles, only: [] do
        get :me, on: :collection
        get :index, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[show create]
      end
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: :create
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], shallow: true do
      member do
        post :mark_best
        post :delete_file
      end
    end
  end

  resources :awards, only: [:index]

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
  mount ActionCable.server => '/cable'
end
