#!/bin/sh
# script created by Hugo Hromic
# https://github.com/hhromic

# setup JAVA_HOME
JAVA_HOME=$(readlink -f `which javac` | sed "s:/bin/javac::")
JAVA_HOME=${JAVA_HOME%-*}
read -p "Local JVM installation [$JAVA_HOME]: " NEW_JAVA_HOME
if [ ! -z "$NEW_JAVA_HOME" ]; then
    JAVA_HOME=$NEW_JAVA_HOME
fi

# show this hadoop instance path
HADOOP_PREFIX=`pwd`
echo "Hadoop instance: $HADOOP_PREFIX"

# setup system user for HDFS
HDFS_USER=hdfs
read -p "HDFS system user [$HDFS_USER]: " NEW_HDFS_USER
if [ ! -z "$NEW_HDFS_USER" ]; then
    HDFS_USER=$NEW_HDFS_USER
fi

# setup system user for YARN
YARN_USER=yarn
read -p "YARN system user [$YARN_USER]: " NEW_YARN_USER
if [ ! -z "$NEW_YARN_USER" ]; then
    YARN_USER=$NEW_YARN_USER
fi

# setup system user for MapReduce
MAPRED_USER=mapred
read -p "MapReduce system user [$MAPRED_USER]: " NEW_MAPRED_USER
if [ ! -z "$NEW_MAPRED_USER" ]; then
    MAPRED_USER=$NEW_MAPRED_USER
fi

# setup system group for Hadoop
HADOOP_GROUP=hadoop
read -p "Hadoop system group [$HADOOP_GROUP]: " NEW_HADOOP_GROUP
if [ ! -z "$NEW_HADOOP_GROUP" ]; then
    HADOOP_GROUP=$NEW_HADOOP_GROUP
fi

# create symlinks to the Hadoop binary distribution
HADOOP_BINARY_DIST=../apache-hadoop
echo "Hadoop binary distribution: $HADOOP_BINARY_DIST"
for dir in bin include lib libexec sbin share; do
    ln -sfn $HADOOP_BINARY_DIST/$dir .
done

# copy starting configuration from the Hadoop binary distribution
cp -r ../apache-hadoop/etc .

# create a 'vars.sh' configuration file
cat <<EOF > etc/vars.sh
# set this to your local JVM installation
JAVA_HOME=$JAVA_HOME

# set this to where you unpacked Hadoop
HADOOP_PREFIX=$HADOOP_PREFIX

# system users and group
HDFS_USER=$HDFS_USER
YARN_USER=$YARN_USER
MAPRED_USER=$MAPRED_USER
HADOOP_GROUP=$HADOOP_GROUP

# log and pid directories
HDFS_LOG_DIR=\$HADOOP_PREFIX/logs/\$HDFS_USER
HDFS_PID_DIR=\$HADOOP_PREFIX/data/\$HDFS_USER
YARN_LOG_DIR=\$HADOOP_PREFIX/logs/\$YARN_USER
YARN_PID_DIR=\$HADOOP_PREFIX/data/\$YARN_USER
MAPRED_LOG_DIR=\$HADOOP_PREFIX/logs/\$MAPRED_USER
MAPRED_PID_DIR=\$HADOOP_PREFIX/data/\$MAPRED_USER
EOF

# create log and pid directories
. etc/vars.sh
install -o $HDFS_USER -d $HDFS_PID_DIR
install -o $YARN_USER -d $YARN_PID_DIR
install -o $MAPRED_USER -d $MAPRED_PID_DIR
install -o $HDFS_USER -d $HDFS_LOG_DIR
install -o $YARN_USER -d $YARN_LOG_DIR
install -o $MAPRED_USER -d $MAPRED_LOG_DIR
