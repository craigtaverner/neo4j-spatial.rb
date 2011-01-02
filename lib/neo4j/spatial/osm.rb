require 'neo4j/spatial/listener'
require 'neo4j/spatial/database'

java_import org.neo4j.gis.spatial.Constants
java_import org.neo4j.gis.spatial.SpatialDatabaseService
java_import org.neo4j.gis.spatial.osm.OSMGeometryEncoder

module Neo4j
  module Spatial
    class OSMLayer < Layer
      def initialize(layer_name,options={})
        super(layer_name, options.merge({
          :type => org.neo4j.gis.spatial.osm.OSMLayer,
          :encoder => OSMGeometryEncoder
        }))
      end
      def add_dynamic_layer(options={})
        gtype = (options.delete(:gtype) || Constants.GTYPE_LINESTRING).to_i
        name ||= options.delete(:layer_name) ||
          !options.empty? && options.to_a.flatten.compact.join('-') ||
          SpatialDatabaseService.convertGeometryTypeToName(gtype)
        if list.grep(name).length > 0
          puts "We already have a dynamic layer called '#{name}'"
        else
          puts "Creating new dynamic layer '#{name}'[GType:#{TYPES[gtype]}]: #{options.inspect}"
          layer.add_dynamic_layer_on_way_tags(name.to_s, gtype, java.util.HashMap.new(options))
        end
      end
      def list
        @layer.layer_names
      end
    end
    class OSMImporter
      include Listener
      include Database
      def initialize(options={})
        database(options)
      end
      def import(osm_path,layer_name=nil)
        @osm_path = osm_path
        layer_name ||= osm_path.split(/[\\\/]+/)[-1]
        puts "\n=== Loading layer #{layer_name} from #{osm_path} ==="
        @importer = org.neo4j.gis.spatial.osm.OSMImporter.new(layer_name)
        @importer.import_file batch_inserter, @osm_path
        @importer.re_index normal_database, @commit
      end
      def to_s
        @osm_path.to_s
      end
    end
  end
end
