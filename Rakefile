require 'rspec/core/rake_task'
load "lib/tasks/regret.rake"

task :default => :spec

task :spec do
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec)
  rescue LoadError
  end
end
