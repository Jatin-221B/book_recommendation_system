class UsersController < ApplicationController
  def index
    @users = User.all.order(:name)
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews.includes(:book).order(created_at: :desc)
    @favourite_books = @user.favourited_books.includes(:author).order(:title)
  end
end
