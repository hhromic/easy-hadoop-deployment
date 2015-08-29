#!/bin/sh
# script created by Hugo Hromic
# https://github.com/hhromic

bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

. $bin/../etc/vars.sh

sudo -u $YARN_USER -g $HADOOP_GROUP JAVA_HOME=$JAVA_HOME \
    YARN_LOG_DIR=$YARN_LOG_DIR YARN_PID_DIR=$YARN_PID_DIR \
    $HADOOP_PREFIX/sbin/yarn-daemon.sh --config $HADOOP_PREFIX/etc/hadoop start nodemanager
