$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'rake'
require 'rdoc/task'

require "neo4j/spatial/version"



task :check_commited do
  status = %x{git status}
  fail("Can't release gem unless everything is committed") unless status =~ /nothing to commit \(working directory clean\)|nothing added to commit but untracked files present/
end

desc "clean all, delete all files that are not in git"
task :clean_all do
  system "git clean -df"
end

desc "create the gemspec"
task :build  do
  system "gem build neo4j-spatial.gemspec"
end

desc "release gem to gemcutter"
task :release => [:check_commited, :build] do
  system "gem push neo4j-spatial-#{Neo4j::Spatial::VERSION}-java.gem"
end

desc "Generate documentation for Neo4j-Spatial.rb"
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.title    = "Neo4j-Spatial.rb #{Neo4j::Spatial::VERSION}"
  rdoc.options << '--webcvs=http://github.com/craigtaverner/neo4j-spatial.rb/tree/master/'
  rdoc.options << '-f' << 'horo'
  rdoc.options << '-c' << 'utf-8'
  rdoc.options << '-m' << 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test_generators) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc 'Upload documentation to RubyForge.'
task 'upload-docs' do
  sh "scp -r doc/rdoc/* " +
    "craig@amanzi.com:/var/www/gforge-projects/neo4j-spatial/"
end

