class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  before_action :set_review, only: [ :edit, :update, :destroy ]

  def index
    if params[:book_id]
      @book = Book.find_by(id: params[:book_id])
      if @book.present?
        @reviews = @book.reviews.includes(:user).order(created_at: :desc)
        @average_rating = @reviews.average(:rating)&.round(1) if @reviews.any?
        @reviews = @reviews.page(params[:page]).per(5)
      end
    elsif params[:user_id]
      @user = User.find_by(id: params[:user_id])

      if @user.present?
        authorize @user, :index?, policy_class: ReviewPolicy
        @reviews = @user.reviews.includes(:book).order(created_at: :desc).page(params[:page]).per(5)
      else
        redirect_to root_path, alert: "User not found."
      end
    end
  end

# app/controllers/reviews_controller.rb

def create
  @book = Book.find(params[:book_id])
  @review = @book.reviews.build(review_params)
  @review.user = current_user

  authorize @review

  if @review.save
    redirect_to book_path(@book), notice: "Review was successfully created."
  else
    # Load data needed for book show page - WITH PAGINATION
    @reviews = @book.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
    @average_rating = @reviews.average(:rating)&.round(1)

    # Render book show page with errors
    flash.now[:alert] = "Review was not created: #{@review.errors.full_messages.join(', ')}"
    render "books/show", status: :unprocessable_entity
  end
end

  def edit
    authorize @review
  end

  def update
    authorize @review

    if @review.update(review_params)
      redirect_to book_path(@review.book), notice: "Review was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @review

    referrer = request.referrer
    book = @review.book

    @review.destroy

    if referrer.present? && referrer.include?(user_path(@review.user))
      redirect_to user_path(@review.user), notice: "Review was successfully deleted."
    else
      redirect_to book_path(book), notice: "Review was successfully deleted."
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:content, :rating, :book_id)
  end
end
