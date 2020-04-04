require "kemal"
require "./cache"

cache = Cache.new

get "/:country" do |env|
  env.response.content_type = "application/json"
  cache.data[env.params.url["country"]].to_json
end

get "/" do |env|
  env.response.content_type = "application/json"
  cache.data.to_json
end

def main
  logging(false)
  Kemal.run
end

main