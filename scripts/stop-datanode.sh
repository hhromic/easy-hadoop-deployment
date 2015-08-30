#!/bin/sh
# script created by Hugo Hromic
# https://github.com/hhromic

bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

. $bin/../etc/vars.sh

sudo -u $HDFS_USER -g $HADOOP_GROUP JAVA_HOME=$JAVA_HOME \
    HADOOP_LOG_DIR=$HDFS_LOG_DIR HADOOP_PID_DIR=$HDFS_DATA_DIR \
    $HADOOP_INSTANCE/sbin/hadoop-daemon.sh --config $HADOOP_INSTANCE/etc/hadoop --script hdfs stop datanode
