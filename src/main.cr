require "kemal"
require "tasker"
require "redis"
require "./jhu_parser.cr"

REDIS = Redis.new

module Controllers
  get "/:country" do |env|
    env.response.content_type = "application/json"
    country = env.params.url["country"]
    REDIS.get(country)
  end

  get "/" do 
    REDIS.get(:all)
  end

end


schedule = Tasker.instance
schedule.every(1.minutes) {
  jhu = JHU::Parser.new
  REDIS.set(:total, jhu.total.to_json)
  all = jhu.all
  all.each do |country, value|
      REDIS.set(country, value.to_json)
  end
  REDIS.set(:all, all.to_json)
  } 

logging false
Kemal.run
