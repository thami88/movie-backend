require 'rails_helper'

RSpec.describe 'Movies API', type: :request do

  describe 'GET /movies' do

    before do
      FactoryBot.create(:movie, title:'samaple_01',director:'sampale derector_01')
      FactoryBot.create(:movie, title:'samaple_02',director:'sampale derector_02')
    end

    it 'return all movies' do
      get '/api/v1/movies'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(10)
    end
  end
  
  describe 'POST /movies' do
    it 'create a new movie' do
      expect {
        post '/api/v1/movies', params: {movie:{title:'samaple_movie_name_03',director:'sampale_derector_name_03'}}
      }.to change {Movie.count}.from(0).to(1) #this is to check wheather record change in the db
      expect(response).to have_http_status(:created)
    end
  end
  
  describe 'DELETE /movies/:id' do
    let!(:movie)  { FactoryBot.create(:movie, title:'samaple_04',director:'sampale derector_04') }
    it 'delete a movie' do
      expect {
        delete "/api/v1/movies/#{movie.id}"
    }.to change {Movie.count}.from(9).to(8)
      expect(response).to have_http_status(:no_content)
    end
  end

end