require_relative "../regret/tasks/clear.rb"

namespace :regret do
  desc "Clear unused screenshots"
  task :clear do
    Regret::Tasks::Clear.call!
  end
end
