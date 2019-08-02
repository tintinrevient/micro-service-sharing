## MySQL Shell的有用命令

### 查看Binary Log

查看所有的binary logs：
```
mysql > SHOW BINARY LOGS;
```

以下是具体结果：
```
+---------------+-----------+-----------+
| Log_name      | File_size | Encrypted |
+---------------+-----------+-----------+
| binlog.000001 |       473 | No        |
| binlog.000002 |       908 | No        |
| binlog.000003 |       170 | No        |
| binlog.000004 |     52243 | No        |
+---------------+-----------+-----------+
4 rows in set (0.05 sec)
```

查看binanry log中的events：
```
mysql > SHOW BINLOG EVENTS;
```

以下是具体结果：
```
+---------------+-----+----------------+-----------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| Log_name      | Pos | Event_type     | Server_id | End_log_pos | Info                                                                                                                                          |
+---------------+-----+----------------+-----------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| binlog.000001 |   4 | Format_desc    |         1 |         124 | Server ver: 8.0.17, Binlog ver: 4                                                                                                             |
| binlog.000001 | 124 | Previous_gtids |         1 |         155 |                                                                                                                                               |
| binlog.000001 | 155 | Anonymous_Gtid |         1 |         234 | SET @@SESSION.GTID_NEXT= 'ANONYMOUS'                                                                                                          |
| binlog.000001 | 234 | Query          |         1 |         450 | use `mysql`; ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' AS '*81F5E21E35407D884A6CD4A731AEBFB6AF209E1B' /* xid=3 */ |
| binlog.000001 | 450 | Stop           |         1 |         473 |                                                                                                                                               |
+---------------+-----+----------------+-----------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
5 rows in set (0.00 sec)
```

### 查看数据库引擎

查看此数据库的引擎，用如下命令：
```
mysql > SHOW ENGINES;
```

以下是具体结果：
```
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
| InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
| MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
| CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
| ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
9 rows in set (0.00 sec)
```

查看具体引擎的情况：
```
mysql > SHOW ENGINE INNODB STATUS;
```

