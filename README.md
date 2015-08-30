Easy Hadoop Deployment
======================

Services Organization
---------------------

The HDFS-related services are ```NameNode```, ```SecondaryNameNode``` and ```DataNode```.
The YARN-related services are ```ResourceManager```, ```NodeManager``` and ```WebAppProxy```.
If MapReduce is to be used, then the MapReduce Job History Server will also be running.

You should put the following services in a **central** server:

* ```NameNode``` (running under system user ```hdfs```)
* ```ResourceManager``` (running under system user ```yarn```)
* Job History Server (running user user system ```mapred```)

You should put the following services into one or more **node** servers:

* ```DataNode``` (running under system user ```hdfs```)
* ```NodeManager``` (running under system user ```yarn```)

System Users/Groups
-------------------

Hadoop requires a number of system users to work more safely. In particular, you need three system users (```hdfs```, ```yarn``` and ```mapred```) and one system group (```hadoop```). You can setup and customize all those users/groups in a Debian-like machine using the following commands:

```shell
addgroup --system hadoop
adduser --system --no-create-home --disabled-password --disabled-login --home /opt/hadoop hdfs
adduser --system --no-create-home --disabled-password --disabled-login --home /opt/hadoop yarn
adduser --system --no-create-home --disabled-password --disabled-login --home /opt/hadoop mapred
adduser hdfs hadoop
adduser yarn hadoop
adduser mapred hadoop
```

Please note that ```/opt/hadoop``` is the directory where you decided to unpack the Hadoop binary distribution (see below). Adjust this path accordingly during installation of the Hadoop instance.

Native Libraries for Compression
--------------------------------

To make use of native system libraries for compression in Hadoop, you will require to have the following packages installed in a Debian-like machine:

```shell
apt-get install zlib1g
apt-get install libsnappy1
```

**Note:** the default Hadoop binary distribution is not compiled with support for native BZip2 compression.

Installation
------------

The steps below assume you are using the  ```root``` user. The installation will be done in the ```/opt``` system directory.

### Directory Layout for Versioning

Inside the ```/opt``` directory we will have the following directory layout:
```
/opt/apache-hadoop-VERSION
/opt/apache-hadoop -> apache-hadoop-VERSION
/opt/hadoop
```

The ```/opt/apache-hadoop-VERSION``` directory is an unpacked Hadoop binary distribution of a certain VERSION (i.e., ```2.7.1```). The ```/opt/apache-hadoop``` symlink points to the Hadoop binary distribution installation you wish to use (normally you would use the latest version). Finally, the ```/opt/hadoop``` directory contains the local instance with custom configuration and datafiles (i.e. HDFS objects). This directory only contains data and configuration files, not binaries! (see later).

This directory structure is designed to make Hadoop version upgrades much easier. See the Upgrade section for details.

### Instructions for the Designated Central Server

1. Download the latest Hadoop binary distribution from [here](http://hadoop.apache.org/releases.html).

2. We will unpack the binary distribution in the ```/opt``` system directory.
   ```shell
   tar zxvf /path/to/downloaded/hadoop-VERSION.tar.gz
   chown -R root.root hadoop-VERSION
   ```

3. Create the proposed directory layout for easy versioning:
   ```shell
   mv hadoop-VERSION apache-hadoop-VERSION
   ln -sfn apache-hadoop-VERSION apache-hadoop
   ```

4. Setup the local instance directory:
   ```shell
   git clone https://github.com/hhromic/easy-hadoop-deployment hadoop
   cd hadoop
   scripts/setup.sh
   ```

5. The ```setup.sh``` script will ask questions for customizing your Hadoop instance. It will try to do its best to guess the best values that you should use.

### Instructions for the Designated Node Servers

Once you have a working **central** Hadoop installation, all you have to do is to copy the installed directories into all your designated **node** machines. You don't need to change any configuration setting, but just launch the node-related services (see the Starting/Stopping Services section).

Before transferring the installation to the node servers, please follow with the next section (Configuration).

Configuration
-------------

[TODO]

Starting/Stopping Services
--------------------------

[TODO]

Upgrading
---------

[TODO]
