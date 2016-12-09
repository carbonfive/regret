require_relative '../../lib/regret/tasks/accept_all'

describe Regret::Tasks::AcceptAll do
  describe '.call!' do
    it 'moves files in report from tmp locations to fixture locations' do
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

      allow(File).to receive(:rename)

      report_output = <<-TEXT
        moved path_1 to path_2
        moved path_4 to path_5
        tmp screenshots promoted to fixtures
      TEXT

      report_output.gsub!(/^\s+/, '')

      expect { Regret::Tasks::AcceptAll.call! }.to output(report_output).to_stdout

      expect(File).to have_received(:rename).with('path_1', 'path_2')
      expect(File).to have_received(:rename).with('path_4', 'path_5')
    end
  end
end
