require_relative 'image_comparer'
require_relative 'report'

module Regret

  class TestHelper

    def self.compare(page, name:, selector: nil)
      executor_path = File.dirname(caller.first.gsub(/\:d+$/, ''))
      expected_path = "#{executor_path}/regret/#{name}.png"
      actual_path = "#{Regret::Configuration.tmp_path}/#{name}.png"

      page.save_screenshot actual_path, selector: selector

      folder = "#{executor_path}/regret/"
      Dir.mkdir folder unless Dir.exists? folder

      if File.exists? expected_path
        comparer = ImageComparer.new(expected_path, actual_path)
        matched = comparer.diff.empty?
        unless matched
          diff_path = "#{Regret::Configuration.tmp_path}/#{name}-diff.png"
          comparer.create_diff_image! diff_path
          Report.report_mismatch(name, actual_path, expected_path, diff_path)
        end
        matched
      else
        File.rename(actual_path, expected_path)
        true
      end
    end

  end

end
