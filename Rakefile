require 'bundler'
Bundler::GemHelper.install_tasks

task :default => [:test_units]
require 'rake/testtask'
desc "Run test suite."
Rake::TestTask.new("test"){ |test|
  test.pattern = "test/*_test.rb"
  test.verbose = true
  test.warning = true
  test.libs << "test"
  test.test_files = FileList["test/test*.rb", "test/**/test*.rb"]
}


