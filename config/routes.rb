Rails.application.routes.draw do
  devise_for :users
  # get "users/index"
  # get "users/show"
  # get "authors/index"
  # get "authors/show"
  # get "pages/home"
  # get "books/index"
  # get "books/show"
  # get "up" => "rails/health#show", as: :rails_health_check
  root "pages#home"
  resources :books, only: [ :index, :show ] do
    resources :reviews, only: [ :index, :create ]
  end
  resources :authors, only: [ :index, :show ]
  resources :users, only: [ :index, :show ] do
    resources :reviews, only: [ :index ]
  end
  resources :reviews, only: [  :edit, :update, :destroy ]
  resources :favourites, only: [ :create, :destroy ]
end
