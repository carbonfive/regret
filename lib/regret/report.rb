require_relative 'configuration'
require 'yaml'

module Regret
  class Report
    def self.reset!
      begin
        File.delete(path)
      rescue Errno::ENOENT
      end
    end

    def self.report_mismatch(test_name, actual_image, expected_image, diff_image)
      yaml = begin
        YAML.load File.read(path)
      rescue Errno::ENOENT
        {}
      end

      yaml[test_name] = {
        matched: false,
        actual: File.realdirpath(actual_image),
        expected: File.realdirpath(expected_image),
        diff: File.realdirpath(diff_image),
      }

      File.write path, YAML.dump(yaml)
    end

    def self.report_results
      yaml = begin
        YAML.load File.read(path)
      rescue Errno::ENOENT
        {}
      end

      mismatches = yaml.reject { |k, v| v[:matched] }

      if mismatches.any?
        puts "FOUND MISMATCHES:"
        mismatches.each do |k, v|
          puts k
          puts "ACTUAL:   #{v[:actual]}"
          puts "EXPECTED: #{v[:expected]}"
          puts "DIFF:     #{v[:diff]}"
        end
      end
    end

    def self.path
      "#{Regret::Configuration.tmp_path}/regret.yml"
    end
  end

end
