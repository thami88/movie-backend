require 'rails_helper'

RSpec.describe UpdateSkuJob, type: :job do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:movie_title) {'eloquent ruby'}

  before do
    allow(Net::HTTP).to receive(:start).and_return(true)
  end

  it "calls SKU service with correct params" do
    expect_any_instance_of(Net::HTTP::Post).to receive(:body=).with(
      {sku: '123', title: movie_title}.to_json
    )

    described_class.perform_now(movie_title)
  end
end
