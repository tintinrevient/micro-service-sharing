# Hadoop

## Hadoop architecture

<p float="left">
	<img src="./pix/hadoop-architecture.png" width="700" />
</p>

## HDFS architecture

<p float="left">
	<img src="./pix/hdfs-architecture.png" width="700" />
</p>

## MapReduce architecture

<p float="left">
	<img src="./pix/map-reduce-architecture.png" width="700" />
</p>

## MapReduce shuffle and sort

<p float="left">
	<img src="./pix/map-reduce-shuffle-and-sort.png" width="700" />
</p>

## Installation

### Java

Java must be installed and $JAVA_HOME environment variable should be set.
```bash
$ java -version
$ echo $JAVA_HOME
```

### SSH

SSH should be enabled and SSH keys should be set up to manage remote Hadoop daemons.
```bash
$ sudo systemsetup -getremotelogin
$ sudo systemsetup -setremotelogin on

$ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
$ chmod 0600 ~/.ssh/authorized_keys
```

## References
* https://bigtop.apache.org/index.html
