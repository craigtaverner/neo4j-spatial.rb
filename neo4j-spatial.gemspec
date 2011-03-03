lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'neo4j/spatial/version'

Gem::Specification.new do |s|
  s.name = "neo4j-spatial"
  s.version = Neo4j::Spatial::VERSION
  s.platform = 'java'
  s.authors = "Craig Taverner"
  s.email = 'craig@amanzi.com'
  s.homepage = "http://github.com/craigtaverner/neo4j-spatial.rb"
  s.rubyforge_project = 'neo4j-spatial'
  s.summary = "JRuby access to Neo4j-Spatial"
  s.description = <<-EOF
Neo4j-Spatial adds GIS and spatial analysis capabilities to the Neo4j Graph Database. This allows you to load spatial data,
like points, lines, polygons and more complex geometries, index them and perform fast spatial queries on them. It includes
specific support for OSM data, and Simple Feature data (as found in Shapefile format), but can be layered on top of any
existing Neo4j database with spatial data, or data with some spatial elements. The Neo4j-Spatial.rb wrapper allows you to
access Neo4j-Spatial features from the convenience of the Ruby scripting language.
EOF

  s.require_path = 'lib'
  s.files        = Dir.glob("{bin,lib,examples}/**/*").reject{|x| x=~/(tmp|target|croatia|test-data)/} + %w(README.rdoc CHANGELOG CONTRIBUTORS Gemfile neo4j-spatial.gemspec)
  s.has_rdoc = true
  s.extra_rdoc_files = %w( README.rdoc )
  s.rdoc_options = ["--quiet", "--title", "Neo4j-Spatial.rb", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source"]
  s.required_ruby_version = ">= 1.8.7"
  s.add_dependency('neo4j',">= 1.0.0")
  s.add_dependency('amanzi-sld',">= 0.0.1")
end
