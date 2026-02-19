class BooksController < ApplicationController
  def index
    @books = Book.includes(:author)
  end

  def show
    @book = Book.includes(:author, reviews: :user).find(params[:id])
    @reviews = @book.reviews.order(created_at: :desc)
    @average_rating = @reviews.average(:rating)&.round(1)
    # @review = Review.new  # For the form
  end
end
