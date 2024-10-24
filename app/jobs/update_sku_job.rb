class UpdateSkuJob < ApplicationJob
  queue_as :default

  def perform(movie_name)
    # Do something later
    uri = URI('http://localhost:4567/update_sku')
    req = Net::HTTP.post(uri,'Content-Type' => 'application/json')
    req.body = {sku:'123', name:movie_name}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end
end
