require_relative '../../lib/regret/test_helper.rb'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'byebug'
require_relative '../../lib/regret/configuration'
require_relative '../../lib/regret/report'

Regret::Configuration.configure do |config|
  config.tmp_path = File.dirname(__FILE__) + "/../../tmp"
end

Capybara.javascript_driver = :poltergeist

describe 'Running a spec with capybara', type: :feature, js: true do
  it 'allows comparing screenshots' do
    Regret::Report.reset!

    directory = File.dirname(__FILE__)

    visit "file://#{directory}/../fixtures/test.html"

    not_found_file = "#{directory}/regret/not_found.png"

    begin
      File.delete(not_found_file)
      rescue Errno::ENOENT
    end


    expect(File.exists? not_found_file).to eq false

    expect(Regret::TestHelper.compare(page, name: 'test_blue', selector: '.blue')).to eq true

    expect(Regret::TestHelper.compare(page, name: 'test_blue', selector: '.red')).to eq false

    expect(Regret::TestHelper.compare(page, name: 'test_green', selector: '.green')).to eq true

    expect(Regret::TestHelper.compare(page, name: 'not_found', selector: '.green')).to eq true

    expect(File.exists? not_found_file).to eq true

    report_output = <<-TEXT
      FOUND MISMATCHES:
      test_blue
    TEXT

    report_output.gsub!(/^\s+/, '')

    expect { Regret::Report.report_results }.to output(report_output).to_stdout
  end
end
