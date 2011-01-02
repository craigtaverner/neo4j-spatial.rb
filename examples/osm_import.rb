#!/usr/bin/env jruby

$: << '../lib' # useful if being run inside a source code checkout

require 'rubygems'
require 'neo4j/spatial'
require 'neo4j/spatial/cmd'
require 'fileutils'

$files = Neo4j::Spatial::Cmd.args

if $help || $files.length < 1
  puts "usage: osm_import.rb <-d> <-D storage_path> file.osm"
  puts "\t-d\tDelete database first"
  puts "\t-D\tUse specified database location"
  exit
end

if $delete
    puts "Deleting previous database #{Neo4j::Config[:storage_path]}"
    FileUtils.rm_rf Neo4j::Config[:storage_path]
end

$files.each do |file|
  osm_importer = Neo4j::Spatial::OSMImporter.new
  osm_importer.import file
end
