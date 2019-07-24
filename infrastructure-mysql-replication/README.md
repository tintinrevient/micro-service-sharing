## MySQL Replication


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

| W: GPG error: http://repo.mysql.com/apt/ubuntu bionic InRelease: The following signatures were invalid: EXPKEYSIG 8C718D3B5072E1F5 MySQL Release Engineering <mysql-build@oss.oracle.com>
| W: The repository 'http://repo.mysql.com/apt/ubuntu bionic InRelease' is not signed.
| N: Data from such a repository can't be authenticated and is therefore potentially dangerous to use.
| N: See apt-secure(8) manpage for repository creation and user configuration details.

Install packages for the MySQL community server and client.

```
$ apt-get install mysql-server mysql-client
```

Verify MySQL version, and the sample response is "mysql  Ver 8.0.17 for Linux on x86_64 (MySQL Community Server - GPL)"

```
$ mysql --version
```

### How to Uninstalling MySQL 5.7 in Ubuntu 18.04

Use apt to uninstall and remove all MySQL packages:
```
$ apt-get remove --purge mysql-server mysql-client mysql-common -y
$ apt-get autoremove -y
$ apt-get autoclean
```

### Reference

* https://www.tecmint.com/install-mysql-8-in-ubuntu/
* https://help.cloud66.com/node/how-to-guides/databases/shells/uninstall-mysql.html
* https://www.thegeekdiary.com/mysql-8-0-persisted-variables/