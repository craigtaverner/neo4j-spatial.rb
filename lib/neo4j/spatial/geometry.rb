java_import org.neo4j.gis.spatial.Constants

module Neo4j
  module Spatial
    class Geometry
      attr_reader :gtype, :geometry
      def initialize(options={})
        @gtype = (options.delete(:gtype) || options.delete('gtype') || Constants.GTYPE_GEOMETRY).to_i
        @geometry = (options.delete(:geometry) || options.delete('geometry') || options.delete(:default) || 'geometry').to_s.downcase
        if @gtype != Geometry.string_to_id(@geometry)
          if @gtype == 0
            @gtype = Geometry.string_to_id(geometry)
            #puts "Corrected gtype to #{gtype} for geometry #{geometry}"
          elsif @geometry == 'geometry'
            @geometry = Geometry.id_to_string(@gtype)
            #puts "Corrected geometry to #{geometry} for gtype #{gtype}"
          end
        end
        puts "Initialized Geometry with gtype=#{gtype}, geometry=#{geometry}"
      end
      def to_s
        geometry
      end
      # Forward map from string name to integer id
      def self.name_map
        @name_map ||= Hash[Constants.constants.grep(/GTYPE_/).map{|v| [v.downcase.gsub(/gtype_/,''),Constants.const_get(v)]}]
      end
      # Reverse map from integer id to string name
      def self.id_map
        @id_map ||= name_map.to_a.inject({}){|a,v| a[v[1]]=v[0];a}
      end
      def self.string_to_id(name)
        name_map[name].to_i
      end
      def self.id_to_string(gtype)
        id_map[gtype] || 'geometry'
      end
    end
  end
end
