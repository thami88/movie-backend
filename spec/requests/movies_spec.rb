require 'rails_helper'

RSpec.describe 'Movies API', type: :request do
  it "return all movies" do
    FactoryBot.create(:movie, title:'samaple_01',director:'sampale derector_01')
    FactoryBot.create(:movie, title:'samaple_02',director:'sampale derector_02')
    get '/api/v1/movies'
    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body).size).to eq(2)
  end
end