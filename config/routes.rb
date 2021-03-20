# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :questions do
    resources :answers, shallow: true do
      member do
        post :mark_best
        post :delete_file
      end
    end
  end

  resources :users, only: %i[] do
    get :awards, on: :member
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
end
