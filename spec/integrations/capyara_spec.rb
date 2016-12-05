require_relative '../../lib/regret/image_comparer.rb'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'byebug'

Capybara.javascript_driver = :poltergeist

describe 'Running a spec with capybara', type: :feature, js: true do
  xit 'allows comparing screenshots' do
    directory = File.dirname(__FILE__)

    visit "file://#{directory}/../fixtures/test.html"

    expect(Regret::TestHelpers.compare(page, label: 'test_blue', selector: '.blue')).to eq true

    expect(Regret::TestHelpers.compare(page, label: 'test_blue', selector: '.red')).to eq false

    expect(Regret::TestHelpers.compare(page, label: 'test_green', selector: '.green')).to eq true
  end
end
