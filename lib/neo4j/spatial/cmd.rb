require 'neo4j'

# Simple utility for parsing common command-line arguments specific to some command-line utilities
module Neo4j
  module Spatial
    class Cmd
      def self.args
        @args=[]
        while( arg = ARGV.shift ) do
          if arg =~ /^\-(\w+)/
            $1.split.each do |field|
              if field =~ /d/
                $delete = true
              elsif field =~ /D/
                path = ARGV.shift
                if path && path.length > 0
                  Neo4j::Config[:storage_path] = path
                else
                  puts "Invalid database location: #{path}"
                end
              elsif field =~ /x/
                $exists = true
              elsif field =~ /X/
                $exists = ARGV.shift
              elsif field =~ /E/
                $export = ARGV.shift
              elsif field =~ /M/
                $limit = Math.max(ARGV.shift.to_i, 10)
              elsif field =~ /F/
                $format = ARGV.shift
              elsif field =~ /L/
                $list = ARGV.shift
              elsif field =~ /Z/
                $zoom = ARGV.shift
              elsif field =~ /W/
                $width = ARGV.shift
              elsif field =~ /H/
                $height = ARGV.shift
              elsif field =~ /l/
                $list = 'layers'
              elsif field =~ /r/
                $delete = true
              elsif field =~ /h/
                $help = true
              else
                puts "Unrecognized argument: -#{field}"
              end
            end
          else
            @args << arg
          end
        end
        @args
      end
    end
  end
end