require 'rails_helper'

RSpec.describe Api::V1::MoviesController, type: :controller do
  it 'has max limit of 100' do
    expect(Movie).to receive(:limit).with(100).and_call_original
    get :index, params: { limit: 999 }
  end
end