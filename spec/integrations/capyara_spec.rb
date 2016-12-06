require_relative '../../lib/regret/test_helper.rb'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'byebug'
require_relative '../../lib/regret/configuration'
require_relative '../../lib/regret/report'

Regret::Configuration.configure do |config|
  config.tmp_path = File.realdirpath(File.dirname(__FILE__) + "/../../tmp")
end

Capybara.javascript_driver = :poltergeist

describe 'Running a spec with capybara', type: :feature, js: true do
  it 'allows comparing screenshots' do
    Regret::Report.reset!

    directory = File.dirname(__FILE__)

    visit "file://#{directory}/../fixtures/test.html"

    not_found_file = File.realdirpath("#{directory}/regret/not_found.png")
    diff_file = File.realdirpath("#{directory}/../../tmp/test_blue-diff.png")

    begin
      File.delete(not_found_file)
      rescue Errno::ENOENT
    end

    begin
      File.delete(diff_file)
      rescue Errno::ENOENT
    end

    expect(File.exists? not_found_file).to eq false
    expect(File.exists? diff_file).to eq false

    expect(Regret::TestHelper.compare(page, name: 'test_blue', selector: '.blue')).to eq true

    expect(Regret::TestHelper.compare(page, name: 'test_blue', selector: '.red')).to eq false

    expect(Regret::TestHelper.compare(page, name: 'test_green', selector: '.green')).to eq true

    expect(Regret::TestHelper.compare(page, name: 'not_found', selector: '.green')).to eq true

    expect(File.exists? not_found_file).to eq true
    expect(File.exists? diff_file).to eq true

    report_output = <<-TEXT
      FOUND MISMATCHES:
      test_blue
      ACTUAL:   #{File.realdirpath("#{directory}/../../tmp/test_blue.png")}
      EXPECTED: #{directory}/regret/test_blue.png
      DIFF:     #{diff_file}
    TEXT

    report_output.gsub!(/^\s+/, '')

    expect { Regret::Report.report_results }.to output(report_output).to_stdout
  end
end
