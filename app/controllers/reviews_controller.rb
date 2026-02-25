class ReviewsController < ApplicationController
  before_action :set_review, only: [ :edit, :update, :destroy ]
  before_action :authenticate_user!, only: [ :create, :edit, :update, :destroy ]

  def index
    if params[:book_id]
      @book = Book.find_by(id: params[:book_id])
      if !@book.nil?
        @reviews = @book.reviews.includes(:user).order(created_at: :desc)
        if @reviews.any?
          @average_rating = @reviews.average(:rating).round(1)
        end
        @reviews = @reviews.page(params[:page]).per(5)
      end
    end

    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
    if !@user.nil?
      @reviews = @user.reviews.includes(:book).order(created_at: :desc).page(params[:page]).per(5)
    end
    end
  end

  def create
    @book = Book.find(params[:book_id])
    @review = @book.reviews.build(review_params)
    @review.user = current_user


    if @review.save
      redirect_to book_path(@book), notice: "Review was successfully created."
    else
      # Load data needed for book show page
      @reviews = @book.reviews.includes(:user).order(created_at: :desc)
      @average_rating = @reviews.average(:rating)&.round(1)

      # Render book show page with errors
      flash.now[:alert] = "Review was not created: #{@review.errors.full_messages.join(', ')}"
      render "books/show", status: :unprocessable_entity
    end
  end



  def edit
    # Check authorization
    if @review.user != current_user
      redirect_to book_path(@review.book), alert: "You can only edit your own review."
    end
  end

  def update
    if @review.user != current_user
      redirect_to book_path(@review.book), alert: "You can only edit your own review."
      return
    end

    if @review.update(review_params)
      redirect_to book_path(@review.book), notice: "Review was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @review.user != current_user
      redirect_to book_path(@review.book), alert: "You can only delete your own review."
      return
    end

    book = @review.book
    @review.destroy
    redirect_to book_path(book), notice: "Review was successfully deleted."
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:content, :rating, :book_id)
  end
end
