require "kemal"
require "./cache"

cache = Cache.new

get "/:country" do |env|
  env.response.content_type = "application/json"
  data = cache.data[env.params.url["country"]]?
  halt env, status_code: 404, response: "#{env.params.url["country"]} not found" if data.nil? 
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