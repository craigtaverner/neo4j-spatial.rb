#!/usr/bin/env jruby

# useful if being run inside a source code checkout
$: << 'lib'
$: << '../lib'

require 'rubygems'
require 'neo4j/spatial'

require 'neo4j/spatial/cmd'

$args = Neo4j::Spatial::Cmd.args

if $list === 'layers'
  layers = Neo4j::Spatial::Layer.list
  puts "Have #{layers.length} existing layers in the database:"
  layers.each {|l| puts "\t#{l} (#{l.type_name})"}
  puts
  exit 0
end

if $help || $args.length < 1
  puts <<-eos

usage: ./osm_random_trace.rb <-D storage_path> <-E dir> <-M #> <-l> <-h> layer <layers>
    -D  Use specified database location
    -E  Use specified export directory path (default '.')
    -M  Number of points to include in trace (default 1000)
    -l  List existing database layers
    -h  Display this help and exit
  The layer should be a pre-existing OSM layer in the database created with OSM import.
  Each layer specified will have a random point selected, and then all trace a route
  from that point through the graph of connected ways. The entire route is then output
  as an SHP and PNG export.

eos
  exit
end

$shp_exporter = Neo4j::Spatial::ShapefileExporter.new :dir => $export
$png_exporter = Neo4j::Spatial::ImageExporter.new :dir => $export

puts "Finding random routes from #{$args.length} layers"

$args.each do |layer|
  l = Neo4j::Spatial::Layer.find layer
  if l.type_name === 'osm'
    osm = l.dataset
    puts "Have dataset: #{osm}"
    osm.ways[0..1].each do |w|
      puts "Have way: #{w}"
      puts "Have way points: #{w.points}"
    end
    #puts "Exporting #{l} (#{l.type_name}) - #{l.index.layer_bounding_box}"
    #$exporter.export l.name
  else
    puts "Layer #{l} does not appear to be an OSM layer"
  end
end
