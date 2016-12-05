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
  end
end
