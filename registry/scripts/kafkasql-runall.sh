#!/bin/sh
pushd .
rm -rf /tmp/kafka /tmp/kafka-logs /tmp/zookeeper
mkdir /tmp/kafka
cd /tmp/kafka
wget http://mirror.cc.columbia.edu/pub/software/apache/kafka/2.3.1/kafka_2.12-2.3.1.tgz
tar xvfz kafka_2.12-2.3.1.tgz
cd kafka_2.12-2.3.1
export KAFKA_HOME=`pwd`
./bin/zookeeper-server-start.sh config/zookeeper.properties &
sleep 2
./bin/kafka-server-start.sh config/server.properties &
sleep 5
./bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic storage-topic
./bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic global-id-topic
echo ""
echo ""
echo "--------------------------------"
echo "Kafka Topics"
./bin/kafka-topics.sh --list --bootstrap-server localhost:9092
echo "--------------------------------"
echo ""
sleep 2
popd

docker pull apicurio/apicurio-registry-kafkasql:latest-snapshot

docker run -it --network="host" -p 8080:8080 -p 8443:8443 -e "KAFKA_BOOTSTRAP_SERVERS=127.0.0.1:9092" apicurio/apicurio-registry-kafkasql:latest-snapshot
