require 'redis'
require 'digest/sha1'

class Redis
  module Lua
    Version = '0.0.1'

    def run_script(name, *args)
      raise "Nonexistent Lua script!" unless s = scripts.find { |script| script.name == name }
      evalsha s.sha, *args
    rescue CommandError => e
      if e.message =~ /\ANOSCRIPT/
        script :load, s.text
        evalsha s.sha, *args
      else
        raise
      end
    end

    def register_script(name, text)
      script = Script.new(name, text)
      scripts << script
      script
    end

    def register_script_files(glob)
      Dir[glob].map do |filename|
        script_name = filename.split('/').last.split('.').first
        register_script script_name, File.read(filename)
      end
    end

    def scripts
      @scripts ||= []
    end

    class Script
      attr_reader :name, :text, :sha

      def initialize(name, text)
        @name = name.to_sym
        @text = text.dup.freeze
        @sha  = Digest::SHA1.hexdigest(text).freeze
      end
    end
  end

  include Lua
end
