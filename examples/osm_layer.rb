#!/usr/bin/env jruby

$: << '../lib' # useful if being run inside a source code checkout

require 'rubygems'
require 'neo4j/spatial'
require 'neo4j/spatial/cmd'

$args = Neo4j::Spatial::Cmd.args

if $list === 'layers'
  layers = Neo4j::Spatial::Layer.list
  puts "Have #{layers.length} existing layers in the database:"
  layers.each {|l| puts "\t#{l} (#{l.type_name})"}
end

if $help || $args.length < 2
  puts <<-eos

usage: ./osm_layer.rb <-D storage_path> <-l> <-h> layer layerspec <layerspecs>
    -D  Use specified database location
    -l  List existing database layers
    -h  Display this help and exit
  The layer should be a pre-existing OSM layer in the database created with OSM import.
  The layerspec(s) are strings that are composed of multiple '-' or '.' separators.
  Each pair in order is treated as a property-value pair to match when searching the
  original layer for the new dynamic layer geometries.

For example:
  ./osm_layer.rb -D db croatia.osm highway highway-residential natural-water

This will define three dynamic layers in the croation.osm dataset:
  highway               all ways that have a 'highway' property
  highway-residential   all ways that have 'highway'='residential'
  natural-waterway      all ways that have 'natural'='waterway'

eos
  exit
end

$layer = Neo4j::Spatial::OSMLayer.new $args.shift

if $layer.empty?
  puts "No such layer: #{$layer}"
end

$args.each do |layerspec|
  x = layerspec.split(/[\.-]/) << nil
  x = x[0...(2*(x.length/2))] # allow only even number of entries
  $layer.add_dynamic_layer Hash[*x]
end
