class UsersController < ApplicationController
  # before_action :authenticate_user!
  def index
    @users = User.includes(:reviews, :favourites).order(:name).page(params[:page]).per(5)
  end

  def show
    @user = User.find_by(id: params[:id])
    if !@user.nil?
      @reviews = @user.reviews.includes(:book).order(created_at: :desc)
      @favourite_books = @user.favourited_books.includes(:author).order(:title)
    end
  end
end