以下是具体结果：
```
| InnoDB |      | 
=====================================
2019-07-31 06:36:03 0x7fb858690700 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 37 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 79 srv_active, 0 srv_shutdown, 433571 srv_idle
srv_master_thread log flush and writes: 0
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 375
OS WAIT ARRAY INFO: signal count 235
RW-shared spins 1, rounds 2, OS waits 1
RW-excl spins 7, rounds 212, OS waits 6
RW-sx spins 0, rounds 0, OS waits 0
Spin rounds per wait: 2.00 RW-shared, 30.29 RW-excl, 0.00 RW-sx
------------
TRANSACTIONS
------------
Trx id counter 3205
Purge done for trx's n:o < 3204 undo n:o < 0 state: running but idle
History list length 30
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 421907068951120, not started
0 lock struct(s), heap size 1136, 0 row lock(s)
---TRANSACTION 421907068954576, not started
0 lock struct(s), heap size 1136, 0 row lock(s)
---TRANSACTION 421907068953712, not started
0 lock struct(s), heap size 1136, 0 row lock(s)
---TRANSACTION 421907068952848, not started
0 lock struct(s), heap size 1136, 0 row lock(s)
---TRANSACTION 421907068950256, not started
0 lock struct(s), heap size 1136, 0 row lock(s)
--------
FILE I/O
--------
I/O thread 0 state: waiting for completed aio requests (insert buffer thread)
I/O thread 1 state: waiting for completed aio requests (log thread)
I/O thread 2 state: waiting for completed aio requests (read thread)
I/O thread 3 state: waiting for completed aio requests (read thread)
I/O thread 4 state: waiting for completed aio requests (read thread)
I/O thread 5 state: waiting for completed aio requests (read thread)
I/O thread 6 state: waiting for completed aio requests (write thread)
I/O thread 7 state: waiting for completed aio requests (write thread)
I/O thread 8 state: waiting for completed aio requests (write thread)
I/O thread 9 state: waiting for completed aio requests (write thread)
Pending normal aio reads: [0, 0, 0, 0] , aio writes: [0, 0, 0, 0] ,
 ibuf aio reads:, log i/o's:, sync i/o's:
Pending flushes (fsync) log: 0; buffer pool: 0
831 OS file reads, 3396 OS file writes, 1268 OS fsyncs
0.00 reads/s, 0 avg bytes/read, 0.00 writes/s, 0.00 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 0, seg size 2, 0 merges
merged operations:
 insert 0, delete mark 0, delete 0
discarded operations:
 insert 0, delete mark 0, delete 0
Hash table size 34679, node heap has 0 buffer(s)
Hash table size 34679, node heap has 1 buffer(s)
Hash table size 34679, node heap has 0 buffer(s)
Hash table size 34679, node heap has 0 buffer(s)
Hash table size 34679, node heap has 0 buffer(s)
Hash table size 34679, node heap has 0 buffer(s)
Hash table size 34679, node heap has 2 buffer(s)
Hash table size 34679, node heap has 4 buffer(s)
0.00 hash searches/s, 0.00 non-hash searches/s
---
LOG
---
Log sequence number          20584574
Log buffer assigned up to    20584574
Log buffer completed up to   20584574
Log written up to            20584574
Log flushed up to            20584574
Added dirty pages up to      20584574
Pages flushed up to          20584574
Last checkpoint at           20584574
1330 log i/o's done, 0.00 log i/o's/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total large memory allocated 137363456
Dictionary memory allocated 483822
Buffer pool size   8192
Free buffers       7038
Database pages     1147
Old database pages 403
Modified db pages  0
Pending reads      0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 1009, not young 113
0.00 youngs/s, 0.00 non-youngs/s
Pages read 808, created 345, written 1814
0.00 reads/s, 0.00 creates/s, 0.00 writes/s
No buffer pool page gets since the last printout
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 1147, unzip_LRU len: 0
I/O sum[0]:cur[0], unzip sum[0]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
0 read views open inside InnoDB
Process ID=20440, Main thread ID=140431583274752 , state=sleeping
Number of rows inserted 710, updated 735, deleted 142, read 748530
0.00 inserts/s, 0.00 updates/s, 0.00 deletes/s, 0.00 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================
```



### 查看table lock contention

执行如下命令：
```
mysql > SHOW STATUS LIKE 'Table%';
```

以下是具体结果：
```
+----------------------------+--------+
| Variable_name              | Value  |
+----------------------------+--------+
| Table_locks_immediate      | 185659 |
| Table_locks_waited         | 0      |
| Table_open_cache_hits      | 0      |
| Table_open_cache_misses    | 0      |
| Table_open_cache_overflows | 0      |
+----------------------------+--------+
5 rows in set (0.01 sec)
```

### 查看Table使用的Storage Engine

执行如下命令：
```
mysql > SHOW TABLE STATUS WHERE Name = 'table-name';
```

以下是具体结果：
```
+------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| Name | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time | Check_time | Collation          | Checksum | Create_options | Comment |
+------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| test | InnoDB |      10 | Dynamic    |    0 |              0 |       16384 |               0 |            0 |         0 |           NULL | 2019-07-31 09:35:35 | NULL        | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)
```

### 查看table的schema

执行如下命令：
```
mysql > DESCRIBE table-name; 
```

