require 'redis/lua'
require 'redis/pool'

RSpec.configure do |config|
  config.before do
    $redis.flushdb
    $redis.script :flush
    $redis.scripts.clear
    $redis_pool.scripts.clear
  end
end

$redis      = Redis.new
$redis_pool = Redis::Pool.new(:size => 5)
