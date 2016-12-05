require_relative '../../lib/regret/test_helper.rb'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'byebug'

Capybara.javascript_driver = :poltergeist

describe 'Running a spec with capybara', type: :feature, js: true do
  it 'allows comparing screenshots' do
    directory = File.dirname(__FILE__)

    visit "file://#{directory}/../fixtures/test.html"

    not_found_file = "#{directory}/regret/not_found.png"

    begin
      File.delete(not_found_file)
      rescue Errno::ENOENT
    end


    expect(File.exists? not_found_file).to eq false

    expect(Regret::TestHelper.compare(page, label: 'test_blue', selector: '.blue')).to eq true

    expect(Regret::TestHelper.compare(page, label: 'test_blue', selector: '.red')).to eq false

    expect(Regret::TestHelper.compare(page, label: 'test_green', selector: '.green')).to eq true

    expect(Regret::TestHelper.compare(page, label: 'not_found', selector: '.green')).to eq true

    expect(File.exists? not_found_file).to eq true
  end
end