以下是具体结果：
```
+--------------------------+--------------+------+-----+---------------------+-----------------------------+
| Field                    | Type         | Null | Key | Default             | Extra                       |
+--------------------------+--------------+------+-----+---------------------+-----------------------------+
| ID                       | varchar(255) | NO   | PRI | NULL                |                             |
| CREATE_DATE              | timestamp    | YES  |     | CURRENT_TIMESTAMP   | on update CURRENT_TIMESTAMP |
| DEL_FLAG                 | varchar(255) | YES  |     | NULL                |                             |
| UPDATE_DATE              | datetime     | YES  |     | NULL                |                             |
| ACCEPT_TIME              | timestamp    | YES  |     | 0000-00-00 00:00:00 |                             |
| ACTION_CAUSE             | text         | YES  |     | NULL                |                             |
| ADDRESS                  | varchar(255) | YES  |     | NULL                |                             |
| AGE                      | varchar(255) | YES  |     | NULL                |                             |
| BRIEFS                   | text         | YES  |     | NULL                |                             |
| CASE_ADDR                | varchar(255) | YES  |     | NULL                |                             |
| CASE_DOMAIN              | text         | YES  |     | NULL                |                             |
| CASE_DOMAIN_ID           | text         | YES  |     | NULL                |                             |
| CASE_SOURCE              | varchar(255) | YES  |     | NULL                |                             |
| CAUSE_ID                 | text         | YES  |     | NULL                |                             |
| CERTIFICATE_NUM          | varchar(255) | YES  |     | NULL                |                             |
| CODE                     | varchar(255) | YES  |     | NULL                |                             |
| CURRENT_NODE             | varchar(255) | YES  |     | NULL                |                             |
| ID_NO                    | varchar(255) | YES  |     | NULL                |                             |
| LITIGANT                 | varchar(255) | YES  |     | NULL                |                             |
| NAME                     | varchar(255) | YES  |     | NULL                |                             |
| PHONE_NUM                | varchar(255) | YES  |     | NULL                |                             |
| SEX                      | varchar(255) | YES  |     | NULL                |                             |
| SOURCOR                  | varchar(255) | YES  |     | NULL                |                             |
| SOURCOR_CONTACT          | varchar(255) | YES  |     | NULL                |                             |
| UNIT_NAME                | varchar(255) | YES  |     | NULL                |                             |
| X_POS                    | varchar(255) | YES  |     | NULL                |                             |
| Y_POS                    | varchar(255) | YES  |     | NULL                |                             |
| ZIP_CODE                 | varchar(255) | YES  |     | NULL                |                             |
| create_by                | varchar(255) | YES  | MUL | NULL                |                             |
| update_by                | varchar(255) | YES  | MUL | NULL                |                             |
| Litigant_id              | varchar(255) | YES  | MUL | NULL                |                             |
| PROCESS_INSTANCE_ID      | varchar(255) | YES  |     | NULL                |                             |
| CASE_NAME                | varchar(255) | YES  |     | NULL                |                             |
| INNER_NODE_ID            | varchar(255) | YES  |     | NULL                |                             |
| CASE_DOMAIN_GROUP_ID     | varchar(255) | YES  |     | NULL                |                             |
| TASK_DEF                 | varchar(255) | YES  |     | NULL                |                             |
| ACCEPT_PERSON            | varchar(255) | YES  |     | NULL                |                             |
| PLACE_ON_INFO_ID         | varchar(255) | YES  | MUL | NULL                |                             |
| CASETRANSFER_ID          | varchar(255) | YES  | MUL | NULL                |                             |
| REPORT_ID                | varchar(255) | YES  | MUL | NULL                |                             |
| CASE_SOURCE_CODE         | varchar(255) | YES  |     | NULL                |                             |
| HEARING_ID               | varchar(255) | YES  | MUL | NULL                |                             |
| BIRTHDAY                 | varchar(255) | YES  |     | NULL                |                             |
| CASE_STATUS              | varchar(255) | YES  |     | NULL                |                             |
| CASE_TYPE                | varchar(255) | YES  |     | NULL                |                             |
| COMMITTEE                | varchar(255) | YES  |     | NULL                |                             |
| COMMITTEE_NAME           | varchar(255) | YES  |     | NULL                |                             |
| COMMUNITY                | varchar(255) | YES  |     | NULL                |                             |
| COMMUNITY_NAME           | varchar(255) | YES  |     | NULL                |                             |
| HEARING_FLAG             | varchar(255) | YES  |     | NULL                |                             |
| PRESS_STATUS             | varchar(255) | YES  |     | NULL                |                             |
| UPLOAD_TASK_ID           | longtext     | YES  |     | NULL                |                             |
| PRESS_FLAG               | varchar(2)   | YES  |     | NULL                |                             |
| SUPERVISE_FLAG           | varchar(2)   | YES  |     | NULL                |                             |
| PRESS_ID                 | varchar(255) | YES  |     | NULL                |                             |
| CHECK_TASK_EXIST         | varchar(1)   | YES  |     | NULL                |                             |
| FLOW_TYEP                | varchar(255) | YES  |     | NULL                |                             |
| FILING_TIME              | datetime     | YES  |     | NULL                |                             |
| SOURCOR_ID               | varchar(255) | YES  |     | NULL                |                             |
| LAWBREAKING_CLAUSE       | longtext     | YES  |     | NULL                |                             |
| PUNISH_BASE              | longtext     | YES  |     | NULL                |                             |
| BREAK_CONTENT            | longtext     | YES  |     | NULL                |                             |
| PUNISH_CONTENT           | longtext     | YES  |     | NULL                |                             |
| COUNTRY_ID_NUM           | varchar(255) | YES  |     | NULL                |                             |
| LAW_NAME                 | varchar(255) | YES  |     | NULL                |                             |
| LEGAL_NAME               | varchar(255) | YES  |     | NULL                |                             |
| LAW_UNIT_CODE            | varchar(255) | YES  |     | NULL                |                             |
| LAW_UNIT_NAME            | varchar(255) | YES  |     | NULL                |                             |
| END_CASE_TIME            | datetime     | YES  |     | NULL                |                             |
| PUNISH_DECISION_TIME     | datetime     | YES  |     | NULL                |                             |
| PUNISH_NOTIFY_TIME       | datetime     | YES  |     | NULL                |                             |
| PUNISH_PERFORM_TIME      | datetime     | YES  |     | NULL                |                             |
| CREATE_UNIT_ID           | text         | YES  |     | NULL                |                             |
| CREATE_UNIT_NAME         | text         | YES  |     | NULL                |                             |
| WRITE_CODE               | varchar(255) | YES  |     | NULL                |                             |
| c_oversee_id             | varchar(255) | YES  |     | NULL                |                             |
| c_oversee_status         | varchar(255) | YES  |     | NULL                |                             |
| t_version                | bigint(20)   | YES  |     | NULL                |                             |
| ACTION_CASE_TYPE         | varchar(255) | YES  |     | NULL                |                             |
| ACTION_CASE_TYPE_CODE    | varchar(255) | YES  |     | NULL                |                             |
| c_belond_depart_code     | varchar(255) | YES  |     | NULL                |                             |
| c_belond_depart_id       | varchar(255) | YES  |     | NULL                |                             |
| c_belond_depart_name     | varchar(255) | YES  |     | NULL                |                             |
| c_create_unit_code       | varchar(255) | YES  |     | NULL                |                             |
| c_create_user_id         | varchar(255) | YES  |     | NULL                |                             |
| c_create_user_name       | varchar(255) | YES  |     | NULL                |                             |
| c_update_user_id         | varchar(255) | YES  |     | NULL                |                             |
| c_update_user_name       | varchar(255) | YES  |     | NULL                |                             |
| c_second_case_domain_ids | varchar(255) | YES  |     | NULL                |                             |
| c_second_domain_names    | varchar(255) | YES  |     | NULL                |                             |
| PAY_TYPE                 | varchar(1)   | YES  |     | 0                   |                             |
+--------------------------+--------------+------+-----+---------------------+-----------------------------+
91 rows in set (0.00 sec)
```

