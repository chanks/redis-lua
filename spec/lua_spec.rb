require 'spec_helper'

describe Redis do
  describe "#register_script" do
    it "should remember a Lua script for execution" do
      script = $redis.register_script 'my_script', "return 1"
      script.should be_an_instance_of Redis::Script
      $redis.scripts.should == [script]

      script.text.should == "return 1"
      script.text.should be_frozen

      script.name.should == :my_script

      script.sha.should == 'e0e1f9fabfc9d4800c877a703b823ac0578ff8db'
      script.sha.should be_frozen
    end
  end

  describe "#register_script_files" do
    it "should register the scripts in a glob of files, using their filenames as script names" do
      result = $redis.register_script_files './spec/support/scripts/*'
      result.length.should be 2
      result.each { |s| s.should be_an_instance_of Redis::Script }
      result.should == $redis.scripts

      one, two = result.sort_by(&:name)
      one.name.should == :one
      one.text.should == "return 1\n"
      one.sha.should  == "48df9b519ca145c867b895f740b37bd891e887af"

      two.name.should == :two
      two.text.should == "return 2\n"
      two.sha.should  == "b7ac6454df41a85df39e338f3e08cce31719ab72"
    end
  end

  describe "#run_script" do
    before do
      $redis.register_script 'argless', "return 1"
      $redis.register_script 'onearg',  "return ARGV[1] + 1"
      $redis.register_script 'twoargs', "return ARGV[1] + ARGV[2]"
    end

    it "should load and execute a Lua script that hasn't been run before" do
      $redis.run_script(:argless).should == 1
      $redis.run_script(:onearg, :argv => [3]).should == 4
      $redis.run_script(:twoargs, :argv => [4, 5]).should == 9
    end

    it "should execute a Lua script that's been loaded and run before" do
      sha = $redis.script :load, "return 1"
      $redis.run_script(:argless).should == 1
    end

    it "with an unregistered Lua script should raise an error" do
      proc{$redis.run_script :nonexistent_script}.should raise_error RuntimeError, /Nonexistent Lua script!/
    end

    it "should gracefully handle a loss of the script cache" do
      $redis.run_script(:argless).should == 1
      $redis.script(:flush)
      $redis.run_script(:argless).should == 1
    end

    it "in a transaction should execute a Lua script that hasn't been run before without losing the transaction" do
      result = nil

      $redis.multi do
        $redis.incr 'key'
        result = $redis.run_script :argless
      end

      $redis.get('key').should == '1'
      result.class.should == Redis::Future
      result.value.should == 1
    end

    it "in a pipeline should execute a Lua script that hasn't been run before" do
      result = nil

      $redis.pipelined do
        $redis.incr 'key'
        result = $redis.run_script :argless
      end

      $redis.get('key').should == '1'
      result.class.should == Redis::Future
      result.value.should == 1
    end
  end
end

describe Redis::Pool do
  it "should work as expected" do
    $redis_pool.register_script(:my_script, 'return 1')

    10.times.map do
      Thread.new do
        10.times do
          $redis_pool.run_script(:my_script).should == 1
        end
      end
    end.each(&:join)
  end
end
