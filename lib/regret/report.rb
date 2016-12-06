require_relative 'configuration'
require 'yaml'

module Regret
  class Report
    def self.reset!
      File.delete(path)
    end

    def self.report_mismatch(test_name)
      yaml = begin
        YAML.load File.read(path)
      rescue Errno::ENOENT
        {}
      end

      yaml[test_name] = "mismatch"
      File.write path, YAML.dump(yaml)
    end

    def self.report_results
      yaml = begin
        YAML.load File.read(path)
      rescue Errno::ENOENT
        {}
      end

      mismatches = yaml.select do |k, v|
        v == 'mismatch'
      end

      if mismatches.any?
        puts "FOUND MISMATCHES:"
        mismatches.each do |k, v|
          puts k
        end
      end
    end

    def self.path
      "#{Regret::Configuration.tmp_path}/regret.yml"
    end
  end

end
