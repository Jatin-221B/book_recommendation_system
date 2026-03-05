class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: [ :index ]
  def index
    @users = User.includes(:reviews, :favourites).order(:name).page(params[:page]).per(5)
  end

  def show
    @user = User.find_by(id: params[:id])
    if current_user.admin? || @user == current_user
      if !@user.nil?
        @reviews = @user.reviews.includes(:book).order(created_at: :desc)
        @favourite_books = @user.favourited_books.includes(:author).order(:title)
        @favourite_books_pag = @user.favourited_books.includes(:author).order(:title).page(params[:page]).per(9)
      end
    else
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end
end
