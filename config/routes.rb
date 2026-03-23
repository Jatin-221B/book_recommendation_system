Rails.application.routes.draw do
  # Devise authentication
  devise_for :users

  # Homepage
  root "pages#home"

  # Books with nested reviews
  resources :books, only: [ :index, :show ] do
    resources :reviews, only: [ :index, :create ]
    # Add search route
    collection do
      get :search
    end
  end

  # Authors
  resources :authors, only: [ :index, :show ]

  # Users with nested reviews index
  resources :users, only: [ :index, :show, :edit, :update, :destroy ] do
    resources :reviews, only: [ :index ]
  end

  # Standalone review routes (for edit/update/delete)
  resources :reviews, only: [ :edit, :update, :destroy ]

  # Favourites
  resources :favourites, only: [ :create, :destroy ]
end
