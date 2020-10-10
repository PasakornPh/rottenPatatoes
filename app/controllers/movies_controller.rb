
# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
    skip_before_action :authenticate!, only: [ :show, :index ]
    def index
      @movies = Movie.all.order(:title)
    end

    def show
        id = params[:id] # retrieve movie ID from URI route
        @movie = Movie.find(id) # look up movie by unique ID
        # will render app/views/movies/show.html.haml by default
        if @current_user
            @review = @movie.reviews.find_by(:moviegoer_id => @current_user.id)
        end
      end

    def new
        @movie = Movie.new
        # default: render 'new' template
    end
    
    # in movies_controller.rb
    def create
        params.require(:movie)
        permitted = params[:movie].permit(:title,:rating,:release_date)
        @movie = Movie.create!(permitted)

        if @movie.save
            flash[:notice] = "#{@movie.title} was successfully created."
            redirect_to movie_path(@movie)
        else
            render 'new' # note, 'new' template can access @movie's field values!
        end
    end

    def edit
        @movie = Movie.find params[:id]
    end

    def update
        @movie = Movie.find params[:id]
        permitted = params[:movie].permit(:title,:rating,:release_date)
        if @movie.update_attributes!(permitted)
            flash[:notice] = "#{@movie.title} was successfully updated."
            redirect_to movie_path(@movie)
        else
            render 'edit' # note, 'edit' template can access @movie's field values!
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
end
