require_relative '../lib/regret/report.rb'
require_relative '../lib/regret/exceptions.rb'

Regret::Configuration.configure do |config|
  config.tmp_path = File.dirname(__FILE__) + "/../tmp"
end

describe Regret::Report do

  describe '.reset!' do
    it 'resets the report' do
      Regret::Report.report_mismatch('a', 'b', 'c', 'd')

      Regret::Report.reset!

      expect(Regret::Report.report_results).to eq true
    end
  end

  describe '.report_results' do
    before do
      Regret::Report.reset!
    end

    context 'when a mismatch was reported' do
      it 'returns false' do
        Regret::Report.report_mismatch('a', 'b', 'c', 'd')

        expect(Regret::Report.report_results).to eq false
      end
    end

    context 'when a mismatch was not reported' do
      it 'returns true' do
        expect(Regret::Report.report_results).to eq true
      end
    end
  end

  describe '.report_results!' do
    before do
      Regret::Report.reset!
    end

    context 'when a mismatch was reported' do
      it 'raises an exception' do
        Regret::Report.report_mismatch('a', 'b', 'c', 'd')

        expect { Regret::Report.report_results! }.to raise_error(Regret::Exceptions::TestFailure)
      end
    end

    context 'when a mismatch was not reported' do
      it 'does not raise an exception' do
        expect { Regret::Report.report_results! }.to_not raise_error
      end
    end
  end
end
