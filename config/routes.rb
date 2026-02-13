Rails.application.routes.draw do
  get "authors/index"
  get "authors/show"
  get "pages/home"
  # get "books/index"
  # get "books/show"
  # get "up" => "rails/health#show", as: :rails_health_check
  root "pages#home"
  resources :books, only: [ :index, :show ]
  resources :authors, only: [ :index, :show ]
end
