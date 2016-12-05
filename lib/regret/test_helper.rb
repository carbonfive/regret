require_relative 'image_comparer'

module Regret

  class TestHelper

    def self.compare(page, label:, selector: nil)
      executor_path = File.dirname(caller.first.gsub(/\:d+$/, ''))
      existing_path = "#{executor_path}/regret/#{label}.png"
      test_path = "#{Regret::Configuration.tmp_path}/#{label}.png"

      page.save_screenshot test_path, selector: selector

      if File.exists? existing_path
        comparer = ImageComparer.new(existing_path, test_path)
        comparer.diff.empty?
      else
        File.rename(test_path, existing_path)
        true
      end
    end

  end

end
