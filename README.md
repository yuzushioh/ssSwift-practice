# Basic Template

A basic vapor template for starting a new Vapor web application. If you're using vapor toolbox, you can use: `vapor new --template=basic`

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

## 💧 Community

Join the welcoming community of fellow Vapor developers in [slack](http://vapor.team).

## 🔧 Compatibility

This package has been tested on macOS and Ubuntu.

## MySQL setup

```
$ sudo mysql
```
```
mysql> create user [name of user];
Query OK, 0 rows affected (0.00 sec)

mysql> create database [name of database];
Query OK, 1 row affected (0.00 sec)

mysql> grant all on [name of database].* to '[name of user]'@'localhost' identified by '[password. could be nil]';
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql> quit
```

## MySQL Error

When it says "The server quit without updating PID file" in th terminal

Run: 
```
sudo chown -R _mysql:_mysql /usr/local/var/mysql
```
