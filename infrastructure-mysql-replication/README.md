## MySQL Replication

### 在MySQL 8.0中开启GTID Replication

#### 基本服务器信息

Master - 192.168.0.172

Slave 1 - 192.168.0.173

Slave 2 - 192.168.0.174

#### 配置Master和Slave的my.cnf的[mysqld]

在Master和Slave中，进入MySQL Shell，都执行同样的如下配置：

* Master和各个Slave的server_id设置不同值：比如Master为1，Slave为2，3等等。
* gtid_mode的顺序是：OFF -> OFF_PERMISSIVE -> ON_PERMISSIVE -> ON，需要按顺序一步一步设置到ON，初始为OFF。

```
mysql > SET PERSIST server_id=1/2/3/...;
mysql > SET PERSIST enforce_gtid_consistency=ON;
mysql > SET PERSIST gtid_mode=OFF_PERMISSIVE；
mysql > SET PERSIST gtid_mode=ON_PERMISSIVE；
mysql > SET PERSIST gtid_mode=ON；
mysql > RESTART;
```

当重启后，可以通过如下query验证运行时配置是否生效：
```
mysql > select * from performance_schema.global_variables;
```

#### Master中添加Replication User

MySQL 8.0的default_authentication_plugin为caching_sha2_password。如果要使用mysql_native_password，则执行如下命令：

```
mysql > CREATE USER 'slave'@'%' IDENTIFIED WITH mysql_native_password BY 'slave';
mysql > GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%';
```

如果使用caching_sha2_password，则执行如下命令：

```
mysql > CREATE USER 'slave'@'%' IDENTIFIED BY 'slave' REQUIRE SSL;
mysql > GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%';
```

#### Slave通过Replication User连接到Master

MySQL 8.0的default_authentication_plugin为caching_sha2_password。如果Master的replication user使用的是mysql_native_password，则执行如下命令：

```
mysql > STOP SLAVE;
mysql > CHANGE MASTER TO MASTER_HOST='192.168.0.172', MASTER_PORT=3306, MASTER_USER='slave', MASTER_PASSWORD='slave', MASTER_AUTO_POSITION=1;
mysql > START SLAVE;
```

如果Master的replication user使用的是caching_sha2_password，则执行如下命令：

```
mysql > STOP SLAVE;
mysql > CHANGE MASTER TO MASTER_HOST='192.168.0.172', MASTER_PORT=3306, MASTER_USER='slave', MASTER_PASSWORD='slave', MASTER_AUTO_POSITION=1, MASTER_SSL=1;
mysql > START SLAVE;
```

#### 验证Replication是否成功

在Master Shell中，执行如下命令，查看Replication状态：
```
mysql > SHOW MASTER STATUS\G;
```

在Slave Shell中，执行如下命令，查看Replication状态：
```
mysql > SHOW SLAVE STATUS\G;
```

### How to Install MySQL 8.0 in Ubuntu 18.04

#### Check Ubuntu Version

```
$ lsb_release -a
```

#### Step 1: Add MySQL Apt Repository

You need to add this MySQL repository to your system’s package sources list
```
$ wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb
```

Then install the MySQL repository package using the following dpkg command.
```
$ dpkg -i mysql-apt-config_0.8.10-1_all.deb
```

#### Step 2: Install MySQL Server in Ubuntu 18.04

Download the latest package information from all configured repositories, including the recently added MySQL repository.

```
$ apt-get update --allow-unauthenticated
```

```
$ apt-get update --allow-insecure-repositories
```

Below warnings will display if insecure repositories are allowed:

> W: GPG error: http://repo.mysql.com/apt/ubuntu bionic InRelease: The following signatures were invalid: EXPKEYSIG 8C718D3B5072E1F5 MySQL Release Engineering <mysql-build@oss.oracle.com>
>
> W: The repository 'http://repo.mysql.com/apt/ubuntu bionic InRelease' is not signed.
>
> N: Data from such a repository can't be authenticated and is therefore potentially dangerous to use.
>
> N: See apt-secure(8) manpage for repository creation and user configuration details.

Install packages for the MySQL community server and client.

```
$ apt-get install mysql-server mysql-client
```

Verify MySQL version, and the sample response is "mysql  Ver 8.0.17 for Linux on x86_64 (MySQL Community Server - GPL)"

```
$ mysql --version
```

### How to Uninstall MySQL 5.7 in Ubuntu 18.04

Use apt to uninstall and remove all MySQL packages:
```
$ apt-get remove --purge mysql-server mysql-client mysql-common -y
$ apt-get autoremove -y
$ apt-get autoclean

/* Remove the configuration - It might impact the update */

$ rm -rf /var/lib/mysql
$ rm -rf /var/log/mysql
$ rm -rf /etc/mysql
```

### Reference

* https://dev.mysql.com/doc/refman/8.0/en/replication.html
* https://lefred.be/content/master-slave-replication-with-mysql-8-0-in-2-mins/
* https://docs.oracle.com/cd/E17952_01/mysql-8.0-en/caching-sha2-pluggable-authentication.html
* https://www.tecmint.com/install-mysql-8-in-ubuntu/
* https://help.cloud66.com/node/how-to-guides/databases/shells/uninstall-mysql.html
* https://www.thegeekdiary.com/mysql-8-0-persisted-variables/