require 'neo4j/spatial/listener'
require 'neo4j/spatial/database'

# Utilities for importing and exporting ESRI Shapefile data

module Neo4j
  module Spatial
    
    # This class facilitates importing datasets in the ESRI Shapefile format
    class ShapefileImporter
      include Listener
      include Database
      def initialize(options={})
        database(options)
        @importer = org.neo4j.gis.spatial.ShapefileImporter.new(@db.graph, self, @commit)
      end
      def import(shp_path,layer_name=nil)
        @shp_path = shp_path
        layer_name ||= shp_path.split(/[\\\/]+/)[-1].gsub(/\.\w+$/,'')
        @importer.import_file @shp_path, layer_name
      end
      def to_s
        @shp_path.to_s
      end
    end

    # This class facilitates importing datasets in the ESRI Shapefile format
    class ShapefileExporter
      include Database
      def initialize(options={})
        options[:dir] ||= "target/export"
        database(options)
        @exporter = org.neo4j.gis.spatial.ShapefileExporter.new(@db.graph)
        @exporter.setExportDir(options[:dir])
      end
      def export(layer_name,options={})
        @layer_name = layer_name
        options[:path] ||= layer_name+'.shp'
        puts "Exporting #{layer_name} to #{options[:path]}"
        @exporter.exportLayer(layer_name, options[:path])
      end
      def format
        "ESRI Shapefile"
      end
      def to_s
        @layer_name || format
      end
    end
  end
end
