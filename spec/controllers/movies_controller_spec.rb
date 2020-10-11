require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end
    it 'calls the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with('hardware').
        and_return(@fake_results)
      #post :search_tmdb, {:search_terms => 'hardware'}
      post :search_tmdb, params: {:search_terms => 'hardware'}
    end

    describe 'after valid search' do
      before :each do
        allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
        #post :search_tmdb, {:search_terms => 'hardware'}
        post :search_tmdb, params: {:search_terms => 'hardware'}
      end
      it 'selects the Search Results template for rendering' do
        expect(response).to render_template('search_tmdb')
      end
      it 'makes the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@fake_results)
      end
    end
  end

  describe "#Create" do
    before (:each) do
      @mock_movie_attributes = {movie: {title: "new movie",rating: "PG",release_date: "2016-10-01",description:  "new description"}}
    end

    describe "POST #create" do
      
        it "saves the new movie in the database" do
            expect {
              post :create,params: @mock_movie_attributes
            }.to change(Movie,:count).by(1)
        end
        it "assigns the saved movie to @movie" do
            post :create,params: @mock_movie_attributes
            expect(assigns(:movie).title).to include("New Movie")
        end
        it "redirects to the home page" do
            post :create,params: @mock_movie_attributes
            expect(response).to redirect_to(movie_path(Movie.last.id))
        end
    end
  end

  describe "GET #show" do
    before (:each) do
      @mock_movie = FactoryGirl.create(:movie)
    end
      it "assigns the requested movie to @movie" do
        get :show, params: {id: @mock_movie.id}
        expect(assigns(:movie).title).to include("A Fake Title")
      end
      it "renders the :show template" do
        get :show, params: {id: @mock_movie.id}
        expect(response).to render_template(:show)
      end

  end
end