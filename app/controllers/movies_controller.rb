
# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
    skip_before_action :authenticate!, only: [ :show, :index ]
    def index
        @movies = Movie.all.order(:title) 
    end

    def show
        id = params[:id]
        @movie = Movie.find(id)
        if @current_user
            @review = @movie.reviews.find_by(:moviegoer_id => @current_user.id)
        end
        render(:partial => 'movie_popup', :object=>@movie) if request.xhr?
    end

    def new
        @movie = Movie.new
    end
    
    def create
        @movie = Movie.new(movie_params)
        if @movie.save
            flash[:notice] = "#{@movie.title} was successfully created."
            redirect_to movie_path(@movie)
        else
            render 'new'
        end
    end

    def edit
        @movie = Movie.find params[:id]
    end

    def update
        @movie = Movie.find params[:id]
        if @movie.update(movie_params) 
            flash[:notice] = "#{@movie.title} was successfully updated."
            redirect_to movies_path(@movie)
        else
            render 'edit'
        end
    end

    def destroy
        @movie = Movie.find(params[:id])
        @movie.destroy
        flash[:notice] = "Movie '#{@movie.title}' deleted."
        redirect_to movies_path
    end

    def movies_with_good_reviews
        @movies = Movie.joins(:reviews).group(:movie_id).
          having('AVG(reviews.potatoes) > 3')
    end
    
    def movies_for_kids
        @movies = Movie.where('rating in ?', %w(G PG))
    end

    def movies_with_filters
        @movies = Movie.with_good_reviews(params[:threshold])
        @movies = @movies.for_kids          if params[:for_kids]
        @movies = @movies.with_many_fans    if params[:with_many_fans]
        @movies = @movies.recently_reviewed if params[:recently_reviewed]
    end

    private 
        def movie_params
            params.require(:movie).permit(:title, :rating, :release_date, :description)
        end

end
