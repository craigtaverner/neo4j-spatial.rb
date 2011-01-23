require 'neo4j/spatial/database'

java_import org.neo4j.gis.spatial.Constants
java_import org.neo4j.gis.spatial.SpatialDatabaseService

module Neo4j
  module Spatial
    
    # This class wraps the spatial database layer class and provides some utilities for
    # wrapping some layer actions normally taken by the SpatialDatabaseService, liking finding layers 
    class Layer
      TYPES = [:unknown, :point, :linestring, :polygon, :multipoint, :multilinestring, :multipolygon]
      include Database
      attr_reader :layer_name, :layer
      def initialize(layer_name,options={})
        database(options)
        @layer_name = layer_name
        @layer = spatial.getLayer(@layer_name)
        unless @layer
          if options[:encoder] && options[:type]
            @layer = spatial.getOrCreateLayer(@layer_name, options[:encoder], options[:type])
          elsif options[:x] && options[:y]
            @layer = spatial.getOrCreatePointLayer(@layer_name, options[:x].to_s, options[:y].to_s)
          else
            @layer = spatial.getOrCreateDefaultLayer(@layer_name)
          end
        end
      end
      def respond_to?(symbol)
        symbol == :empty? || @layer.respond_to?(symbol)
      end
      def method_missing(symbol,*args,&block)
        @layer.send symbol, *args, &block
      end
      def empty?
        @layer.index.is_empty
      end
      def to_s
        @layer.name
      end
      def describe
        %Q{#{@layer.name} (#{type_name}:#{geometry}#{parent ? " from #{parent.name}" : ''})}
      end
      def geometry
        Geometry.id_to_string(@layer.geometry_type)
      end
      def parent
        @parent ||= @layer.respond_to?('parent') ? @layer.parent : nil
      end
      def type_name
        @layer.class.to_s.downcase.gsub(/.*[\.\:](\w+)layer.*/){|m| $1}
      end
      def self.names
        Neo4j.started_db.spatial.layer_names
      end
      def self.list
        Neo4j.started_db.spatial.layer_names.map do |name|
          Layer.new(name)
        end
      end
      def self.exist? name
        self.names.grep(name).length > 0
      end
      def self.find name
        exist?(name) && Layer.new(name)
      end
    end
  end
end
