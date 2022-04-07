NUTCH_HOME="binaries/apache-nutch-1.18/runtime/local"

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

$NUTCH_HOME/bin/nutch invertlinks $NUTCH_HOME/crawl/linkdb -dir $NUTCH_HOME/crawl/segments
$NUTCH_HOME/bin/nutch index $NUTCH_HOME/crawl/crawldb/ -linkdb $NUTCH_HOME/crawl/linkdb/ $s3 -filter -normalize