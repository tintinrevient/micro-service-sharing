## 优化Slow Query

### 产生分析报告

当执行如下命令，分析 [db-slow.log](./log/db-slow.log)
```
pt-query-digest $ ./pt-query-digest ./log/db-slow.log
```

我们会在terminal中得到一份报告，报告会包含top20的slow query分析，点此阅览：[db-slow-analysis.log](./log/db-slow-analysis.log)

下面是部分的分析报告（overview + query 1的详细分析）：

* 可以看到top20的queries中，有11个query的执行时间大于3s、直到最大的93秒。

```
# 7.2s user time, 220ms system time, 40.47M rss, 4.12G vsz
# Current date: Thu Aug  1 13:52:08 2019
# Hostname: nezumikozo.local
# Files: /Users/zhaoshu/Documents/workspace/cemis-spring-boot-service/log/db-slow.log
# Overall: 22.89k total, 882 unique, 0.05 QPS, 0.00x concurrency _________
# Time range: 2019-07-26 14:23:45 to 2019-08-01 11:15:34
# Attribute          total     min     max     avg     95%  stddev  median
# ============     ======= ======= ======= ======= ======= ======= =======
# Exec time           684s       0     94s    30ms    51ms   677ms     1ms
# Lock time             3s       0   338ms   138us     1ms     3ms       0
# Rows sent        749.67k       0  70.95k   33.53   49.17  999.28    0.99
# Rows examine      12.98M       0  70.95k  594.52  685.39   3.99k   46.83
# Query size        19.12M      20   3.71k  875.90   2.76k  786.47  793.42
 
# Profile
# Rank Query ID                     Response time  Calls R/Call  V/M   Ite
# ==== ============================ ============== ===== ======= ===== ===
#    1 0xED570351487F243AD60C0B1... 339.1505 49.6%   459  0.7389  0.68 SELECT AH_CASE_INFO AW_ENDORSE_BUSINESS USERS
#    2 0x4105234D19B8D15D6836F8A...  93.8790 13.7%     1 93.8790  0.00 SELECT t_leader_message
#    3 0x88E962FD0E55F2414C28A43...  36.1116  5.3%   456  0.0792  0.01 SELECT AH_CASE_INFO AW_ENDORSE_BUSINESS USERS
#    4 0x4670C91E56AB283CB71A149...  28.8404  4.2%     1 28.8404  0.00 SELECT gg_zft_login
#    5 0x3AA4E8775D2AF2BE434FFFC...  13.1217  1.9%     1 13.1217  0.00 SELECT app_permission_account
#    6 0x83A81E68FE6CCB29329B3D8...  11.8722  1.7%   281  0.0422  0.00 SELECT information_schema.PARTITIONS
#    7 0xF499FA76CE67ABE998FBD98...  10.8307  1.6%     1 10.8307  0.00 SELECT act_hi_actinst
#    8 0xD1A991288CE6A05F259A0AC...  10.0202  1.5%    38  0.2637  3.80 SELECT APN_NOTIFICATION
#    9 0x320D8764B22A1F3DCBD633D...   8.2190  1.2%     1  8.2190  0.00 SELECT svm_locus
#   10 0x02A599F39C3B3F3C667BCB7...   8.0901  1.2%     1  8.0901  0.00 SELECT aw_endorse_record
#   11 0x881A7A4E76B154B0EAE59B6...   7.6756  1.1%  1934  0.0040  0.00 SELECT sys_menu sys_role_menu roles user_role users
#   12 0xBDA1FDF0B76708020FA52C1...   7.6257  1.1%     1  7.6257  0.00 SELECT history_task
#   13 0x7F9EF75023A0F84FAC3F255...   7.5935  1.1%   124  0.0612  0.00 SELECT AH_CASE_INFO AW_ENDORSE_BUSINESS
#   14 0x1DED283C636909623D8BB98...   6.4964  0.9%     1  6.4964  0.00 SELECT administration_data
#   15 0xE3C753C2F267B2D767A347A...   4.2142  0.6%   240  0.0176  0.34 SELECT sys_user_menu
#   16 0x748E418E684C0F73C432849...   3.8510  0.6%     1  3.8510  0.00 SELECT act_hi_varinst
#   17 0xB08C56CFB37CCAFAD211B9D...   3.8266  0.6%    96  0.0399  0.00 SELECT APN_NOTIFICATION
#   18 0xC21C5521312DCF782EA10AB...   3.7587  0.5%   794  0.0047  0.09 SELECT APP_ROLE_RESOURCE RESOURCES APP_SYSTEM sys_menu APP_UNIT_RESOURCE RESOURCES UNIT
#   19 0x0DFB28998E3F83AA40F734A...   3.2240  0.5%     1  3.2240  0.00 SELECT act_hi_taskinst
#   20 0x4314471533FDE00A2FB695D...   3.2152  0.5%     1  3.2152  0.00 SELECT act_ru_variable
# MISC 0xMISC                        72.2880 10.6% 18459  0.0039   0.0 <862 ITEMS>
 
# Query 1: 0.00 QPS, 0.00x concurrency, ID 0xED570351487F243AD60C0B1FF34C2770 at byte 11481041
# This item is included in the report because it matches --limit.
# Scores: V/M = 0.68
# Time range: 2019-07-26 14:39:17 to 2019-08-01 11:13:15
# Attribute    pct   total     min     max     avg     95%  stddev  median
# ============ === ======= ======= ======= ======= ======= ======= =======
# Count          2     459
# Exec time     49    339s   186ms      5s   739ms      2s   707ms   640ms
# Lock time     10   347ms       0   338ms   756us       0    15ms       0
# Rows sent      0   4.04k       4      19    9.01   16.81    3.71    7.70
# Rows examine   0  20.78k      36      61   46.35   56.92    5.15   46.83
# Query size     2 570.79k   1.23k   1.25k   1.24k   1.20k       0   1.20k
# String:
# Databases    libowenv3
# Hosts        192.168.0.75
# Users        root
# Query_time distribution
#   1us
#  10us
# 100us
#   1ms
#  10ms
# 100ms  ################################################################
#    1s  ######
#  10s+
# Tables
#    SHOW TABLE STATUS FROM `libowenv3` LIKE 'AH_CASE_INFO'\G
#    SHOW CREATE TABLE `libowenv3`.`AH_CASE_INFO`\G
#    SHOW TABLE STATUS FROM `libowenv3` LIKE 'AW_ENDORSE_BUSINESS'\G
#    SHOW CREATE TABLE `libowenv3`.`AW_ENDORSE_BUSINESS`\G
#    SHOW TABLE STATUS FROM `libowenv3` LIKE 'USERS'\G
#    SHOW CREATE TABLE `libowenv3`.`USERS`\G
# EXPLAIN /*!50100 PARTITIONS*/
select distinct caseinfo0_.ID as col_0_0_, caseinfo0_.CODE as col_1_0_, caseinfo0_.CASE_SOURCE as col_2_0_, caseinfo0_.ACTION_CAUSE as col_3_0_, caseinfo0_.ACCEPT_TIME as col_4_0_, caseinfo0_.NAME as col_5_0_, caseinfo0_.CASE_DOMAIN as col_6_0_, caseinfo0_.CASE_STATUS as col_7_0_, caseinfo0_.CASE_NAME as col_8_0_, caseinfo0_.LITIGANT as col_9_0_, caseinfo0_.UNIT_NAME as col_10_0_ from AH_CASE_INFO caseinfo0_ cross join AW_ENDORSE_BUSINESS endorsebus1_ cross join USERS user2_ where 1=1 and (caseinfo0_.ID=endorsebus1_.BUSINESS_ID or caseinfo0_.INNER_NODE_ID is null) and caseinfo0_.DEL_FLAG='0' and (1=1 and (caseinfo0_.INNER_NODE_ID is null) or (endorsebus1_.NODE_CODE in ('caseAccept' , 'registerCase' , 'turnCase' , 'notRegisterCase' , 'investigation' , 'punishNotify' , 'presentArgue' , 'applyHearing' , 'approvalHearing' , 'noticeHearing' , 'holdHearing' , 'punishDecision' , 'punishPerform' , 'applyEnforce' , 'closeCase')) and (endorsebus1_.ROLE_CODE in ('ROLE_0005' , 'ROLE_0004' , 'ROLE_0002' , 'ROLE_0003' , 'ROLE_0006') or endorsebus1_.ASSIGN_USER='07991c24311f4e8b835afacd15c0e891')) and caseinfo0_.c_create_unit_code='0010002' and (caseinfo0_.c_belond_depart_code like '001000200080008%') order by caseinfo0_.UPDATE_DATE desc, caseinfo0_.CODE asc limit 2147483647\G
 
```

