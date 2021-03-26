# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :upvote
      post :downvote
    end
  end

  resources :questions do
    resources :answers, concerns: [:votable], shallow: true do
      member do
        post :mark_best
        post :delete_file
      end
    end
  end

  resources :awards, only: [:index]

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
end
