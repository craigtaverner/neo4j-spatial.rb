# This file defines a mixin to be used by classes that want to act as listners implementing the org.neo4j.gis.spatial.Listener interface

module Neo4j
  module Spatial
    module Listener
      include org.neo4j.gis.spatial.Listener
      def initialize(dbpath=nil)
        @work = 100
        @worked = 0
      end
      def begin(units_of_work)
        @work = units_of_work
        @work = 100 if(@work<1)
        @worked = 0
      end
      def worked(worked_since_last_notification)
        @worked += worked_since_last_notification
        progress
      end
      def done
        @worked = @work
        progress
      end
      def progress
        puts "#{100*@worked/@work}% #{self}"
      end
    end
  end
end
