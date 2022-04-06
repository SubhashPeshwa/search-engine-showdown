#!/usr/bin/env bash

mkdir binaries
apt update
apt install wget
apt install ant

apt install default-jdk
echo "JAVA_HOME=/usr/lib/jvm/default-java" | sudo tee -a /etc/environment 

# Solr installation

cd binaries && wget https://archive.apache.org/dist/lucene/solr/8.5.1/solr-8.5.1.tgz
cd binaries && tar -xvzf solr-8.5.1.tgz
# cd binaries && solr-8.5.1/bin/solr start
SOLR_HOME = binaries/solr-8.5.1

mkdir -p $SOLR_HOME/server/solr/configsets/nutch/
cp -r $SOLR_HOME/server/solr/configsets/_default/* $SOLR_HOME/server/solr/configsets/nutch/
cp config/solr/config.xml $SOLR_HOME/server/solr/configsets/nutch/conf
rm $SOLR_HOME/server/solr/configsets/nutch/conf/managed-schema

cd $SOLR_HOME && bin/solr start
$SOLR_HOME/bin/solr create -c nutch -d $SOLR_HOME/server/solr/configsets/nutch/conf/

# Nutch installation

cd binaries && wget https://dlcdn.apache.org/nutch/1.18/apache-nutch-1.18-src.tar.gz
cd binaries && tar -xvzf apache-nutch-1.18-src.tar.gz
cd binaries/apache-nutch-1.18 && ant
NUTCH_HOME = apache-nutch-1.18/runtime/local

cd $NUTCH_HOME && bin/nutch

cp config/nutch/nutch-site.xml $NUTCH_HOME/conf
mkdir -p $NUTCH_HOME/urls
cp config/nutch/seed.txt $NUTCH_HOME/urls
cp config/nutch/regex-urlfilter.txt $NUTCH_HOME/conf

cd $NUTCH_HOME && bin/nutch inject crawl/crawldb urls
cd $NUTCH_HOME && bin/nutch generate crawl/crawldb crawl/segments
cd $NUTCH_HOME && s1=`ls -d crawl/segments/2* | tail -1`
cd $NUTCH_HOME && bin/nutch fetch $s1
cd $NUTCH_HOME && bin/nutch parse $s1
cd $NUTCH_HOME && bin/nutch updatedb crawl/crawldb $s1