### Query 1的具体分析结果

当在MySQL Shell中，Explain query 1的SQL语句时：
```
mysql > EXPLAIN /*!50100 PARTITIONS*/
        select distinct caseinfo0_.ID as col_0_0_, caseinfo0_.CODE as col_1_0_, caseinfo0_.CASE_SOURCE as col_2_0_, caseinfo0_.ACTION_CAUSE as col_3_0_, caseinfo0_.ACCEPT_TIME as col_4_0_, caseinfo0_.NAME as col_5_0_, caseinfo0_.CASE_DOMAIN as col_6_0_, caseinfo0_.CASE_STATUS as col_7_0_, caseinfo0_.CASE_NAME as col_8_0_, caseinfo0_.LITIGANT as col_9_0_, caseinfo0_.UNIT_NAME as col_10_0_ from AH_CASE_INFO caseinfo0_ cross join AW_ENDORSE_BUSINESS endorsebus1_ cross join USERS user2_ where 1=1 and (caseinfo0_.ID=endorsebus1_.BUSINESS_ID or caseinfo0_.INNER_NODE_ID is null) and caseinfo0_.DEL_FLAG='0' and (1=1 and (caseinfo0_.INNER_NODE_ID is null) or (endorsebus1_.NODE_CODE in ('caseAccept' , 'registerCase' , 'turnCase' , 'notRegisterCase' , 'investigation' , 'punishNotify' , 'presentArgue' , 'applyHearing' , 'approvalHearing' , 'noticeHearing' , 'holdHearing' , 'punishDecision' , 'punishPerform' , 'applyEnforce' , 'closeCase')) and (endorsebus1_.ROLE_CODE in ('ROLE_0005' , 'ROLE_0004' , 'ROLE_0002' , 'ROLE_0003' , 'ROLE_0006') or endorsebus1_.ASSIGN_USER='07991c24311f4e8b835afacd15c0e891')) and caseinfo0_.c_create_unit_code='0010002' and (caseinfo0_.c_belond_depart_code like '001000200080008%') order by caseinfo0_.UPDATE_DATE desc, caseinfo0_.CODE asc limit 2147483647\G
```

