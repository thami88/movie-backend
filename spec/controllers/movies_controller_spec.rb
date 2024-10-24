require 'rails_helper'

RSpec.describe Api::V1::MoviesController, type: :controller do

  describe 'GET index'  do
    it 'has max limit of 100' do
      expect(Movie).to receive(:limit).with(100).and_call_original
      get :index, params: { limit: 999 }
    end
  end

  describe 'POST create' do
    let(:movie_title) {'Inception'}

    it "calls UpdateSkuJob with correct params " do
      expect(UpdateSkuJob).to receive(:perform_later).with(movie_title)
      post :create, params: {
        movie: {
          title: movie_title,
        },
        director: {
          first_name: 'Christopher',
          last_name:'Nolan',
          age: 40
        }
      }
    end
  end

end