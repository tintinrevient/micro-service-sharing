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

MySQL 8.0的default_authentication_plugin为caching_sha2_password，而MySQL 5.7的default_authentication_plugin为mysql_native_password。

caching_sha2_password的身份验证有两种方式：
1. SSL - Connections over secure transport
2. RSA private and public key-pair - Unencrypted connections

如果使用SSL，则执行如下命令：

```
mysql > CREATE USER 'slave'@'%' IDENTIFIED BY 'slave' REQUIRE SSL;
mysql > GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%';
```

#### Slave通过Replication User连接到Master

当Master的replication user使用的是caching_sha2_password的SSL，Slave连接到Master，则执行如下命令：

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

### Reference

* https://dev.mysql.com/doc/refman/8.0/en/replication.html
* https://lefred.be/content/master-slave-replication-with-mysql-8-0-in-2-mins/
* https://docs.oracle.com/cd/E17952_01/mysql-8.0-en/caching-sha2-pluggable-authentication.html
* https://www.thegeekdiary.com/mysql-8-0-persisted-variables/
* https://dev.mysql.com/doc/refman/8.0/en/replication.html
* https://dev.mysql.com/doc/refman/8.0/en/replication-solutions.html
* https://dev.mysql.com/doc/refman/8.0/en/replication-implementation.html