返回的具体分析结果如下：

* 可以看到一共查了23 * 311 * 450个rows，也就是3218850个。
* 其中比较关键的指标有：type，rows。
* 可以从possible_keys中，找到可以被index的column。

```
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: user2_
   partitions: NULL
         type: index
possible_keys: NULL
          key: FK_8lb65wlp8y7p8a4m1uwy1qoxn
      key_len: 768
          ref: NULL
         rows: 23
        Extra: Using index; Using temporary; Using filesort
*************************** 2. row ***************************
           id: 1
  select_type: SIMPLE
        table: endorsebus1_
   partitions: NULL
         type: ALL
possible_keys: FK_tahx9r6lr7hf0loqjw8453pj0,FK_tahx9r6lr7hf0loqjw8453pls,FK_tahx9r6lr7hf0loqjw8453phn
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 311
        Extra: Using join buffer (Block Nested Loop)
*************************** 3. row ***************************
           id: 1
  select_type: SIMPLE
        table: caseinfo0_
   partitions: NULL
         type: ALL
possible_keys: PRIMARY,FK_a2nlvqyqvobj3bqb1wkxlx1ls
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 450
        Extra: Using where; Using join buffer (Block Nested Loop)
3 rows in set (0.09 sec)
```

### Query 1的优化方法

#### Before - Query 1的查询结果

可以看到，查询时间是7.52秒。

