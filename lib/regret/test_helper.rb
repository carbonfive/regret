require_relative 'image_comparer'

module Regret

  class TestHelper

    def self.compare(page, label:, selector: nil)
      executor_path = File.dirname(caller.first.gsub(/\:d+$/, ''))
      existing_path = "#{executor_path}/regret/#{label}.png"
      new_path = "#{Regret::Configuration.tmp_path}/#{label}.png"

      comparer = ImageComparer.new(existing_path, new_path)

      comparer.diff.empty?
    end

  end

end
