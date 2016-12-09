require 'yaml'

module Regret
  module Tasks
    module Clear
      def self.call!
        report_path = File.realdirpath(ENV['REPORT_PATH'] || "#{File.dirname(__FILE__)}/../../../tmp/regret.yml")
        report = YAML.load File.read(report_path)

        screenshots = Dir.glob("**/regret/**.png")
        used_screenshots = report.values.map do |v|
          [ v[:actual], v[:expected], v[:diff] ]
        end.flatten

        screenshots_to_remove = screenshots - used_screenshots

        screenshots_to_remove.each do |file|
          File.delete(file)
          puts "removed #{file}"
        end

        puts "unused screenshots removed"
      end
    end
  end
end