```
+----------------------------------+----------+--------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------+-----------+--------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+-----------+
| col_0_0_                         | col_1_0_ | col_2_0_     | col_3_0_                                                                                                                                                                                                                                                                                                                               | col_4_0_            | col_5_0_  | col_6_0_     | col_7_0_ | col_8_0_                                                                                                                                                                                                     | col_9_0_ | col_10_0_ |
+----------------------------------+----------+--------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------+-----------+--------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+-----------+
| 996718086c7945d48606bb9432d15249 |          | 视频上报     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-08-01 17:55:25 |           | 规划建设     | 01       | ApplicationFrameHost                                                                                                                                                                                         | PERSONAL | NULL      |
| 64e48a53ad0944ca8462b3cf11a1cb7d |          | 部门移交     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-08-01 17:38:23 |           | 国土资源     | 01       | 就问你香不香                                                                                                                                                                                                 | PERSONAL | NULL      |
| 2116ea69cb834a9186725c2720bd025e |          | 视频上报     | 作业区未划分洗车区和擦车区，洗车区未设置截水沟、三级沉淀池及污泥暂储设施;作业区地面、车辆进出口通道未采用混凝土硬化，作业区墙体及清水池立面未采用防渗漏材料覆盖;占用城镇道路和公共场所从事临时性机动车辆清洗保洁经营活动。                                                                                                             | 2019-07-30 16:59:56 |           | 城市管理     | 21       | 整个办案流程的样式修改的案例                                                                                                                                                                                 | PERSONAL | NULL      |
| d0edeeccef194ac1a825d9ed93b9fb5f |          | 视频上报     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-08-01 09:35:11 |           | 农业开发     | 01       | test1                                                                                                                                                                                                        | PERSONAL | NULL      |
| 5cb0adaededc42bb867cc793e0a29083 |          | 巡查发现     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-08-01 09:21:34 |           | 水务管理     | 11       | 8月第一条测试案件                                                                                                                                                                                            | PERSONAL | NULL      |
| 59ac61b725be4681aa3e9cf82f46d4df |          | 视频上报     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-29 15:59:31 |           | 城市管理     | 11       | 新的一条测试案件                                                                                                                                                                                             | PERSONAL | NULL      |
| cff8b67a994c46f0a59575dec3da14fd |          | 巡查发现     | 作业区未划分洗车区和擦车区，洗车区未设置截水沟、三级沉淀池及污泥暂储设施;在风景名胜和文物保护核心区、饮用水保护区设置清洗站                                                                                                                                                                                                            | 2019-07-30 14:05:08 | 王忘林    | 城市管理     | 44       | 王明在江河、湖泊、水库、运河、渠道内弃置、堆放阻碍行洪的物体和种植阻碍行洪的林木及高秆作物的处罚                                                                                                             | PERSONAL | NULL      |
| 9838216bc5a74ee3b78e0b0886599eba |          | 视频上报     | 作业区未划分洗车区和擦车区，洗车区未设置截水沟、三级沉淀池及污泥暂储设施;作业区地面、车辆进出口通道未采用混凝土硬化，作业区墙体及清水池立面未采用防渗漏材料覆盖;在城区主次干道两侧道路红线控制区域设置清洗站                                                                                                                           | 2019-07-30 13:52:41 | 1221      | 城市管理     | 44       | 张三跟李四跟王五一起倒垃圾导致下水管道堵塞的案件                                                                                                                                                             | PERSONAL | NULL      |
| 430b61e08f8745b584bc86cbf6f2fe9f |          | 部门移交     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-30 16:25:35 |           | 农业开发     | 01       | 农业开发                                                                                                                                                                                                     | PERSONAL | NULL      |
| 8b8b6f551c5a45dbb2646c3e0dcbd0fb |          | 举报信访     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-29 16:11:08 |           | 交通运输     | 01       | 张某某在小区后面空地违规燃放烟花爆竹导致引燃一部分垃圾污染空气的案件张某某在小区后面空地违规燃放烟花爆竹导致引燃一部分垃圾污染空气的案件                                                                     | PERSONAL | NULL      |
| 8b6462bcaba845298824896bbedff78b |          | 部门移交     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-29 16:09:53 |           | 文旅广新     | 01       | 张某某在小区后面空地违规燃放烟花爆竹导致引燃一部分垃圾污染空气的案件                                                                                                                                         | PERSONAL | NULL      |
| 8f27d8e66e464e72856c399f1da3ef10 |          | 视频上报     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-30 16:07:17 |           | 国土资源     | 01       | 测试第三条案例                                                                                                                                                                                               | PERSONAL | NULL      |
| 05580d60eb5841c09144fa12b7601997 |          | 部门移交     | 作业区未划分洗车区和擦车区，洗车区未设置截水沟、三级沉淀池及污泥暂储设施                                                                                                                                                                                                                                                               | 2019-07-26 15:10:29 |           | 城市管理     | 11       | 测试案件第二条                                                                                                                                                                                               | PERSONAL | NULL      |
| 54b06fc2e7e04f88b4c41715511ed73b |          | 举报信访     | 未按照《建筑垃圾处置（排放）证》上载明的建筑垃圾种类、数量、排放期限排放建筑垃圾                                                                                                                                                                                                                                                       | 2019-07-25 10:47:53 |           | 水务管理     | 11       | 测试案件7月                                                                                                                                                                                                  | PERSONAL | NULL      |
| 99506724750743e09216f80a5ff9ad15 |          | 举报信访     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-02-14 16:54:17 | NULL      | 城市管理     | 01       | 2                                                                                                                                                                                                            | UNIT     | 李        |
| 5e049875cdd44506a0c86812dd0c48e9 |          | 举报信访     | 作业区地面、车辆进出口通道未采用混凝土硬化，作业区墙体及清水池立面未采用防渗漏材料覆盖                                                                                                                                                                                                                                                 | 2019-02-14 09:59:44 | NULL      | 城市管理     | 21       | cheshi1                                                                                                                                                                                                      | UNIT     | 李        |
| 925a5cd7f5754fd5b53bb2dea141f9b6 |          | 举报信访     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-02-14 09:59:44 | NULL      | 城市管理     | 01       | cheshi2                                                                                                                                                                                                      | UNIT     | 李        |
| 4528fb93bd2443aa904e2b128cec95f2 |          | 视频上报     | 雇佣不符合要求的驾驶员从事建筑垃圾运输活动                                                                                                                                                                                                                                                                                             | 2018-12-12 15:13:25 |           | 城市管理     | 62       | 5                                                                                                                                                                                                            | PERSONAL | NULL      |
| ea809a9d9a324329b45b4b6d5a690a2d |          | 举报信访     | NULL                                                                                                                                                                                                                                                                                                                                   | 2018-12-12 14:11:13 |           | 城市管理     | 11       | 4                                                                                                                                                                                                            | PERSONAL | NULL      |
| eea31b22cabb4a6ba2573f78fe8b779d |          | 视频上报     | 未将建筑垃圾交由本市建筑垃圾运输企业名录中的企业运输                                                                                                                                                                                                                                                                                   | 2018-12-12 13:56:18 |           | 城市管理     | 30       | 2                                                                                                                                                                                                            | PERSONAL | NULL      |
| 82526624e8654115bf84980c20dbd700 |          | 视频上报     | 雇佣不符合要求的驾驶员从事建筑垃圾运输活动                                                                                                                                                                                                                                                                                             | 2018-12-12 11:03:03 |           | 城市管理     | 81       | 1                                                                                                                                                                                                            | PERSONAL | NULL      |
+----------------------------------+----------+--------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------+-----------+--------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+-----------+
21 rows in set (7.52 sec)
```

