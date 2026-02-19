class FavouritesController < ApplicationController
  before_action
  def create
    @favourite = Favourite.new(favourite_params)
    @favourite.user = current_user
    if @favourite.save
      redirect_to book_path(@favourite.book), notice: "Favourite was successfully created."
    else
      redirect_to book_path(@favourite.book), alert: "Favourite was not created."
    end
  end

  def destroy
    @favourite = Favourite.find(params[:id])
    # if @favourite.user != current_user
    #   redirect_to book_path(@favourite.book), alert: "You can only delete your own favourite."
    #   return
    # end
    @favourite.destroy
    redirect_to book_path(@favourite.book), notice: "Favourite was successfully destroyed."
  end

  def favourite_params
    params.require(:favourite).permit(:book_id)
  end
end
