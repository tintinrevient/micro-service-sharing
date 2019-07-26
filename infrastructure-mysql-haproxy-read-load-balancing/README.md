## HAProxy to Load Balance MySQL-Read-Replica Servers

### 架构

数据库Read的Load balancer架构如下：

![db-cluster](./pix/db-cluster.png)

其中，具体Linux服务器的信息如下：
* HAProxy - 192.168.0.171
* MySQL-1 - 192.168.0.173
* MySQL-2 - 192.168.0.174

### 怎么配置HAProxy所在的服务器

1. 安装HAProxy

```
$ apt-get install haproxy
```

2. 修改/etc/haproxy/haproxy.cfg，添加如下配置：

MySQL的load balancing配置如下：

```
listen mysql_cluster
	bind 127.0.0.1:3306
	mode tcp
	balance leastconn
	option tcpka
    option httpchk
    option tcp-check
	server mysql-1 192.168.0.173:3306 weight 50 check port 3306 inter 5000 rise 1 fall 3 maxconn 75
    server mysql-2 192.168.0.174:3306 weight 50 check port 3306 inter 5000 rise 1 fall 3 maxconn 75
```

HTTP的监控配置如下：
```
listen monitoring
        bind 0.0.0.0:8100
        mode http
        stats enable
        stats uri /
        stats realm Strictly\ Private
        stats auth admin:admin
```

3. 配置完后，启动HAProxy：

先验证配置是否有效。如果配置有效，会看到提示："Configuration file is valid"。

```
$ haproxy -c -V -f /etc/haproxy/haproxy.cfg
```

启动HAProxy：

```
$ haproxy -f /etc/haproxy/haproxy.cfg
```

此时HAProxy全部配置完成。余下要做的事项是，在其余两个MySQL服务器中分别添加如下的mysql.user：
* haproxy_root@192.168.0.171 - 用于从HAProxy服务器，以root权限访问MySQL服务器。

当如上事项完成，当访问http://192.168.0.171:8100/ ，可以看到如下监控页面：
![haproxy](./pix/haproxy.png)

此时，可以通过执行如下命令，查看HAProxy是否load balance了mysql-server的read访问：

```
$ mysql -h 127.0.0.1 -u haproxy_root -p -e "show variables like 'server_id'"
```

如果load balance成功，会看到如下两个response，在以roundrobin的方式交替显示：

| Variable_name  | Value |
|----------------|-------|
| server_id      | 2     |

| Variable_name  | Value |
|----------------|-------|
| server_id      | 3     |

### 怎么配置MySQL所在的服务器

1. 安装mysql-client和mysql-server

```
$ apt-get install mysql-client mysql-server
```

2. 修改/etc/mysql/my.cnf，添加如下配置：

    192.168.0.173的server-id是2，192.168.0.174的server-id是3。这样便于在HAProxy验证load balancing的时候，区分不同MySQL数据库。

```
[mysqld]
bind-address                    = 192.168.0.173/174
server-id                       = 2/3
```

3. 然后重新启动mysql。

```
$ service mysql restart
```

或者

```
$ systemctl restart mysql
```

这时可以通过如下命令，验证bind-address是否设置成功：

```
$ sudo netstat -plutn | grep -i mysql
```

当bind-address设置成功，会看到如下信息：

```
tcp        0      0 192.168.0.173:3306      0.0.0.0:*               LISTEN      19755/mysqld
```

4. 最后以默认root/root登录mysql shell：

```
$ /usr/bin/mysql -u root -p
```

5. 添加haproxy_root@192.168.0.171，到mysql.user：

```
mysql > CREATE USER 'haproxy_root'@'192.168.0.171' IDENTIFIED BY 'root';
mysql > GRANT ALL PRIVILEGES ON *.* TO 'haproxy_root'@'192.168.0.171' WITH GRANT OPTION;
mysql > FLUSH PRIVILEGES;
```

这时执行如下query，可以看到新添加的用户：

```
mysql > select user, host from mysql.user;
```

添加的用户如下：

| user             | host          |
|------------------|---------------|
| haproxy_root     | 192.168.0.171 |


### 错误及其修改方法

#### 1. Host is blocked because of many connection errors

当在192.168.0.171的mysql-client，验证remote mysql-server的连接时：

```
mysql -h 192.168.0.173/174 -u haproxy_root -p -e "show variables like 'server_id'"
```

出现如下错误：

```
Host '192.168.0.171' is blocked because of many connection errors; unblock with 'mysqladmin flush-hosts'
```

可以在mysql-server：192.168.0.173和192.168.0.174，做如下操作：

```
$ mysqladmin -u root -p flush-hosts
```

或者在MySQL Shell中，做如下操作：

```
mysql > flush hosts;
mysql > SET PERSIST max_connect_errors=10000;
mysql > restart;
```

#### 2. HAProxy does not forward requests while listening on 本机的3306端口

第一步，当执行如下命令：

```
$ netstat -plutn | grep -i haproxy
```

可以看到HAProxy正常监听本机的3306端口。本机的IP是192.168.0.171。

```
tcp        0      0 0.0.0.0:8100            0.0.0.0:*               LISTEN      1171/haproxy
tcp        0      0 192.168.0.171:3306      0.0.0.0:*               LISTEN      1171/haproxy
```

第二步，当用mysql-client直接连接到remote的mysql-server，比如192.168.0.173或者192.168.0.174时，以下直接连接是能成功的。
```
$ mysql -h 192.168.0.173 -u haproxy_root -p -e "show variables like 'server_id'
```

第三步，当用mysql-client命令，让HAProxy forward requests到remote的mysql-server时，出现无法连接远程MySQL服务器的错误。

```
$ mysql -h 192.168.0.171 -u haproxy_root -p -e "show variables like 'server_id'"
```

那么错误原因是因为在haproxy.cfg中，设置的"option mysql-check user haproxy"，需要改成"option tcp-check"。
* option mysql-check是layer 7的load balancing，而layer 7 load balancing是application级别的。此时，mysql-client并没有启动。
* option tcp-check是layer 4的load balancing，而layer 4 load balancing不需要mysql-client的应用被启动。

### Reference

* https://www.digitalocean.com/community/tutorials/how-to-use-haproxy-to-set-up-mysql-load-balancing--3
* https://support.rackspace.com/how-to/installing-mysql-server-on-ubuntu/

* [ufw firewall](https://linoxide.com/firewall/guide-ufw-firewall-ubuntu-16-10/)

```
$ sudo ufw allow mysql
```

* [Determine which MySQL configuration file is being used](https://stackoverflow.com/questions/580331/determine-which-mysql-configuration-file-is-being-used)

```
$ /usr/sbin/mysqld --verbose --help | grep -A 1 "Default options"
```

* [Bind address and MySQL server](https://stackoverflow.com/questions/3552680/bind-address-and-mysql-server)

    * If MySQL binds to 127.0.0.1, then only software on the same computer will be able to connect (because 127.0.0.1 is always the local computer).
    * If MySQL binds to 192.168.0.2 (and the server computer's IP address is 192.168.0.2 and it's on a /24 subnet), then any computers on the same subnet (anything that starts with 192.168.0) will be able to connect.
    * If MySQL binds to 0.0.0.0, then any computer which is able to reach the server computer over the network will be able to connect.