#### 优化AH_CASE_INFO表

在MySQL Shell里，执行如下命令：

```
mysql > ALTER TABLE AH_CASE_INFO ADD KEY (INNER_NODE_ID), ADD KEY (DEL_FLAG), ADD KEY (c_create_unit_code), ADD KEY (c_belond_depart_code), ADD KEY (UPDATE_DATE);

```

这时再分析query 1，其结果如下：

* 可以看到查询的rows从450减少到20
* type从ALL变为range。

```
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: user2_
         type: index
possible_keys: NULL
          key: FK_8lb65wlp8y7p8a4m1uwy1qoxn
      key_len: 768
          ref: NULL
         rows: 23
     filtered: 100.00
        Extra: Using index; Using temporary; Using filesort
*************************** 2. row ***************************
           id: 1
  select_type: SIMPLE
        table: endorsebus1_
         type: ALL
possible_keys: FK_tahx9r6lr7hf0loqjw8453pj0,FK_tahx9r6lr7hf0loqjw8453pls,FK_tahx9r6lr7hf0loqjw8453phn
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 311
     filtered: 100.00
        Extra: Using join buffer (Block Nested Loop)
*************************** 3. row ***************************
           id: 1
  select_type: SIMPLE
        table: caseinfo0_
         type: range
possible_keys: PRIMARY,FK_a2nlvqyqvobj3bqb1wkxlx1ls
          key: c_belond_depart_code
      key_len: 768
          ref: NULL
         rows: 20
     filtered: 100.00
        Extra: Range checked for each record (index map: 0x81)
3 rows in set, 1 warning (0.01 sec)
```

