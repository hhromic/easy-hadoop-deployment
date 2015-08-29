#!/bin/sh
# script created by Hugo Hromic
# https://github.com/hhromic

bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

. $bin/../etc/vars.sh

exec=`basename $0`

JAVA_HOME=$JAVA_HOME HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar \
    $HADOOP_PREFIX/bin/$exec --config $HADOOP_PREFIX/etc/hadoop $@
