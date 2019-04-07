# MySQL集群管理

> 命令行帮助：
>
> ```bash
> $ db -h
> Usage: db [-g {group_name}] [-p {db_pass}] [-D] [-H {db_host}] [-u {db_user}]
>           [-h] [-P {db_port}]
>           { stop | start | init | status | destory | kill | truncate | pub }
> Args:
>         -g    Group name for mysql cluster, default: "mysql".
>         -p    Specify db pass in db connection, if not sepcified, default identity
>               will be used.
>         -D    Dry run command for test.
>         -H    Specify db host to connect to, default: random host in mysql group.
>         -u    Specify db user in db connection, if not sepcified, default identity
>               will be used.
>         -h    Show this help message.
>         -P    Specify db port to connect to, default: 3306.
> Commands:
>       stop    Stop all mysql hosts.
>      start    Start all mysql hosts without replication.
>       init    Init specified db's talbes in sql directory, need db creation first.
>     status    Check all mysql hosts' status.
>    destory    Stop all mysql hosts & remove data files.
>       kill    Kill all mysql hosts forcely.
>   truncate    Truncate all specified db's tables.
>        pub    Publish container module to all mysql nodes.
> ```
>
> 管理 **mysql** 集群的启动、删除，同时支持根据 ***sql*** 目录下的sql脚本定义初始化数据库表结构及基础数据

## 参数说明

* *`-g {group_name}`*：可选参数，**mysql** 集群的应用组名设置，默认值：mysql

* *`-H {db_host}`*：可选参数，指定需要连接的 **mysql** 实例服务器的地址，默认值：从所有成员服务器中随机选择一个

* *`-P {db_port}`*：可选参数，指定需要连接的 **mysql** 实例服务器的端口，默认值：3306

* *`-u {db_user}`*：可选参数，指定连接 **mysql** 服务器使用的账号，默认值：脚本默认用户

* *`-p {db_pass}`*：可选参数，指定连接 **mysql** 服务器使用的密码，默认值：脚本默认密码

## 命令说明

* `start`：启动 **mysql** 集群
* `stop`：正常停止 **mysql** 集群
* `status`：查看 **mysql** 集群的状态
* `kill`：强制停止 **mysql** 集群
* `destory`：强制停止 **mysql** 集群并删除数据我呢见
* `pub`：发布容器启动模块至所有 **mysql** 成员节点
* `init`：根据 ***sql*** 目录下的定义，初始化数据库的表结构
* `truncate`：查找并清空数据库下的所有表

## 命令行示例

* 初始化数据库的表结构

  > ```bash
  > # 初始化所有数据库的表结构
  > $ db init all
  > 
  > # 初始化特定数据库的表结构
  > $ db init sso
  > ```

* 清空数据库的数据表

  > ```bash
  > # 清空所有数据库的表数据
  > $ db truncate all
  > 
  > # 清空特定数据库的表数据
  > $ db truncate digital
  > ```
  >