require 'yaml'

module Regret
  module Tasks
    module AcceptAll
      def self.call!
        report_path = File.realdirpath(ENV['REPORT_PATH'] || "#{File.dirname(__FILE__)}/../../../tmp/regret.yml")
        report = YAML.load File.read(report_path)

        report.values.each do |v|
          [ v[:actual], v[:expected], v[:diff] ]
          File.rename(v[:actual], v[:expected])
          puts "moved #{v[:actual]} to #{v[:expected]}"
        end

        puts "tmp screenshots promoted to fixtures"
      end
    end
  end
end
