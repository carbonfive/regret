require_relative '../lib/regret/image_comparer.rb'

describe Regret::ImageComparer do

  describe '#diff' do
    it 'returns a collection of diffs from the two images' do
      comparer = Regret::ImageComparer.new('spec/fixtures/image_1.png', 'spec/fixtures/image_2.png')

      expect(comparer.diff).to eq [
        [17, 26],
        [17, 27],
        [17, 28],
        [17, 29],
        [17, 30],
        [17, 31],
        [18, 26],
        [18, 27],
        [18, 28],
        [18, 29],
        [18, 30],
        [18, 31],
        [19, 26],
        [19, 27],
        [19, 28],
        [19, 29],
        [19, 30],
        [19, 31],
        [20, 26],
        [20, 27],
        [20, 28],
        [20, 29],
        [20, 30],
        [20, 31],
        [21, 26],
        [21, 27],
        [21, 28],
        [21, 29],
        [21, 30],
        [21, 31],
        [22, 26],
        [22, 27],
        [22, 28],
        [22, 29],
        [22, 30],
        [22, 31],
      ]
    end
  end

end
