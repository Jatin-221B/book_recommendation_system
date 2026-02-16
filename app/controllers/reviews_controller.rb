class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ edit update destroy ]

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to book_path(@review.book), notice: "Review was successfully created."
    else
      redirect_to book_path(@review.book), alert: "Review was not created."
    end
  end

  def edit
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
    @review.destroy
    redirect_to book_path(@review.book), notice: "Review was successfully destroyed."
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:content, :rating, :book_id)
  end
end