#### 优化AW_ENDORSE_BUSINESS表

在MySQL Shell里，执行如下命令：
```
mysql > ALTER TABLE AW_ENDORSE_BUSINESS ADD KEY (NODE_CODE), ADD KEY (ROLE_CODE), ADD KEY (ASSIGN_USER);

```

此时再分析query 1，发现分析结果不变，index并没有被使用。原因大概如下几项：
* WHERE语句中的column不会使用index
* IN (...) 会导致全表遍历

如下，把语句改写成：
```
select * from (select distinct caseinfo0_.ID as col_0_0_, caseinfo0_.CODE as col_1_0_, caseinfo0_.CASE_SOURCE as col_2_0_, caseinfo0_.ACTION_CAUSE as col_3_0_, caseinfo0_.ACCEPT_TIME as col_4_0_, caseinfo0_.NAME as col_5_0_, caseinfo0_.CASE_DOMAIN as col_6_0_, caseinfo0_.CASE_STATUS as col_7_0_, caseinfo0_.CASE_NAME as col_8_0_, caseinfo0_.LITIGANT as col_9_0_, caseinfo0_.UNIT_NAME as col_10_0_ ,  caseinfo0_.UPDATE_DATE as col_11_0_ from AH_CASE_INFO caseinfo0_ cross join AW_ENDORSE_BUSINESS endorsebus1_  on (caseinfo0_.ID=endorsebus1_.BUSINESS_ID or caseinfo0_.INNER_NODE_ID is null)  and caseinfo0_.DEL_FLAG='0' and (1=1 and (caseinfo0_.INNER_NODE_ID is null) or (endorsebus1_.NODE_CODE in ('caseAccept' , 'registerCase' , 'turnCase' , 'notRegisterCase' , 'investigation' , 'punishNotify' , 'presentArgue' , 'applyHearing' , 'approvalHearing' , 'noticeHearing' , 'holdHearing' , 'punishDecision' , 'punishPerform' , 'applyEnforce' , 'closeCase')) and (endorsebus1_.ROLE_CODE in ('ROLE_0005' , 'ROLE_0004' , 'ROLE_0002' , 'ROLE_0003' , 'ROLE_0006') or endorsebus1_.ASSIGN_USER='07991c24311f4e8b835afacd15c0e891') and caseinfo0_.c_create_unit_code='0010002') and (caseinfo0_.c_belond_depart_code like '001000200080008%')) infos order by col_11_0_ desc, col_1_0_ asc limit 2147483647
```

此时再分析query 1，结果如下：
* AW_ENDORSE_BUSINESS的Extra变为：Using temporary

```
*************************** 1. row ***************************
           id: 1
  select_type: PRIMARY
        table: <derived2>
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 5287
        Extra: Using filesort
*************************** 2. row ***************************
           id: 2
  select_type: DERIVED
        table: endorsebus1_
         type: ALL
possible_keys: FK_tahx9r6lr7hf0loqjw8453pj0,FK_tahx9r6lr7hf0loqjw8453pls,FK_tahx9r6lr7hf0loqjw8453phn,NODE_CODE,ROLE_CODE,ASSIGN_USER,BUSINESS_ID,idx_node_code,idx_role_code
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 311
        Extra: Using temporary
*************************** 3. row ***************************
           id: 2
  select_type: DERIVED
        table: caseinfo0_
         type: range
possible_keys: PRIMARY,FK_a2nlvqyqvobj3bqb1wkxlx1ls
          key: c_belond_depart_code
      key_len: 768
          ref: NULL
         rows: 22
        Extra: Range checked for each record (index map: 0x81)
3 rows in set (0.01 sec)
```

#### After - Query 1的查询结果

最后执行一遍如上修改过的查询语句，结果如下：
* 查询时间从7.52秒，下降到0.33秒
* 结果集保持不变

