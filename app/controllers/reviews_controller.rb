class ReviewsController < ApplicationController
  before_action :has_moviegoer_and_movie

  protected
  def has_moviegoer_and_movie
      unless @current_user
          flash[:warning] = 'You must be logged in to create a review.'
          redirect_to '/auth/twitter'
      end
      unless (@movie = Movie.find_by(:id => params[:movie_id]))
          flash[:warning] = 'Review must be for an existing movie.'
          redirect_to movies_path
      end
  end

  public
  def new
      @review = @movie.reviews.build
  end

  def create
      @current_user.reviews << @movie.reviews.build(review_params)
      redirect_to movie_path(@movie)
  end

  def edit
      @movie = Movie.find params[:movie_id]
      @review = Review.find params[:id]
  end

    def update
        @movie = Movie.find params[:movie_id]
        @review = Review.find params[:id]
        if @review.update(review_params) 
            flash[:notice] = "Review was successfully updated."
            redirect_to movies_path(@movie)
        else
            render 'edit'
        end
    end

  private
  def review_params
      params.require(:review).permit(:potatoes)
  end
end 