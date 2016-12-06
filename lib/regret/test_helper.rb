require_relative 'image_comparer'
require_relative 'report'

module Regret

  class TestHelper

    def self.compare(page, name:, selector: nil)
      executor_path = File.dirname(caller.first.gsub(/\:d+$/, ''))
      existing_path = "#{executor_path}/regret/#{name}.png"
      test_path = "#{Regret::Configuration.tmp_path}/#{name}.png"

      page.save_screenshot test_path, selector: selector

      if File.exists? existing_path
        comparer = ImageComparer.new(existing_path, test_path)
        matched = comparer.diff.empty?
        Report.report_mismatch(name) unless matched
        matched
      else
        folder = "#{executor_path}/regret/"

        Dir.mkdir folder unless Dir.exists? folder

        File.rename(test_path, existing_path)
        true
      end
    end

  end

end
