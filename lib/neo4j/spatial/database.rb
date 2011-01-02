# This file includes two modules for working with the database in a spatial way:
# - an extension to the Neo4j::Database module allowing re-opening the database with the BatchInserter API
# - a Neo4::Spatial::Database module to be including in classes that need access to sptail extensions on the database

module Neo4j

  # We extend the normal Neo4j::Database module with the ability to switch between normal and batch-inserter modes
  class Database
    def shutdown
      if @running
        #puts "Shutting down database"
        if @batch.nil?
          #puts "Unregistering event handler"
          @graph.unregister_transaction_event_handler(@event_handler) unless read_only?
          @event_handler.neo4j_shutdown(self)
        end
        @graph.shutdown
        @graph  = nil
        @batch  = nil
        @lucene = nil
        @spatial = nil
        @running = false
      end
    end
    def restart_batch_inserter
      shutdown
      @running = true
      @batch = org.neo4j.kernel.impl.batchinsert.BatchInserterImpl.new(Config[:storage_path])
      @graph = @batch.graph_db_service
      @batch
    end
    def restart_normal_database
      shutdown
      start
    end
    def is_batch?
      @batch
    end
    def spatial
      @spatial ||= org.neo4j.gis.spatial.SpatialDatabaseService.new(@graph)
    end
  end

  module Spatial

    # This module is to be included in classes that wish to have instance level access to the database and spatial database extensions
    module Database
      def database(options={})
        options[:dbpath] ||= Neo4j::Config[:storage_path]
        if Neo4j.running? && Neo4j::Config[:storage_path] != options[:dbpath]
          raise "Database already running at different location: #{Neo4j::Config[:storage_path]} != #{options[:dbpath]}"
        end
        Neo4j::Config[:storage_path] = options[:dbpath]
        @commit = options[:commit] || 1000
        normal_database
      end
      def spatial
        @spatial ||= @db.spatial
      end
      def list_all
        spatial.layer_names
      end
      def batch_inserter
        unless @bi
          puts "Getting batch inserter database API access"
          @spatial = nil
          @bi = @db.restart_batch_inserter
        end
        @bi
      end
      def normal_database
        if @db && @db.is_batch?
          puts "Switch off BatchInserter access"
          @db.restart_normal_database
          @spatial = nil
          @bi = nil
        end
        @db ||= Neo4j.started_db
        @db.graph
      end
    end

  end

end
