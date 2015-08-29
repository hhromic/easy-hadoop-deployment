#!/bin/sh
# script created by Hugo Hromic
# https://github.com/hhromic

bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

. $bin/../etc/vars.sh

sudo -u $HDFS_USER -g $HADOOP_GROUP $bin/../wrappers/hdfs namenode -format hadoop
