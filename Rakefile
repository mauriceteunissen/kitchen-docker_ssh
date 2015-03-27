require "bundler/gem_tasks"
require 'cane/rake_task'
require 'tailor/rake_task'
require "kitchen"

desc "Run cane to check quality metrics"
Cane::RakeTask.new do |cane|
  cane.canefile = './.cane'
end

Tailor::RakeTask.new

desc "Display LOC stats"
task :stats do
  puts "\n## Production Code Stats"
  sh "countloc -r lib"
end

task :ci => ['ci:kitchen:all']
namespace :ci do
  namespace :kitchen do

    config = nil
    begin
      config = Kitchen::Config.new({:loader => Kitchen::Loader::YAML.new({:project_config => 'test/.kitchen.yml'}) })
       
      config.instances.each do |instance|
        desc "Run #{instance.name} test instance"
        task instance.name do
          instance.test(:always)
        end
      end
    rescue LoadError
      puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
    end
  
  
    desc "Run all test instances"
    task "all" => config.instances.map(&:name)
  end
end

desc "Run all quality tasks"
task :quality => [:cane, :tailor, :stats]
task :test => [:quality, :ci]
task :default => [:quality]

