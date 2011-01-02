include Java

# Some paths useful in development environment
$LOAD_PATH << '../amanzi-sld/lib'
$LOAD_PATH << '../../amanzi-sld/lib'
$CLASSPATH << '../neo4j-spatial/target/classes'
$CLASSPATH << '../../neo4j-spatial/target/classes'

require 'neo4j'
begin
  require 'amanzi/sld'
rescue
end

require 'neo4j/spatial/jars/neo4j-spatial-0.3-SNAPSHOT.jar'
require 'neo4j/spatial/jars/json-simple-1.1.jar'
require 'neo4j/spatial/jars/log4j-1.2.14.jar'

# Geotools main API and Geometry support
require 'neo4j/spatial/jars/gt-main/xercesImpl-2.4.0.jar'
require 'neo4j/spatial/jars/gt-main/gt-api-2.7-M3.jar'
require 'neo4j/spatial/jars/gt-main/jdom-1.0.jar'
require 'neo4j/spatial/jars/gt-main/jts-1.11.jar'
require 'neo4j/spatial/jars/gt-main/gt-main-2.7-M3.jar'

# Geotools support for rendering, used in examples for writing maps to PNG
require 'neo4j/spatial/jars/gt-render/jai_codec-1.1.3.jar'
require 'neo4j/spatial/jars/gt-render/imageio-ext-tiff-1.0.7.jar'
require 'neo4j/spatial/jars/gt-render/gt-render-2.7-M3.jar'
require 'neo4j/spatial/jars/gt-render/gt-coverage-2.7-M3.jar'
require 'neo4j/spatial/jars/gt-render/gt-cql-2.7-M3.jar'
require 'neo4j/spatial/jars/gt-render/imageio-ext-utilities-1.0.7.jar'
require 'neo4j/spatial/jars/gt-render/jai_core-1.1.3.jar'
require 'neo4j/spatial/jars/gt-render/jai_imageio-1.1.jar'

# Geotools Shapefile support for some utilties for reading/writing shapefiles
require 'neo4j/spatial/jars/gt-shapefile/jsr-275-1.0-beta-2.jar'
require 'neo4j/spatial/jars/gt-shapefile/geoapi-2.3-M1.jar'
require 'neo4j/spatial/jars/gt-shapefile/gt-data-2.7-M3.jar'
require 'neo4j/spatial/jars/gt-shapefile/vecmath-1.3.2.jar'
require 'neo4j/spatial/jars/gt-shapefile/gt-shapefile-2.7-M3.jar'
require 'neo4j/spatial/jars/gt-shapefile/commons-pool-1.5.4.jar'
require 'neo4j/spatial/jars/gt-shapefile/gt-metadata-2.7-M3.jar'
require 'neo4j/spatial/jars/gt-shapefile/gt-referencing-2.7-M3.jar'
require 'neo4j/spatial/jars/gt-shapefile/geoapi-pending-2.3-M1.jar'

# Some other possibile dependencies found in the java project
#require 'neo4j/spatial/jars/not-needed/commons-logging-1.1.1.jar'
#require 'neo4j/spatial/jars/not-needed/junit-4.4.jar'
#require 'neo4j/spatial/jars/not-needed/xml-apis-1.0.b2.jar'

require 'neo4j/spatial/database.rb'
require 'neo4j/spatial/layer.rb'
require 'neo4j/spatial/shapefile.rb'
require 'neo4j/spatial/osm.rb'
require 'neo4j/spatial/image.rb'
