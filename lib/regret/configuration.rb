module Regret
  module Configuration
    def self.configure
      yield self
    end

    def self.tmp_path=(value)
      @tmp_path = value
    end

    def self.tmp_path
      @tmp_path
    end

    def self.window_sizes=(value)
      @window_sizes = value
    end

    def self.window_sizes
      @window_sizes
    end
  end
end
