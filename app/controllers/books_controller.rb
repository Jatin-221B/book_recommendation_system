class BooksController < ApplicationController
  def index
    @books = Book.includes(:author).page(params[:page]).per(9)
  end

  def show
    @book = Book.includes(:author, reviews: :user).find_by(id: params[:id])
    if !@book.nil?
      # @current_user_review = nil
      # @other_reviews = []

      # if current_user
      #   @current_user_review = @book.reviews.find_by(user_id: current_user.id)
      # end

      # @other_reviews = @book.reviews.where.not(user_id: current_user.id)
      # @reviews =[]
      # @reviews << @current_user_review if @current_user_review
      # @reviews += @other_reviews

      @reviews = @book.reviews.order(created_at: :desc).page(params[:page]).per(5)
      if !@reviews.empty?
        @average_rating = @reviews.average(:rating).round(1)
      end
    end
    @review = Review.new
  end
end
