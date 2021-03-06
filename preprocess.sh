GRAPH=$1
ALLQUERY=$2
TOPQUERY=$3

./preprocess/reindex $GRAPH

./neo4j stop
rm ../data/databases/graph.db -r
./neo4j-import --into ../data/databases/graph.db --nodes node.csv --relationships edge.csv

bash start-neo4j.sh

# create index on id
./neo4j-shell -c "CREATE INDEX ON :Vertex(id);"

size=`grep -vc '^$' node.csv`
bash generate-queries.sh $ALLQUERY $TOPQUERY $size $GRAPH-$TOPQUERY.sh

./neo4j stop
