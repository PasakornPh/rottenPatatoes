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
        @current_user.reviews << @movie.reviews.build(params[:review].permit(:potatoes,:comments))
        #@current_user.reviews << @movie.reviews.build(review_params)
        redirect_to movie_path(@movie)
    end

    def edit
        @movie = Movie.find params[:movie_id]
        @review = Review.find params[:id]
    end

    def update
        @review = @movie.reviews.find params[:id]
        permitted = params[:review].permit(:potatoes,:comments)
        @review.update_attributes!(permitted)
    
        flash[:notice] = "Your review was successfully updated."
        redirect_to movie_path(@movie)
    end

    def destroy
        @review = @movie.reviews.find(params[:id])
        @review.destroy
        flash[:notice] = "Your review deleted."
        redirect_to movie_path(@movie)
      end

    private
    def review_params
        params.require(:review).permit(:potatoes)
    end
end 