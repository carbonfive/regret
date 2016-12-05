require_relative '../lib/regret/test_helper'
require_relative '../lib/regret/image_comparer'
require_relative '../lib/regret/configuration'

Regret::Configuration.configure do |config|
  config.tmp_path = File.dirname(__FILE__) + "../tmp"
end

describe Regret::TestHelper do

  let(:page) do
    double(:page, save_screenshot: nil)
  end

  let(:image_comparer) { double(diff: diff) }

  describe '.compare' do
    context 'when provided a label' do
      let(:test_file_path) { Regret::Configuration.tmp_path + '/some_label.png' }
      let(:expected_file_path) { File.dirname(__FILE__) + '/regret/some_label.png' }
      let(:expected_file_exists) { false }

      before do
        allow(page).to receive(:save_screenshot)
        allow(File).to receive(:exists?) { expected_file_exists }
      end

      it 'takes a screenshot using provided page session' do
        allow(File).to receive(:rename)

        Regret::TestHelper.compare(page, label: 'some_label', selector: 'foobar')

        expect(page).to have_received(:save_screenshot).with(
          test_file_path, { selector: 'foobar' }
        )
      end

      context 'when the target screenshot already exists' do
        let(:expected_file_exists) { true }

        before do
          allow(Regret::ImageComparer).to receive(:new).with(
            expected_file_path,
            test_file_path,
          ).and_return(image_comparer)
        end

        context 'and the screenshots match' do
          let(:diff) { [] }

          it 'compares the screenshot to the one already in references' do
            expect(Regret::TestHelper.compare(page, label: 'some_label')).to eq true
          end
        end

        context 'and the screenshots do not match' do
          let(:diff) { [1, 2] }

          it 'compares the screenshot to the one already in references' do
            expect(Regret::TestHelper.compare(page, label: 'some_label')).to eq false
          end
        end
      end

      context 'when the target screenshot does not exist' do
        let(:expected_file_exists) { false }

        before do
          allow(File).to receive(:rename)
        end

        it 'moves the screenshot to the expected folder location' do
          Regret::TestHelper.compare(page, label: 'some_label')

          expect(File).to have_received(:rename).with(test_file_path, expected_file_path)
        end

        it 'returns true' do
          expect(Regret::TestHelper.compare(page, label: 'some_label')).to eq true
        end
      end
    end

  end

end
