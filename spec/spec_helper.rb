require 'redis/lua'

RSpec.configure do |config|
  config.before do
    $redis.flushdb
    $redis.script :flush
    $redis.scripts.clear
  end
end

$redis = Redis.new
