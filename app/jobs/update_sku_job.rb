require 'net/http'
class UpdateSkuJob < ApplicationJob
  queue_as :default

  def perform(movie_title)
    # Do something later
    uri = URI('http://localhost:3000/update_sku')
    req = Net::HTTP::Post.new(uri,'Content-Type' => 'application/json')
    req.body = {sku: '123', title: movie_title}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end
end
