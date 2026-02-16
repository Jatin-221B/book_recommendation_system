class UsersController < ApplicationController
  def index
    @users = User.all.order(:name)
  end

  def show
    @users = user.find(params[:id])
    @reviews = User.reviews.includes(:book).order(created_at: :desc)
    @favourite_books = User.favourite_books.includes(:author).order(:title)
  end
end
