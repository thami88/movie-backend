module Api
  module V1
    class MoviesController < ApplicationController

      def index
        render json: Movie.all
      end
    
      def create
        # Initialized the record
        movie = Movie.new(movie_params)
    
        if movie.save
          render json: movie, status: :created
        else
          render json: movie.errors, status: :unprocessable_entity
        end
      end
    
      def destroy
        Movie.find(params[:id]).destroy!
        head :no_content
      end
    
      private
    
      def movie_params
        #other than title director will restricted by post method
        params.require(:movie).permit(:title, :director)
      end
    
    end
  end
end
