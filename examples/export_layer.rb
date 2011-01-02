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
  puts
  exit 0
end

if $help || $args.length < 1
  puts <<-eos

usage: ./export_layer.rb <-D storage_path> <-F format> <-E dir> <-l> <-h> layer <layers>
    -D  Use specified database location
    -F  Use specified export format (png, shp)
    -E  Use specified export directory path (default '.')
    -l  List existing database layers first
    -h  Display this help and exit
  The layer(s) should be pre-existing layers (including dynamic layers) in the database.
  Supported formats are 'shp' for ESRI Shapefile and 'png' for images.

For example:
  ./export_layer.rb -D db -E exports -F png croatia.osm highway highway-residential natural-water

This will export four previously defined layers to png format files in the 'exports' directory.

eos
  exit
end

if $format.to_s === 'shp'
  $exporter = Neo4j::Spatial::ShapefileExporter.new :dir => $export
else
  $exporter = Neo4j::Spatial::ImageExporter.new :dir => $export
end

puts "Exporting #{$args.length} layers to #{$exporter.format}"

$args.each do |layer|
  l = Neo4j::Spatial::Layer.find layer
  puts "Exporting #{l} (#{l.type_name}) - #{l.index.layer_bounding_box}"
  $exporter.export l.name
end
