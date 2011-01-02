require 'neo4j/spatial/listener'
require 'neo4j/spatial/database'
require 'tempfile'

module Neo4j
  module Spatial
    class ImageExporter
      include Database
      def initialize(options={})
        default(options)
        database(options)
        @exporter = org.neo4j.gis.spatial.geotools.data.StyledImageExporter.new(@db.graph)
        @exporter.setExportDir(options[:dir])
        @exporter.setZoom(options[:zoom])
        @exporter.setOffset((options[:offset_x] || options[:offset]).to_f, (options[:offset_y] || options[:offset]).to_f)
        @exporter.setSize(options[:width], options[:height])
      end
      def default(options)
        options[:dir] ||= "target/export"
        options[:zoom] ||= 3.0
        options[:offset] ||= 0.0
        options[:width] ||= 600
        options[:height] ||= 400
      end
      def export(layer_name,options={})
        @layer_name = layer_name
        options[:path] ||= layer_name+'.png'
        if block_given?
          puts "block is given"
        end
        if options[:sld].nil?
          puts "SLD nil"
        end
        if options[:sld].nil? && block_given?
          Tempfile.open 'neo4j-spatial-sld' do |out|
            options[:sld] = out.path
            sld = Amanzi::SLD::Document.new layer_name
            yield sld
            out.puts sld.to_xml :tab => '  '
          end
        end
        options[:sld] ||= 'neo.sld.xml'
        puts "Exporting #{layer_name} to #{options[:path]} using style #{options[:sld]}"
        @exporter.saveLayerImage(layer_name, options[:sld], options[:path])
      end
      def format
        "PNG"
      end
      def to_s
        @layer_name || format
      end
    end
  end
end
