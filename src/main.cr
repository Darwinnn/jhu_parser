require "kemal"
require "./cache"

cache = Cache.new

get "/:country" do |env|
  env.response.content_type = "application/json"
  country = env.params.url["country"]
  data = cache.data[country]?
  halt env, status_code: 404, response: ({:error => "#{country} not found"}).to_json if data.nil? 
  data.to_json
end

get "/" do |env|
  env.response.content_type = "application/json"
  cache.data.to_json
end

def main
  Kemal.config.env = "production"
  Kemal.run
end

main