
module Egrex
  module Log
    @@level = :trace
    @@caller_path_to_drop = ENV['PWD']
    LEVELS = [:info, :trace]
    def on?(level)
      @@level && (LEVELS.index(@@level) >= LEVELS.index(level))
    end
    def self.level=(level)
      @@level = level
    end
    def self.off
      @@level = nil
    end
    def trace(m)
      log m if on?(:trace)
    end
    def info(m)
      log m if on?(:info)
    end
    def log(m)
      puts m + "\t\t\t\t\tat " + caller[1].to_s.sub(@@caller_path_to_drop, '').partition(':in')[0]
    end
  end
end