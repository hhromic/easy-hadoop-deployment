#!/bin/sh
# script created by Hugo Hromic
# https://github.com/hhromic

bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

. $bin/../etc/vars.sh

sudo -u $MAPRED_USER -g $HADOOP_GROUP JAVA_HOME=$JAVA_HOME \
    HADOOP_MAPRED_LOG_DIR=$MAPRED_LOG_DIR HADOOP_MAPRED_PID_DIR=$MAPRED_DATA_DIR \
    $HADOOP_INSTANCE/sbin/mr-jobhistory-daemon.sh --config $HADOOP_INSTANCE/etc/hadoop start historyserver