执行如下命令：
```
mysql > SHOW CREATE TABLE table-name;
```

以下是具体结果：
```
| AH_CASE_INFO | CREATE TABLE `ah_case_info` (
  `ID` varchar(255) NOT NULL,
  `CREATE_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DEL_FLAG` varchar(255) DEFAULT NULL,
  `UPDATE_DATE` datetime DEFAULT NULL,
  `ACCEPT_TIME` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `ACTION_CAUSE` text,
  `ADDRESS` varchar(255) DEFAULT NULL,
  `AGE` varchar(255) DEFAULT NULL,
  `BRIEFS` text,
  `CASE_ADDR` varchar(255) DEFAULT NULL,
  `CASE_DOMAIN` text,
  `CASE_DOMAIN_ID` text,
  `CASE_SOURCE` varchar(255) DEFAULT NULL,
  `CAUSE_ID` text,
  `CERTIFICATE_NUM` varchar(255) DEFAULT NULL,
  `CODE` varchar(255) DEFAULT NULL,
  `CURRENT_NODE` varchar(255) DEFAULT NULL,
  `ID_NO` varchar(255) DEFAULT NULL,
  `LITIGANT` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `PHONE_NUM` varchar(255) DEFAULT NULL,
  `SEX` varchar(255) DEFAULT NULL,
  `SOURCOR` varchar(255) DEFAULT NULL,
  `SOURCOR_CONTACT` varchar(255) DEFAULT NULL,
  `UNIT_NAME` varchar(255) DEFAULT NULL,
  `X_POS` varchar(255) DEFAULT NULL,
  `Y_POS` varchar(255) DEFAULT NULL,
  `ZIP_CODE` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `update_by` varchar(255) DEFAULT NULL,
  `Litigant_id` varchar(255) DEFAULT NULL,
  `PROCESS_INSTANCE_ID` varchar(255) DEFAULT NULL,
  `CASE_NAME` varchar(255) DEFAULT NULL,
  `INNER_NODE_ID` varchar(255) DEFAULT NULL,
  `CASE_DOMAIN_GROUP_ID` varchar(255) DEFAULT NULL,
  `TASK_DEF` varchar(255) DEFAULT NULL,
  `ACCEPT_PERSON` varchar(255) DEFAULT NULL,
  `PLACE_ON_INFO_ID` varchar(255) DEFAULT NULL,
  `CASETRANSFER_ID` varchar(255) DEFAULT NULL,
  `REPORT_ID` varchar(255) DEFAULT NULL,
  `CASE_SOURCE_CODE` varchar(255) DEFAULT NULL,
  `HEARING_ID` varchar(255) DEFAULT NULL,
  `BIRTHDAY` varchar(255) DEFAULT NULL,
  `CASE_STATUS` varchar(255) DEFAULT NULL,
  `CASE_TYPE` varchar(255) DEFAULT NULL,
  `COMMITTEE` varchar(255) DEFAULT NULL,
  `COMMITTEE_NAME` varchar(255) DEFAULT NULL,
  `COMMUNITY` varchar(255) DEFAULT NULL,
  `COMMUNITY_NAME` varchar(255) DEFAULT NULL,
  `HEARING_FLAG` varchar(255) DEFAULT NULL,
  `PRESS_STATUS` varchar(255) DEFAULT NULL,
  `UPLOAD_TASK_ID` longtext,
  `PRESS_FLAG` varchar(2) DEFAULT NULL,
  `SUPERVISE_FLAG` varchar(2) DEFAULT NULL,
  `PRESS_ID` varchar(255) DEFAULT NULL,
  `CHECK_TASK_EXIST` varchar(1) DEFAULT NULL,
  `FLOW_TYEP` varchar(255) DEFAULT NULL,
  `FILING_TIME` datetime DEFAULT NULL,
  `SOURCOR_ID` varchar(255) DEFAULT NULL,
  `LAWBREAKING_CLAUSE` longtext,
  `PUNISH_BASE` longtext,
  `BREAK_CONTENT` longtext,
  `PUNISH_CONTENT` longtext,
  `COUNTRY_ID_NUM` varchar(255) DEFAULT NULL,
  `LAW_NAME` varchar(255) DEFAULT NULL,
  `LEGAL_NAME` varchar(255) DEFAULT NULL,
  `LAW_UNIT_CODE` varchar(255) DEFAULT NULL,
  `LAW_UNIT_NAME` varchar(255) DEFAULT NULL,
  `END_CASE_TIME` datetime DEFAULT NULL,
  `PUNISH_DECISION_TIME` datetime DEFAULT NULL,
  `PUNISH_NOTIFY_TIME` datetime DEFAULT NULL,
  `PUNISH_PERFORM_TIME` datetime DEFAULT NULL,
  `CREATE_UNIT_ID` text,
  `CREATE_UNIT_NAME` text,
  `WRITE_CODE` varchar(255) DEFAULT NULL,
  `c_oversee_id` varchar(255) DEFAULT NULL,
  `c_oversee_status` varchar(255) DEFAULT NULL,
  `t_version` bigint(20) DEFAULT NULL,
  `ACTION_CASE_TYPE` varchar(255) DEFAULT NULL,
  `ACTION_CASE_TYPE_CODE` varchar(255) DEFAULT NULL,
  `c_belond_depart_code` varchar(255) DEFAULT NULL,
  `c_belond_depart_id` varchar(255) DEFAULT NULL,
  `c_belond_depart_name` varchar(255) DEFAULT NULL,
  `c_create_unit_code` varchar(255) DEFAULT NULL,
  `c_create_user_id` varchar(255) DEFAULT NULL,
  `c_create_user_name` varchar(255) DEFAULT NULL,
  `c_update_user_id` varchar(255) DEFAULT NULL,
  `c_update_user_name` varchar(255) DEFAULT NULL,
  `c_second_case_domain_ids` varchar(255) DEFAULT NULL,
  `c_second_domain_names` varchar(255) DEFAULT NULL,
  `PAY_TYPE` varchar(1) DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `FK_ak0qch1nav5masbs6m3sjsxxo` (`create_by`),
  KEY `FK_9s0v0uhvjg52is8mgjbi3b6oj` (`update_by`),
  KEY `FK_ljc0ikare48uip5amkkld8bxk` (`Litigant_id`),
  KEY `FK_itth6sue7484gkmis22ub8bex` (`PLACE_ON_INFO_ID`),
  KEY `FK_aowunk959hcrp99pr7kh3ubsn` (`CASETRANSFER_ID`),
  KEY `FK_a2nlvqyqvobj3bqb1wkxlx1kx` (`REPORT_ID`),
  KEY `FK_a2nlvqyqvobj3bqb1wkxlx1ls` (`ID`) USING BTREE,
  KEY `FK_qvy4srgquejy6m6dmdbju8djl` (`HEARING_ID`),
  CONSTRAINT `FK_9s0v0uhvjg52is8mgjbi3b6oj` FOREIGN KEY (`update_by`) REFERENCES `users` (`ID`),
  CONSTRAINT `FK_a2nlvqyqvobj3bqb1wkxlx1kx` FOREIGN KEY (`REPORT_ID`) REFERENCES `ie_report` (`ID`),
  CONSTRAINT `FK_ak0qch1nav5masbs6m3sjsxxo` FOREIGN KEY (`create_by`) REFERENCES `users` (`ID`),
  CONSTRAINT `FK_aowunk959hcrp99pr7kh3ubsn` FOREIGN KEY (`CASETRANSFER_ID`) REFERENCES `aw_case_transfer` (`ID`),
  CONSTRAINT `FK_itth6sue7484gkmis22ub8bex` FOREIGN KEY (`PLACE_ON_INFO_ID`) REFERENCES `aw_placed_on_info` (`ID`),
  CONSTRAINT `FK_ljc0ikare48uip5amkkld8bxk` FOREIGN KEY (`Litigant_id`) REFERENCES `ah_litigant` (`ID`),
  CONSTRAINT `FK_qvy4srgquejy6m6dmdbju8djl` FOREIGN KEY (`HEARING_ID`) REFERENCES `ah_hearing_info` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
```

### mysqldump导出数据/mysql导入数据

在MySQL 8.0上，导出MySQL 5.x的数据：
```
$ mysqldump --column-statistics=0 -u root -p -h 192.168.0.203 database-name > file-name.sql
```

在同一版本的MySQL上，导出数据：
```
$ mysqldump -u root -p -h 192.168.0.203 database-name > file-name.sql
```

在不同版本或同一版本的MySQL上，导入数据：
```
$ mysql -u root -p -h 192.168.0.172 database-name < file-name.sql
```

### MySQL对columns新建/删除索引

方式一：
```
mysql > alter table table-name add key (column-name-1), add key (column-name-2);
```

方式二：
```
mysql > create index index-name table-name(column-name);
```

删除索引：
```
mysql > alter table table-name drop index (column-name-1), drop index (column-name-2);
```