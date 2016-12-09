require_relative '../../lib/regret/tasks/clear'

describe Regret::Tasks::Clear do
  describe '.call!' do
    it 'removes files in regret/ paths not found in the report' do
      content = double
      report_path = File.realdirpath "#{File.dirname(__FILE__)}/../../tmp/regret.yml"
      allow(File).to receive(:read).with(report_path) { content }
      allow(YAML).to receive(:load).with(content).and_return(
        {
          a: {
            actual: 'path_1',
            expected: 'path_2',
            diff: 'path_3',
          },
          b: {
            actual: 'path_4',
            expected: 'path_5',
            diff: 'path_6',
          },
        }
      )

      allow(Dir).to receive(:glob).with('**/regret/**.png').and_return(
        [
          'path_1',
          'path_2',
          'path_3',
          'path_4',
          'path_5',
          'path_6',
          'path_7',
          'path_8',
        ]
      )

      allow(File).to receive(:delete)

      report_output = <<-TEXT
        removed path_7
        removed path_8
        unused screenshots removed
      TEXT

      report_output.gsub!(/^\s+/, '')

      expect { Regret::Tasks::Clear.call! }.to output(report_output).to_stdout

      expect(File).to have_received(:delete).with('path_7')
      expect(File).to have_received(:delete).with('path_8')

      expect(File).to_not have_received(:delete).with('path_1')
      expect(File).to_not have_received(:delete).with('path_2')
      expect(File).to_not have_received(:delete).with('path_3')
      expect(File).to_not have_received(:delete).with('path_4')
      expect(File).to_not have_received(:delete).with('path_5')
      expect(File).to_not have_received(:delete).with('path_6')
    end
  end
end
