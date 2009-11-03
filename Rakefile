require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "veneer"
    gem.summary = %Q{A thin veneer over data stores}
    gem.description = %Q{Veneer provides basic querying, saving, deleteing and creating of data stores.}
    gem.email = "has.sox@gmail.com"
    gem.homepage = "http://github.com/hassox/veneer"
    gem.authors = ["Daniel Neighman"]
    gem.rubyforge_project = "veneer"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

#require 'spec/rake/spectask'
#Spec::Rake::SpecTask.new(:spec) do |spec|
#  spec.libs << 'lib' << 'spec'
#  spec.spec_files = FileList['spec/**/*_spec.rb']
#end
#
#Spec::Rake::SpecTask.new(:rcov) do |spec|
#  spec.libs << 'lib' << 'spec'
#  spec.pattern = 'spec/**/*_spec.rb'
#  spec.rcov = true
#end
#
#task :spec => :check_dependencies
#
#task :default => :spec

task :default => [:test_units]
require 'rake/testtask'
desc "Run test suite."
Rake::TestTask.new("test"){ |test|
  test.pattern = "test/*_test.rb"
  test.verbose = true
  test.warning = true
  test.libs << "test"
  test.test_files = FileList["test/test*.rb", "test/**/*_test.rb"]
}

task :test => :check_dependencies

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "veneer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
