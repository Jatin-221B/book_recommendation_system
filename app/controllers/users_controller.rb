class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: [ :index ]
  before_action :get_user, only: [ :edit, :update, :destroy ]
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

  def update
    # @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def destroy
    # @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: "User was successfully destroyed."
  end

  private

  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
