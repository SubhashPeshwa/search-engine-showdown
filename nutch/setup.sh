#!/usr/bin/env bash

# mkdir binaries
# apt update
# apt install wget
# apt install ant

# apt install default-jdk
# echo 'JAVA_HOME="/usr/lib/jvm/default-java"' | sudo tee /etc/environment 
# source /etc/environment 
# JAVA_HOME="/usr/lib/jvm/default-java"

echo "export JAVA_HOME=/usr/lib/jvm/default-java" >>~/.bashrc
echo "export PATH=$JAVA_HOME/bin:$PATH" >>~/.bashrc
source ~/.bashrc

# Solr installation

# cd binaries && wget https://archive.apache.org/dist/lucene/solr/8.5.1/solr-8.5.1.tgz
# tar -xvzf solr-8.5.1.tgz
# cd ..

SOLR_HOME="binaries/solr-8.5.1"
mkdir -p $SOLR_HOME/server/solr/configsets/nutch/
cp -r $SOLR_HOME/server/solr/configsets/_default/* $SOLR_HOME/server/solr/configsets/nutch/
cp config/solr/schema.xml $SOLR_HOME/server/solr/configsets/nutch/conf
rm $SOLR_HOME/server/solr/configsets/nutch/conf/managed-schema

$SOLR_HOME/bin/solr stop -force
$SOLR_HOME/bin/solr start -force
$SOLR_HOME/bin/solr delete -c nutch
$SOLR_HOME/bin/solr create -c nutch -d $SOLR_HOME/server/solr/configsets/nutch/conf/ -force

# Nutch installation

# cd binaries && wget https://dlcdn.apache.org/nutch/1.18/apache-nutch-1.18-src.tar.gz
# tar -xvzf apache-nutch-1.18-src.tar.gz
# cd ..
# cd binaries/apache-nutch-1.18 && ant
# cd ..
NUTCH_HOME="binaries/apache-nutch-1.18/runtime/local"

# $NUTCH_HOME/bin/nutch

# cp config/nutch/nutch-site.xml $NUTCH_HOME/conf
# mkdir -p $NUTCH_HOME/urls
# cp config/nutch/seed.txt $NUTCH_HOME/urls
# cp config/nutch/regex-urlfilter.txt $NUTCH_HOME/conf

$NUTCH_HOME/bin/nutch inject $NUTCH_HOME/crawl/crawldb $NUTCH_HOME/urls
$NUTCH_HOME/bin/nutch generate $NUTCH_HOME/crawl/crawldb $NUTCH_HOME/crawl/segments
s1=`ls -d $NUTCH_HOME/crawl/segments/2* | tail -1`
$NUTCH_HOME/bin/nutch fetch $s1
$NUTCH_HOME/bin/nutch parse $s1
$NUTCH_HOME/bin/nutch updatedb $NUTCH_HOME/crawl/crawldb $s1

$NUTCH_HOME/bin/nutch generate $NUTCH_HOME/crawl/crawldb $NUTCH_HOME/crawl/segments -topN 1000
s2=`ls -d $NUTCH_HOME/crawl/segments/2* | tail -1`
echo $s2
$NUTCH_HOME/bin/nutch fetch $s2
$NUTCH_HOME/bin/nutch parse $s2
$NUTCH_HOME/bin/nutch updatedb $NUTCH_HOME/crawl/crawldb $s2

$NUTCH_HOME/bin/nutch generate $NUTCH_HOME/crawl/crawldb $NUTCH_HOME/crawl/segments -topN 1000
s3=`ls -d $NUTCH_HOME/crawl/segments/2* | tail -1`
echo $s3
$NUTCH_HOME/bin/nutch fetch $s3
$NUTCH_HOME/bin/nutch parse $s3
$NUTCH_HOME/bin/nutch updatedb $NUTCH_HOME/crawl/crawldb $s3
