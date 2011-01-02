#!/usr/bin/env jruby

$: << 'lib'
$: << '../lib'

require 'rubygems'
require 'neo4j/spatial'
require 'fileutils'
require 'amanzi/sld'

#shp_importer.import '../neo4j-spatial/target/shp/sweden_coastline.shp'
#png_exporter.export 'sweden_coastline'

if false
  FileUtils.rm_rf 'tmp'

  osm_importer = Neo4j::Spatial::OSMImporter.new
  osm_importer.import '../neo4j-spatial/map2.osm'
  osm = Neo4j::Spatial::OSMLayer.new "map2.osm"
  
  osm.add_dynamic_layer
  osm.add_dynamic_layer(:layer_name => 'test')
  osm.add_dynamic_layer(:highway => nil)
  osm.add_dynamic_layer(:highway => 'residential')
  osm.add_dynamic_layer(:highway => :unclassified)

else
  osm = Neo4j::Spatial::OSMLayer.new "map2.osm"
end

puts "OSM Layer index should not be null: #{osm.index}"
puts "OSM Layer index envelope should not be null: #{osm.index.layer_bounding_box}"
#osm.index.debug_index_tree

osm.layers.each do |l|
  puts "Have layer: #{l.name}"
  if l.respond_to? :query
    puts "\t#{l.query}"
  end
end

png_exporter = Neo4j::Spatial::ImageExporter.new
#shp_importer = Neo4j::Spatial::ShapefileImporter.new

# Define some common filtering rules
major_highways = Proc.new do |f|  
  f.op(:or) do |f|
    f.property[:highway] = 'primary'
    f.property[:highway] = 'motorway'
  end
end
   
highways = Proc.new do |f|
  f.op(:or) do |f|
    f.property[:highway] = 'primary'
    f.property[:highway] = 'secondary'
    f.property[:highway] = 'motorway'
  end
end

main_roads = Proc.new do |f|
  f.op(:or) do |f|
    f.property[:highway] = 'primary'
    f.property[:highway] = 'secondary'  
    f.property[:highway] = 'tertiary'
    f.property[:highway] = 'motorway'
    f.property[:highway] = 'residential'
  end
end

#png_exporter.export 'map2.osm', :sld => '../neo4j-spatial/neo.sld.xml'

png_exporter.export 'highway' do |sld|
  sld.add_line_symbolizer :stroke => '#909090', :stroke_width => 3
  sld.add_line_symbolizer :stroke => '#f0f0f0', :stroke_width => 2
  sld.add_line_symbolizer :stroke => '#909090', :stroke_width => 5 do |f|
    main_roads.call f
  end
  sld.add_line_symbolizer :stroke => '#909090', :stroke_width => 7 do |f|
    highways.call f
  end
  sld.add_line_symbolizer :stroke => '#e0e0e0', :stroke_width => 3 do |f|
    main_roads.call f
  end
  sld.add_line_symbolizer :stroke => '#f0f0a0', :stroke_width => 5 do |f|
    highways.call f
  end
end

#png_exporter.export 'highway-residential'
#png_exporter.export 'highway-unclassified'

