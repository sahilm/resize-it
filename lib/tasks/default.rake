# frozen_string_literal: true

task default: [
  :tslint,
  :rubocop,
  'brakeman:run_default',
]

begin
  require 'rubocop/rake_task'

  desc 'Run rubocop'
  RuboCop::RakeTask.new
rescue LoadError => e
  STDERR.puts(e)
end

desc 'tslint'
task :tslint do
  sh('node_modules/.bin/tslint -c tslint.json app/javascript/**/*.tsx app/javascript/**/*.ts')
end

namespace :brakeman do
  desc "Run Brakeman"
  task :run, :output_files do |_t, args|
    require 'brakeman'

    files = if args[:output_files]
              args[:output_files].split(' ')
            else
              []
            end
    Brakeman.run app_path: ".", output_files: files, print_report: true
  end

  task :run_default do
    require 'brakeman'
    Brakeman.run(app_path: ".",
                 print_report: true,
                 exit_on_warn: true,
                 confidence_level: 3)
  end
end
