#!/usr/bin/env jruby

$: << 'lib'
$: << '../lib'

require 'rubygems'
require 'neo4j/spatial'


Neo4j::Transaction.run do
  index = org.neo4j.gis.spatial.indexprovider.LayerNodeIndex.new("layer1", Neo4j.db.graph, java.util.HashMap.new)
  batman = Neo4j::Node.new :lat=>37.88, :lon=>41.14, :name => "batman"
  index.add(batman, "dummy", "value")
  params = java.util.HashMap.new
  params[org.neo4j.gis.spatial.indexprovider.LayerNodeIndex::POINT_PARAMETER] = [37.87, 41.13].to_java :Double
  params[org.neo4j.gis.spatial.indexprovider.LayerNodeIndex::DISTANCE_IN_KM_PARAMETER] = 2.0
  hits = index.query(org.neo4j.gis.spatial.indexprovider.LayerNodeIndex::WITHIN_DISTANCE_QUERY, params)
  spatialRecord = hits.single
  node = Neo4j.db.graph.getNodeById(spatialRecord["id"])
  puts "Name: #{node["name"]}, Distance: #{spatialRecord["distanceInKm"]}"
end