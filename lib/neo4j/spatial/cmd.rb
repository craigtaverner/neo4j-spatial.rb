require 'neo4j'

# Simple utility for parsing common command-line arguments specific to some command-line utilities
module Neo4j
  module Spatial
    class Cmd
      def self.args
        @args=[]
        while( arg = ARGV.shift ) do
          if arg =~ /\-d/
            $delete = true
          elsif arg =~ /\-D/
            path = ARGV.shift
            if path && path.length > 0
              Neo4j::Config[:storage_path] = path
            else
              puts "Invalid database location: #{path}"
            end
          elsif arg =~ /\-E/
            $export = ARGV.shift
          elsif arg =~ /\-F/
            $format = ARGV.shift
          elsif arg =~ /\-L/
            $list = ARGV.shift
          elsif arg =~ /\-l/
            $list = 'layers'
          elsif arg =~ /\-h/
            $help = true
          else
            @args << arg
          end
        end
        @args
      end
    end
  end
end