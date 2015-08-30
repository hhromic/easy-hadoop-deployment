#!/bin/sh
# script created by Hugo Hromic
# https://github.com/hhromic

#===============================================================
# setup JAVA_HOME
JAVA_HOME=$(readlink -f `which javac` | sed "s:/bin/javac::")
JAVA_HOME=${JAVA_HOME%-*}
read -p "Local JVM installation [$JAVA_HOME]: " NEW_JAVA_HOME
if [ ! -z "$NEW_JAVA_HOME" ]; then
    JAVA_HOME=$NEW_JAVA_HOME
fi

# show this hadoop instance path
HADOOP_INSTANCE=`pwd`
echo "Hadoop instance: $HADOOP_INSTANCE"

#===============================================================
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

#===============================================================
# setup central server address
CS_ADDRESS=`hostname`
read -p "Central server address [$CS_ADDRESS]: " NEW_CS_ADDRESS
if [ ! -z "$NEW_CS_ADDRESS" ]; then
    CS_ADDRESS=$NEW_CS_ADDRESS
fi

#===============================================================
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

# set this to where you have your local Hadoop instance
HADOOP_INSTANCE=$HADOOP_INSTANCE

# system users and group
HDFS_USER=$HDFS_USER
YARN_USER=$YARN_USER
MAPRED_USER=$MAPRED_USER
HADOOP_GROUP=$HADOOP_GROUP

# log and pid directories
HDFS_LOG_DIR=\$HADOOP_INSTANCE/logs/\$HDFS_USER
HDFS_DATA_DIR=\$HADOOP_INSTANCE/data/\$HDFS_USER
YARN_LOG_DIR=\$HADOOP_INSTANCE/logs/\$YARN_USER
YARN_DATA_DIR=\$HADOOP_INSTANCE/data/\$YARN_USER
MAPRED_LOG_DIR=\$HADOOP_INSTANCE/logs/\$MAPRED_USER
MAPRED_DATA_DIR=\$HADOOP_INSTANCE/data/\$MAPRED_USER
EOF

# create log and data directories
. etc/vars.sh
install -o $HDFS_USER -d $HDFS_LOG_DIR
install -o $HDFS_USER -d $HDFS_DATA_DIR
install -o $YARN_USER -d $YARN_LOG_DIR
install -o $YARN_USER -d $YARN_DATA_DIR
install -o $MAPRED_USER -d $MAPRED_LOG_DIR
install -o $MAPRED_USER -d $MAPRED_DATA_DIR

# setup the 'core-site.xml' configuration file
PROPERTIES=$(cat <<EOF | sed -e 's/  /\\ \\ /g' -e ':a;N;$!ba;s/\n/\\n/g'
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://$CS_ADDRESS</value>
  </property>
EOF
)
sed -i -e "/<configuration>/a $PROPERTIES" etc/hadoop/core-site.xml

# setup the 'hdfs-site.xml' configuration file
PROPERTIES=$(cat <<EOF | sed -e 's/  /\\ \\ /g' -e ':a;N;$!ba;s/\n/\\n/g'
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file://$HDFS_DATA_DIR/name</value>
  </property>
  <property>
    <name>dfs.namenode.checkpoint.dir</name>
    <value>file://$HDFS_DATA_DIR/namesecondary</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file://$HDFS_DATA_DIR/data</value>
  </property>
  <property>
    <name>dfs.namenode.rpc-bind-host</name>
    <value>0.0.0.0</value>
  </property>
  <property>
    <name>dfs.permissions.superusergroup</name>
    <value>$HADOOP_GROUP</value>
  </property>
EOF
)
sed -i -e "/<configuration>/a $PROPERTIES" etc/hadoop/hdfs-site.xml

# setup the 'yarn-site.xml' configuration file
PROPERTIES=$(cat <<EOF | sed -e 's/  /\\ \\ /g' -e ':a;N;$!ba;s/\n/\\n/g'
  <property>
    <name>yarn.resourcemanager.bind-host</name>
    <value>0.0.0.0</value>
  </property>
  <property>
    <name>yarn.resourcemanager.address</name>
    <value>$CS_ADDRESS:8032</value>
  </property>
  <property>
    <name>yarn.resourcemanager.scheduler.address</name>
    <value>$CS_ADDRESS:8030</value>
  </property>
  <property>
    <name>yarn.resourcemanager.resource-tracker.address</name>
    <value>$CS_ADDRESS:8031</value>
  </property>
  <property>
    <name>yarn.resourcemanager.admin.address</name>
    <value>$CS_ADDRESS:8033</value>
  </property>
  <property>
    <name>yarn.nodemanager.local-dirs</name>
    <value>$YARN_DATA_DIR/nm-local-dir</value>
  </property>
EOF
)
sed -i -e "/<configuration>/a $PROPERTIES" etc/hadoop/yarn-site.xml
