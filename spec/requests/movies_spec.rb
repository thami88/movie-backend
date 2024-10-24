require 'rails_helper'

RSpec.describe 'Movies API', type: :request do

  let(:first_director) {FactoryBot.create(:director, first_name: 'Denis', last_name: 'Villa', age: 60)}
  let(:second_director) {FactoryBot.create(:director, first_name: 'Kate', last_name: 'Middleton', age: 40)}

  describe 'GET /movies' do

    before do
      FactoryBot.create(:movie, title:'Dune',director:first_director)
      FactoryBot.create(:movie, title:'Lake',director:second_director)
    end

    it 'return all movies' do
      get '/api/v1/movies'
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body)
        .to eq(
              [
                {
                  'id' => 1,
                  'title' => 'Dune',
                  'director_name' => 'Denis Villa',
                  'director_age' => 60
                },
                {
                  'id' => 2,
                  'title' => 'Lake',
                  'director_name' => 'Kate Middleton',
                  'director_age' => 40
                }
              ]

            )
    end

    it 'returns a subset of movies based on limit' do
      get '/api/v1/movies', params: {limit: 1}
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body)
        .to eq(
              [
                {
                  'id' => 1,
                  'title' => 'Dune',
                  'director_name' => 'Denis Villa',
                  'director_age' => 60
                }
              ]

            )
    end

    it 'returns a subset of movies based on offset' do
      get '/api/v1/movies', params: {limit: 1, offset: 1}
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body)
        .to eq(
              [
                {
                  'id' => 2,
                  'title' => 'Lake',
                  'director_name' => 'Kate Middleton',
                  'director_age' => 40
                }
              ]

            )
    end
  end

  describe 'POST /movies' do
    it 'create a new movie' do
      expect {
        post '/api/v1/movies', params: {
          movie:{title:'SuperMan'},
          director:{first_name:'Zack', last_name:'Snyder', age:40}
        }
      }.to change {Movie.count}.from(0).to(1) #this is to check whether record change in the db
      expect(response).to have_http_status(:created)
      expect(Director.count).to eq(1)
      expect(response_body)
        .to eq(
                 {
                   'id' => 1,
                   'title' => 'SuperMan',
                   'director_name' => 'Zack Snyder',
                   'director_age' => 40
                 }
            )
    end
  end
  
  describe 'DELETE /movies/:id' do
    let!(:movie)  { FactoryBot.create(:movie, title:'samaple_04',director:first_director) }
    it 'delete a movie' do
      expect {
        delete "/api/v1/movies/#{movie.id}"
    }.to change {Movie.count}.from(1).to(0)
      expect(response).to have_http_status(:no_content)
    end
  end

end