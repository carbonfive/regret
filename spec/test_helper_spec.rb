require_relative '../lib/regret/test_helper'
require_relative '../lib/regret/image_comparer'
require_relative '../lib/regret/configuration'
require_relative '../lib/regret/report'

Regret::Configuration.configure do |config|
  config.tmp_path = File.dirname(__FILE__) + "/../tmp"
end

describe Regret::TestHelper do

  let(:page) do
    double(:page, save_screenshot: nil)
  end

  let(:image_comparer) { double(diff: diff) }

  describe '.compare' do
    context 'when provided a name' do
      let(:actual_file_path) { Regret::Configuration.tmp_path + '/some_name.png' }
      let(:expected_file_path) { File.dirname(__FILE__) + '/regret/some_name.png' }
      let(:expected_file_exists) { false }

      before do
        allow(page).to receive(:save_screenshot)
        allow(File).to receive(:exists?) { expected_file_exists }
      end

      it 'takes a screenshot using provided page session' do
        allow(File).to receive(:rename)

        Regret::TestHelper.compare(page, name: 'some_name', selector: 'foobar')

        expect(page).to have_received(:save_screenshot).with(
          actual_file_path, { selector: 'foobar' }
        )
      end

      describe 'screenshot folder' do
        before do
          allow(Dir).to receive(:mkdir)
          allow(Dir).to receive(:exists?) { dir_exists }
          allow(File).to receive(:rename)
        end

        context 'when the screenshot folder does not exist' do
          let(:dir_exists) { false }

          it 'creates a new folder for screenshots' do
            folder = File.dirname(__FILE__) + '/regret/'

            Regret::TestHelper.compare(page, name: 'some_name')

            expect(Dir).to have_received(:mkdir).with(folder)
          end
        end

        context 'when the screenshot folder does exist' do
          let(:dir_exists) { true }

          it 'does not create a new folder' do
            Regret::TestHelper.compare(page, name: 'some_name')

            expect(Dir).to_not have_received(:mkdir)
          end
        end
      end

      context 'when the target screenshot already exists' do
        let(:expected_file_exists) { true }

        before do
          allow(Regret::ImageComparer).to receive(:new).with(
            expected_file_path,
            actual_file_path,
          ).and_return(image_comparer)
        end

        context 'and the screenshots match' do
          let(:diff) { [] }

          it 'compares the screenshot to the one already in references' do
            expect(Regret::TestHelper.compare(page, name: 'some_name')).to eq true
          end
        end

        context 'and the screenshots do not match' do
          let(:diff) { [1, 2] }

          before do
            allow(image_comparer).to receive(:create_diff_image!)
            allow(Regret::Report).to receive(:report_mismatch)
          end

          it 'compares the screenshot to the one already in references' do
            expect(Regret::TestHelper.compare(page, name: 'some_name')).to eq false
          end

          it 'creates a diff image' do
            folder = File.dirname(__FILE__) + '/../tmp'
            Regret::TestHelper.compare(page, name: 'some_name')
            expect(image_comparer).to have_received(:create_diff_image!).with("#{folder}/some_name-diff.png")
          end

          it 'reports on the mismatch' do
            folder = File.dirname(__FILE__) + '/../tmp'
            Regret::TestHelper.compare(page, name: 'some_name')
            expect(Regret::Report).to have_received(:report_mismatch).with(
              'some_name', actual_file_path, expected_file_path, "#{folder}/some_name-diff.png"
            )
          end
        end
      end

      context 'when the target screenshot does not exist' do
        let(:expected_file_exists) { false }

        before do
          allow(File).to receive(:rename)
        end

        it 'moves the screenshot to the expected folder location' do
          Regret::TestHelper.compare(page, name: 'some_name')

          expect(File).to have_received(:rename).with(actual_file_path, expected_file_path)
        end

        it 'returns true' do
          expect(Regret::TestHelper.compare(page, name: 'some_name')).to eq true
        end
      end
    end
  end
end
