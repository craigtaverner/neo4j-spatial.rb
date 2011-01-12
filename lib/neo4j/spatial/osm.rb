require 'neo4j/spatial/listener'
require 'neo4j/spatial/database'

java_import org.neo4j.gis.spatial.Constants
java_import org.neo4j.gis.spatial.SpatialDatabaseService
java_import org.neo4j.gis.spatial.osm.OSMGeometryEncoder

module Java
  module OrgNeo4jGisSpatialOsm
    class OSMDataset
      def to_s
        layers.map{|l| l.name}.join(', ')
      end
      def way_nodes
        all_way_nodes
      end
      def ways
        #all_way_nodes.map{|w| Neo4j::Spatial::OSMWay.new w}
        Neo4j::Spatial::OSMWays.new(all_way_nodes)
      end
    end
  end
end
module Neo4j
  module Spatial
    class OSMWay
      def initialize(node)
        @node = node
      end
      def first_point
        first_point_proxy.outgoing(:NODE).first
      end
      def last_point
        last_point_proxy.outgoing(:NODE).first
      end
      def first_point_proxy
        @node.outgoing(:FIRST_NODE).first
      end
      def last_point_proxy
        @node.outgoing(:LAST_NODE).first
      end
      def points
        @node.methods.grep(/traver/).join(', ')
        first_point_proxy.outgoing(:NEXT).depth(100000).map{|n| n.outgoing(:NODE).first}
      end
      def to_s
        @node['name'] || @node.to_s
      end
    end
    class OSMWays
      attr_reader :nodes
      def initialize(nodes)
        @nodes = nodes
      end
      def each
        @nodes.each{|n| yield OSMWay.new(n)}
      end
      def first
        OSMWay.new @nodes.first
      end
      def [](index)
        index.is_a?(Range) ?
          @nodes.to_a[index].map{|n| OSMWay.new(n)} :
          OSMWay.new(@nodes.to_a[index])
      end
    end
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
      # List dynamic layers associated with this layer
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
