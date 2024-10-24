module Api
  module V1
    class MoviesController < ApplicationController

      MAX_PAGINATION_LIMIT = 100

      def index
        movies = Movie.limit(limit).offset(params[:offset])
        render json: MoviesRepresenter.new(movies).as_json
      end
    
      def create
        # Initialized the record
        director = Director.create!(director_params)
        movie = Movie.new(movie_params.merge(director_id: director.id))

        UpdateSkuJob.perform_later(movie_params[:title])

        if movie.save
          render json: MovieRepresenter.new(movie).as_json, status: :created
        else
          render json: movie.errors, status: :unprocessable_entity
        end
      end
    
      def destroy
        Movie.find(params[:id]).destroy!
        head :no_content
      end
    
      private

      def limit
        [
          params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
          MAX_PAGINATION_LIMIT
        ].min
      end
    
      def director_params
        params.require(:director).permit(:first_name, :last_name, :age)
      end

      def movie_params
        #other than title director will restricted by post method
        params.require(:movie).permit(:title)
      end
    
    end
  end
end
