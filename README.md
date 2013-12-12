# Redis::Lua

Adds a few methods to Ruby's Redis class to make handling Lua scripts a bit easier.

    # When your application initializes:
    $redis = Redis.new
    $redis.register_script(:my_script, "return 1")

    # Later...
    $redis.run_script(:my_script) #=> 1

You can also put scripts in their own files:

    # scripts/my_file_script.lua
    return 3

    # In your app:
    $redis.register_script_files('./scripts/*')
    $redis.run_script(:my_file_script) #=> 3

This lets you manage your Lua scripts in version control with the rest of your app, so you don't need to worry about loading them manually. If Redis' script cache is lost, they'll be automatically reloaded as needed.

## Installation

Add this line to your application's Gemfile:

    gem 'redis-lua'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis-lua

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