```
+----------------------------------+----------+--------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------+-----------+--------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+-----------+---------------------+
| col_0_0_                         | col_1_0_ | col_2_0_     | col_3_0_                                                                                                                                                                                                                                                                                                                               | col_4_0_            | col_5_0_  | col_6_0_     | col_7_0_ | col_8_0_                                                                                                                                                                                                     | col_9_0_ | col_10_0_ | col_11_0_           |
+----------------------------------+----------+--------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------+-----------+--------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+-----------+---------------------+
| 996718086c7945d48606bb9432d15249 |          | 视频上报     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-08-01 17:55:25 |           | 规划建设     | 01       | ApplicationFrameHost                                                                                                                                                                                         | PERSONAL | NULL      | 2019-08-01 09:55:48 |
| 64e48a53ad0944ca8462b3cf11a1cb7d |          | 部门移交     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-08-01 17:38:23 |           | 国土资源     | 01       | 就问你香不香                                                                                                                                                                                                 | PERSONAL | NULL      | 2019-08-01 09:38:55 |
| 2116ea69cb834a9186725c2720bd025e |          | 视频上报     | 作业区未划分洗车区和擦车区，洗车区未设置截水沟、三级沉淀池及污泥暂储设施;作业区地面、车辆进出口通道未采用混凝土硬化，作业区墙体及清水池立面未采用防渗漏材料覆盖;占用城镇道路和公共场所从事临时性机动车辆清洗保洁经营活动。                                                                                                             | 2019-07-30 16:59:56 |           | 城市管理     | 21       | 整个办案流程的样式修改的案例                                                                                                                                                                                 | PERSONAL | NULL      | 2019-08-01 02:14:18 |
| d0edeeccef194ac1a825d9ed93b9fb5f |          | 视频上报     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-08-01 09:35:11 |           | 农业开发     | 01       | test1                                                                                                                                                                                                        | PERSONAL | NULL      | 2019-08-01 01:35:33 |
| 5cb0adaededc42bb867cc793e0a29083 |          | 巡查发现     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-08-01 09:21:34 |           | 水务管理     | 11       | 8月第一条测试案件                                                                                                                                                                                            | PERSONAL | NULL      | 2019-08-01 01:22:05 |
| 59ac61b725be4681aa3e9cf82f46d4df |          | 视频上报     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-29 15:59:31 |           | 城市管理     | 11       | 新的一条测试案件                                                                                                                                                                                             | PERSONAL | NULL      | 2019-07-30 06:12:19 |
| cff8b67a994c46f0a59575dec3da14fd |          | 巡查发现     | 作业区未划分洗车区和擦车区，洗车区未设置截水沟、三级沉淀池及污泥暂储设施;在风景名胜和文物保护核心区、饮用水保护区设置清洗站                                                                                                                                                                                                            | 2019-07-30 14:05:08 | 王忘林    | 城市管理     | 44       | 王明在江河、湖泊、水库、运河、渠道内弃置、堆放阻碍行洪的物体和种植阻碍行洪的林木及高秆作物的处罚                                                                                                             | PERSONAL | NULL      | 2019-07-30 06:05:38 |
| 9838216bc5a74ee3b78e0b0886599eba |          | 视频上报     | 作业区未划分洗车区和擦车区，洗车区未设置截水沟、三级沉淀池及污泥暂储设施;作业区地面、车辆进出口通道未采用混凝土硬化，作业区墙体及清水池立面未采用防渗漏材料覆盖;在城区主次干道两侧道路红线控制区域设置清洗站                                                                                                                           | 2019-07-30 13:52:41 | 1221      | 城市管理     | 44       | 张三跟李四跟王五一起倒垃圾导致下水管道堵塞的案件                                                                                                                                                             | PERSONAL | NULL      | 2019-07-30 05:56:12 |
| 430b61e08f8745b584bc86cbf6f2fe9f |          | 部门移交     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-30 16:25:35 |           | 农业开发     | 01       | 农业开发                                                                                                                                                                                                     | PERSONAL | NULL      | 2019-07-29 08:25:54 |
| 8b8b6f551c5a45dbb2646c3e0dcbd0fb |          | 举报信访     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-29 16:11:08 |           | 交通运输     | 01       | 张某某在小区后面空地违规燃放烟花爆竹导致引燃一部分垃圾污染空气的案件张某某在小区后面空地违规燃放烟花爆竹导致引燃一部分垃圾污染空气的案件                                                                     | PERSONAL | NULL      | 2019-07-29 08:11:37 |
| 8b6462bcaba845298824896bbedff78b |          | 部门移交     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-29 16:09:53 |           | 文旅广新     | 01       | 张某某在小区后面空地违规燃放烟花爆竹导致引燃一部分垃圾污染空气的案件                                                                                                                                         | PERSONAL | NULL      | 2019-07-29 08:10:47 |
| 8f27d8e66e464e72856c399f1da3ef10 |          | 视频上报     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-07-30 16:07:17 |           | 国土资源     | 01       | 测试第三条案例                                                                                                                                                                                               | PERSONAL | NULL      | 2019-07-29 08:07:50 |
| 05580d60eb5841c09144fa12b7601997 |          | 部门移交     | 作业区未划分洗车区和擦车区，洗车区未设置截水沟、三级沉淀池及污泥暂储设施                                                                                                                                                                                                                                                               | 2019-07-26 15:10:29 |           | 城市管理     | 11       | 测试案件第二条                                                                                                                                                                                               | PERSONAL | NULL      | 2019-07-26 07:11:37 |
| 54b06fc2e7e04f88b4c41715511ed73b |          | 举报信访     | 未按照《建筑垃圾处置（排放）证》上载明的建筑垃圾种类、数量、排放期限排放建筑垃圾                                                                                                                                                                                                                                                       | 2019-07-25 10:47:53 |           | 水务管理     | 11       | 测试案件7月                                                                                                                                                                                                  | PERSONAL | NULL      | 2019-07-26 07:08:13 |
| 99506724750743e09216f80a5ff9ad15 |          | 举报信访     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-02-14 16:54:17 | NULL      | 城市管理     | 01       | 2                                                                                                                                                                                                            | UNIT     | 李        | 2019-02-14 16:54:42 |
| 5e049875cdd44506a0c86812dd0c48e9 |          | 举报信访     | 作业区地面、车辆进出口通道未采用混凝土硬化，作业区墙体及清水池立面未采用防渗漏材料覆盖                                                                                                                                                                                                                                                 | 2019-02-14 09:59:44 | NULL      | 城市管理     | 21       | cheshi1                                                                                                                                                                                                      | UNIT     | 李        | 2019-02-14 02:43:20 |
| 925a5cd7f5754fd5b53bb2dea141f9b6 |          | 举报信访     | NULL                                                                                                                                                                                                                                                                                                                                   | 2019-02-14 09:59:44 | NULL      | 城市管理     | 01       | cheshi2                                                                                                                                                                                                      | UNIT     | 李        | 2019-02-14 02:10:03 |
| 4528fb93bd2443aa904e2b128cec95f2 |          | 视频上报     | 雇佣不符合要求的驾驶员从事建筑垃圾运输活动                                                                                                                                                                                                                                                                                             | 2018-12-12 15:13:25 |           | 城市管理     | 62       | 5                                                                                                                                                                                                            | PERSONAL | NULL      | 2018-12-13 08:28:48 |
| ea809a9d9a324329b45b4b6d5a690a2d |          | 举报信访     | NULL                                                                                                                                                                                                                                                                                                                                   | 2018-12-12 14:11:13 |           | 城市管理     | 11       | 4                                                                                                                                                                                                            | PERSONAL | NULL      | 2018-12-12 06:11:58 |
| eea31b22cabb4a6ba2573f78fe8b779d |          | 视频上报     | 未将建筑垃圾交由本市建筑垃圾运输企业名录中的企业运输                                                                                                                                                                                                                                                                                   | 2018-12-12 13:56:18 |           | 城市管理     | 30       | 2                                                                                                                                                                                                            | PERSONAL | NULL      | 2018-12-12 05:59:34 |
| 82526624e8654115bf84980c20dbd700 |          | 视频上报     | 雇佣不符合要求的驾驶员从事建筑垃圾运输活动                                                                                                                                                                                                                                                                                             | 2018-12-12 11:03:03 |           | 城市管理     | 81       | 1                                                                                                                                                                                                            | PERSONAL | NULL      | 2018-12-12 05:54:54 |
+----------------------------------+----------+--------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------+-----------+--------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+-----------+---------------------+
21 rows in set (0.33 sec)

```