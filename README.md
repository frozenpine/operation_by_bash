# 运维脚本使用说明

> [TOC]
>
> 格式约定
>
> * **粗体**：表示专有名词
> * ***粗斜体***：表示一个目录
> * *斜体*：表示一个文件
> * `cmd`：表示一个命令
> * *`arg`*：表示一个参数
> * ${ENV}：表示系统环境变量
> * {value}：表示在命令行或文件路径中需要用实际值替换

## 目录结构

```bash
bin
├─conf
├─container.d
├─logger.d
├─module.d
├─service.d
├─sql
└─templates
    └─dockerfile
        ├─digital
        ├─trade
        └─tradebase
```

* ***conf***： 基础配置文件目录

  > * *common.env*： 基本环境变量
  >
  >    > ```bash
  >    > $ cat bin/conf/common.env
  >    > # 数据基础目录
  >    > DATA_BASE=/data
  >    >
  >    > # 应用基础目录
  >    > APP_BASE=/opt
  >    >
  >    > # SSH 免密连接至应用节点使用的私钥，如为空，则使用管理用户的默认私钥
  >    > IDENTITY_FILE="~/.ssh/Jisheng-func-test.pem"
  >    >
  >    > # 管理用户需要sudo以提升权限，如为root用户，则留空
  >    > SUDO="sudo"
  >    > ```
  >
  > * *hosts.ini*： 应用组<sup>[2](#app-group)</sup>定义
  >
  > * *image.list*： 基础依赖镜像列表
  >
  > * *topic.list*： Kafka初始化 topic 列表
  >
  > * ***dockerfile***： dockerfile模板目录

* ***container.d***： 容器启动模块目录，一个模块文件对应一种容器启动逻辑，模块文件名（不含 “*.sh*” 后缀）即 **应用组<sup>[2](#app-group)</sup>** 名

* ***logger.d***： 自定义日志记录器模块目录，不同的日志模块对应不同的日志存储，目前暂无用，日志输出至 **stdout** & **stderr**

* ***module.d***： 功能模块目录，提供命令行所需的各种功能函数

* ***service.d***： 应用服务模块目录，解决 **应用组<sup>[2](#app-group)</sup>** 成员的 **主机别名<sup>[1](#node-alias)</sup>** 和 **IP** 地址在 */etc/hosts* 文件中的映射关系

* ***sql***： 数据库初始化脚本目录

* ***templates***： 模板文件目录

  > * ***dockerfiles***： 自定义 **docker** 镜像打包所使用的 **dockerfile** 模板文件目录

## 运维框架初始化

1. 定义运维脚本需要管理的 [**主机列表**](documents/inventory.md/#主机信息)

   > 将所有节点的 **IP** 和 **主机名** 添加至 **管理节点<sup>[3](#manage-node)</sup>** 的 */etc/hosts* 文件内
   > ```bash
   > $ cat /etc/hosts
   > 127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 node03
   > ::1         localhost6 localhost6.localdomain6 node03
   > 
   > 172.31.24.111   node01
   > 172.31.24.112   node02
   > 172.31.24.114   node03
   > 
   > ```
   >

2. 规划 [**应用组<sup>[2]</sup>**](documents/inventory.md/#应用分组) 在主机上的分布

3. 根据规划，编辑 ***conf*** 下的服务定义相关的配置文件，[*示例*](documents/commands/svc.md/#可自定义的配置项)

4. 在 **管理节点<sup>[3](#manage-node)</sup>** 上执行 [`svc`](documents/commands/svc.md) 命令，完成 **IP - 主机名** 的初始化

   > ```bash
   > # 自动创建 service.d 下的服务定义模块
   > $ svc create
   > # 根据服务定义模块，完成主机 /etc/hosts 内的 IP-主机名 的映射
   > $ svc sync
   > ```

5. **管理节点<sup>[3](#manage-node)</sup>** 与 [**应用节点<sup>[4]</sup>**](documents/inventory.md/#主机信息) 间建立 SSH 互信

   > **Note：**
   >
   > * **管理节点<sup>[3](#namage-node)</sup>** 应该能免密登录到任意一台运行应用的节点服务器
   > * **管理节点<sup>[3](#manage-node)</sup>** 免密登录 **应用节点<sup>[4](#app-node)</sup>** 的 **管理账号**，应具备 **root** 权限，或至少应能免密使用 **sudo** 以运行需要特权的管理命令

6. 将定义文件分发给所有节点

   > ```bash
   > $ allscp bin/* bin/
   > ```

以上操作完成后，**管理节点<sup>[3](#manage-node)</sup>** 应该具备基本的 [`allssh`](documents/commands/allssh.md) 管理命令的功能：

```bash
[ec2-user@node03 ~]$ allssh uname -n
Results from remote host[ec2-user@172.31.24.111]:
node01

Results from remote host[ec2-user@172.31.24.112]:
node02

Results from remote host[ec2-user@172.31.24.114]:
node03
```

## Docker运行环境部署

1. 安装 **docker** 服务

   > ### Ubuntu
   >
   > ``` bash
   > # 安装命令
   > $ allssh sudo apt-get install -y docker
   > ```
   >
   > ### CentOS
   >
   > ``` bash
   > # 安装命令
   > $ allssh sudo yum install -y docker
   > ```
   >

2. 将所有节点上 **本地镜像仓库<sup>[5](#registry)</sup>** 的连接方式设置为 **HTTP**

   > 编辑 */etc/docker/daemon.json* 文件， 如不存在则新建即可
   > ```yaml
   > {
   > "insecure-registries" : ["registry:5000"]
   > }
   > ```
   > 可先在 **管理节点<sup>[3](#manage-node)</sup>** 上先创建完该文件，再使用 [`allscp`](documents/commands/allscp.md) 命令下发至所有服务器
   >
   > ```bash
   > # 创建 daemon.json 文件
   > $ cat <<EOF > daemon.json
   > {
   > "insecure-registries" : ["registry:5000"]
   > }
   > EOF
   >
   > # 分发至所有服务器
   > $ allscp deamon.json
   >
   > # 将分发文件移动至指定目录
   > $ allssh sudo mv daemon.json /etc/docker/daemon
   > ```
   >

3. 启动 **docker** 服务，并设置开机自启动

   > ```bash
   > # 启动服务
   > $ allssh sudo systemctl start docker
   > # 检查服务状态
   > $ allssh sudo systemctl status docker
   > # 设置开机自启动
   > $ allssh sudo systemctl enable docker
   >
   > # 如无 systemd 环境
   > $ allssh sudo service docker start
   > $ allssh sudo service docker status
   > docker (pid  18499) is running...
   > $ allssh sudo chkconfig --add docker
   > ```
   >

4. 将 **应用节点<sup>[4](#app-node)</sup>** 及 **管理节点<sup>[3](#manage-node)</sup>** 上的 **管理账号<sup>[6](#admin-user)</sup>** 加入 **docker** 组，以具备 **docker** 命令执行权限

   > ```bash
   > # ec2-user 请修改为实际的用户账号
   > # 设置 应用节点 的管理账号
   > $ allssh sudo useradd -Gdocker -a ec2-user
   >
   > # 设置 应用节点 的管理账号
   > $ sudo useradd -Gdocker -a ec2-user
   > ```
   >
   > **管理节点** 上配置完 **docker** 用户组后，需重新登录以使配置生效

5. 在 **管理节点<sup>[3](#manage-node)</sup>** 上使用 [`container`](documents/commands/container.md) 命令启动 **本地镜像仓库<sup>[5](#registry)</sup>**，并配置 [`registry`](documents/images.md#镜像管理命令行) 命令的默认连接仓库

   > ```bash 
   > # 启动容器
   > $ container start registry
   >
   > # 查看容器状态
   > $ container status registry
   > [ INFO] docker container[registry] is running.
   >
   > # 配置默认的连接仓库
   > $ registry -shttp -Hregistry:5000 default
   > ```
   >

6. 编辑 [**基础镜像列表**](documents/images.md/#依赖的外部镜像 "topic.list") 并使用 [`registry`](documents/images.md#镜像管理命令行) 命令从 ***${DATA_BASE}/docker-hub/*** <a name="sync-image">同步</a> 这些基础镜像

   > 列表文件位于 *bin/config/image.list*
   >
   > ```bash
   > # 基础镜像均从 docker-hub 同步，请确保环境能访问 docker-hub
   > $ cat bin/config/image.list
   > redis:5.0.3
   > nginx:1.14.2
   > elasticsearch:6.6.0
   > wurstmeister/kafka:2.12-2.1.0
   > openjdk:8u181-jre
   > zookeeper:3.4.13
   > mysql:5.7.25
   > consul:1.4.3
   >
   > # 执行 registry 命令以同步镜像
   > $ registry sync
   >
   > # 查看 本地镜像仓库 的镜像列表
   > $ registry -p list
   > Results from registry: http://registry:5000
   > [
   >   "consul",
   >   "elasticsearch",
   >   "kafka",
   >   "mysql",
   >   "nginx",
   >   "openjdk",
   >   "redis",
   >   "zookeeper"
   > ]
   >
   > ```
   >

至此，**docker** 运行环境部署完成。

以上内容仅在第一次部署服务器时进行，后续应用部署无论进行多少次，均无需再次进行上述操作。

------

## 应用容器镜像打包

> **Note：** 该运维脚本不包括应用的编译功能，请用户自行编译目标应用

1. 将编译完成的程序包存放至 **管理节点<sup>[3](#manage-node)</sup>** 的 ***${DATA_BASE}/docker-hub/{工程名}*** 目录下

2. 程序包名必须符合如下的命名规则：

   > *{工程名}-{模块名}-{版本号}.jar*， 例如：
   >
   > ```bash
   > $ ls -l /data/docker-hub/trade/
   > total 128836
   > -rw-rw-r-- 1 ec2-user ec2-user 64425301 Apr  4 02:17 trade-clear-1.0.1-SNAPSHOT.jar
   > -rw-rw-r-- 1 ec2-user ec2-user 32671908 Apr  4 02:16 trade-match-1.0.1-SNAPSHOT.jar
   > -rw-rw-r-- 1 ec2-user ec2-user 34825790 Apr  4 02:17 trade-order-1.0.1-SNAPSHOT.jar
   >
   > ```
   >
   > 不符合规则的程序包，请手工修改为符合规则的命名

3. 使用 [`build-image`](documents/commands/build-image.md) 命令，将程序包打包为 **docker** 镜像，并上传至 **本地镜像仓库<sup>[5](#registry)</sup>**

   > 打包过程中，将自动清理 **应用节点<sup>[4](#app-node)</sup>** 上同名的历史镜像，以确保容器启动时，使用的是最新的镜像
   >
   > ```bash
   > # 此处 trade 为 ${DATA_BASE}/docker-hub/ 下存在的工程名
   > # all 表示打包该工程下所有模块，也可指定模块列表（模块名以空格分隔），以更新特定的模块
   > $ build-image -cp -b trade all
   >
   > ```

------

## Zookeeper集群

> **Note：** 建立 **zookeeper** 集群前，请先确保以下操作完成：
>
> 1. **本地镜像仓库<sup>[5](#registry)</sup>** 中存在指定版本号的 **zookeeper** 镜像，该镜像应该在 [**Docker运行环境部署**](#Docker运行环境部署) 的 [同步](#sync-image) 操作中完成下载
> 2. ***service.d*** 下的 *zookeeper.sh* 服务模块有正确的 **IP - HOST** 映射，[*示例*](documents/commands/svc.md/#服务定义示例)

1. 编辑 ***container.d*** 下的 *zookeeper.sh* 容器模块：

   > ```bash
   > $ vim bin/container.d/zookeeper.sh
   > # zookeeper 镜像版本号
   > VERSION="3.4.13"
   > # zookeeper 镜像名，不包含 本地仓库 地址
   > NAME=zookeeper
   > # zookeeper 启动用户
   > USER=${NAME}
   >
   > # zookeeper 客户端连接端口
   > CLIENT_PORT=2181
   > # zookeeper leader 开放端口
   > SVR_PORT1=2888
   > # zookeeper 选举端口
   > SVR_PORT2=3888
   >
   > # zookeeper 依赖的服务列表
   > # registry 服务为所有容器启动模块的固定依赖，不可变
   > # 由于该模块脚本支持启动 zookeeper 集群，集群成员需要知道所有的成员地址
   > # 故还需依赖 zookeeper 自身服务，以获取全部成员的 IP-HOST
   > SERVICE_LIST="registry zookeeper"
   >
   > # 以下是模块启动逻辑，不赘述...
   > ```
   >

2. 将编辑后的启动模块分发给 **zookeeper** 应用组的全部成员节点

   > ```bash
   > $ zk pub
   > ```
   >

3. 使用 [`zk`](documents/commands/zk.md) 集群管理命令启动 **zookeeper** 集群

   > ```bash
   > # 检查集群当前状态，包括：1.容器是否运行；2.数据目录状态
   > $ zk check
   > # start 命令将启动集群
   > $ zk start
   > # 检查集群运行状态
   > $ zk status
   > ```
   >

## Kafka集群

> **Note：** 建立 **kafka** 集群前请确保以下操作已完成：
>
> 1. **本地镜像仓库<sup>[5](#registry)</sup>** 中存在指定版本号的 **kafka** 镜像
> 2. ***service.d*** 下的 *zookeeper.sh* & *kafka.sh* 模块文件有正确的 **IP - HOST** 映射关系
> 3. **zookeeper** 集群已正确启动完成

1. 编辑 ***container.d*** 下的 *kafka.sh* 模块文件：

   > ```bash
   > $ vim bin/container.d/kafka.sh
   > # kafka 的镜像版本号
   > VERSION="2.12-2.1.0"
   > # kafka 的镜像名
   > NAME=kafka
   > # kafka 容器启动所用用户
   > USER=${NAME}
   >
   > # kafka 依赖的服务列表
   > SERVICE_LIST="registry zookeeper kafka"
   >
   > # 以下为启动逻辑，无需修改
   > ```
   >

2. 将编辑后的启动模块分发给 **kafka** 应用组的全部成员节点

   > ```bash
   > $ kfk pub
   > ```

3. 编辑 *topic.list* 列表文件，指定 **kafka** 集群需要创建的 **topic** 列表

   > **Note：** 列表文件每行指定一个 **topic** 名，后可选指定 **分区数** 和 **副本数**
   >
   > ```bash
   > $ vim bin/conf/topic.list
   > # TOPIC_NAME PARTIONS REPLICAS
   > # if want to define replicas without partions, use "null" in partions column
   > MATCH
   > MATCH-SS
   > MATCH-SS-INCREMENT
   > MATCH-JSON-SS
   > MATCH-JSON-SS-INCREMENT
   >
   > BACK-ORDER
   > SS-BOOK-ORDER
   >
   > CLEAR                   # 30
   > APO-FULL                # 30
   > APO-INCREMENT           # 30
   >
   > NOTIFY
   > ACCESS
   > ```
   >

4. 使用 [`kfk`](documents/commands/kfk.md) 集群管理命令启动 **kafka** 集群

   > ```bash
   > # 检查 kafka 集群当前状态及数据目录
   > $ kfk check
   > # 启动 kafka 集群并创建 topic.list 中指定的 topic
   > $ kfk create
   > # 检查集群运行状态
   > $ kfk status
   > # 检查 kafka topic
   > $ kfk topic --list
   > ```
   >

## MySQL数据库

> **Note：** 同上，请先确保基础镜像存在且 **IP - HOST** 映射关系正确

1. 编辑 ***container.d*** 下的 *mysql.sh* 模块文件

   > ```bash
   > $ sudo vim bin/container.d/mysql.sh
   > # mysql 镜像版本号
   > VERSION="5.7.25"
   > # mysql 镜像名
   > NAME=mysql
   > # mysql 启动用户
   > USER=${NAME}
   >
   > # mysql root用户的密码
   > ADMIN_PASSWD="quantdo123456"
   >
   > # mysql 依赖的服务列表
   > SERVICE_LIST="registry"
   >
   > # 以下为容器的启动逻辑，无需修改
   > ```

2. 将编辑过的模块文件分发给全部 **mysql** 节点

   > ```bash
   > $ db pub
   > ```

3. 使用 [`db`](documents/commands/db.md) 集群管理命令启动 **mysql** 集群

   > **Note：** 该管理命令仅实现了 **mysql** 容器的启动，未实现集群内成员间的 [**主从复制<sup>[7]</sup>**](documents/mysql-replication.md) 配置，需管理员手工完成 **主从复制<sup>[7](#replication)</sup>** 的配置工作
   >
   > ```bash
   > # 启动 mysql 集群
   > $ db start
   > # 检查集群状态
   > $ db status
   > ```

4. 如 **mysql** 为单节点，跳过此条配置，如存在多节点，则需手工完成 **主从复制<sup>[7](#replication)</sup>** 的配置工作

5. 创建 **mysql** 数据库及用户

   > ```bash
   > # 连接至 mysql 服务器
   > $ mysql -hmysql -uroot -pquantdo123456
   > Welcome to the MySQL monitor.  Commands end with ; or \g.
   > Your MySQL connection id is 2
   > Server version: 5.7.25-log MySQL Community Server (GPL)
   > 
   > Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.
   > 
   > Oracle is a registered trademark of Oracle Corporation and/or its
   > affiliates. Other names may be trademarks of their respective
   > owners.
   > 
   > Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
   > 
   > mysql> create database digital default charset utf8mb4;
   > Query OK, 1 row affected (0.00 sec)
   > 
   > mysql> create database front default charset utf8mb4;
   > Query OK, 1 row affected (0.00 sec)
   > 
   > mysql> create database sso default charset utf8mb4;
   > Query OK, 1 row affected (0.00 sec)
   > 
   > mysql> create database clear default charset utf8mb4;
   > Query OK, 1 row affected (0.00 sec)
   > 
   > mysql> create user trader identified by 'js2018';
   > Query OK, 0 rows affected (0.00 sec)
   > 
   > mysql> grant all privileges on digital.* to trader@localhost identified by 'js2018';
   > Query OK, 0 rows affected, 2 warnings (0.01 sec)
   > 
   > mysql> grant all privileges on digital.* to trader@'%' identified by 'js2018';
   > Query OK, 0 rows affected, 1 warning (0.00 sec)
   > 
   > mysql> grant all privileges on sso.* to trader@localhost identified by 'js2018';
   > Query OK, 0 rows affected, 2 warnings (0.00 sec)
   > 
   > mysql> grant all privileges on sso.* to trader@'%' identified by 'js2018';
   > Query OK, 0 rows affected, 1 warning (0.00 sec)
   > 
   > mysql> grant all privileges on clear.* to trader@localhost identified by 'js2018';
   > Query OK, 0 rows affected, 2 warnings (0.00 sec)
   > 
   > mysql> grant all privileges on clear.* to trader@'%' identified by 'js2018';
   > Query OK, 0 rows affected, 1 warning (0.00 sec)
   > 
   > mysql> flush privileges;
   > Query OK, 0 rows affected (0.00 sec)
   > 
   > mysql> exit
   > Bye
   > ```

6. 初始化数据库表及基础数据

   > ```bash
   > # 初始化 `digital` 库
   > $ mysql -hmysql -uroot -pquantdo123456 digital < bin/sql/digital/digital_frame.sql
   > 
   > # 初始化 `sso` 库
   > $ mysql -hmysql -uroot -pquantdo123456 sso < bin/sql/sso/sso_frame.sql
   > 
   > # 初始化 `clear` 库
   > $ mysql -hmysql -uroot -pquantdo123456 clear < bin/sql/clear/clear_frame.sql
   > 
   > # 初始化所有的基础数据
   > $ db init all
   > ```

## Redis服务

> **Note：** 同上，请先确保基础镜像存在且 **IP - HOST** 映射关系正确

1. 编辑 ***container.d*** 下的容器启动模块 *redis.sh*

   > ```bash
   > vim bin/container.d/redis.sh
   > # redis 版本号
   > VERSION="5.0.3"
   > # 镜像名
   > NAME=redis
   > # redis 启动用户
   > USER=${NAME}
   >
   > # redis 依赖的服务列表
   > SERVICE_LIST="registry"
   > ```

2. 将容器启动模块发布给所有节点服务器

   > ```bash
   > $ pwd
   > /home/ec2-user
   > # 需要注意发布文件时的路径参数
   > $ allscp -gredis bin/container.d/redis.sh
   > ```

3. 使用 [`container`](documents/commands/container.md) 命令启动 **redis**

   > **Note：** 由于 **redis** 服务启动后无需多做维护，故未封装专用的集群管理命令行
   >
   > ```bash
   > # 启动 redis
   > $ allssh -gredis container start redis
   > # 检查 redis 状态
   > $ allssh -gredis contaienr status redis
   > ```

## Consul集群

> **Note：** 同上，请先确保基础镜像存在且 **IP - HOST** 映射关系正确

1. 编辑 ***container.d*** 下的容器启动模块 *consul.sh*

   > ```bash
   > $ vim bin/container.d/consul.sh
   > # consul 版本号
   > VERSION="1.4.3"
   > # consul 镜像名
   > NAME=consul
   > # 该配置已弃用
   > USER=${NAME}
   > 
   > # consul 绑定的对外提供服务的网卡名
   > BIND_INT="eth0"
   > 
   > # consul 依赖的服务列表
   > SERVICE_LIST="registry consul"
   > ```

2. 将容器启动模块发布至所有成员节点

   > ```bash
   > $ pwd
   > /home/ec2-user
   > # 请注意发布路径的正确性
   > $ allscp -gconsul bin/container.d/consul.sh
   > ```

3. 启动 **consul**

   > ```bash
   > # 启动 consul
   > $ allssh -gconsul container start consul
   > # 查看 consul 状态
   > $ allssh -gconsul container status consul
   > ```

## 启动交易系统

> **Note：**
>
> 1. 启动容器前，请先确保 **本地镜像仓库<sup>[5](#registry)</sup>** 内的应用镜像为最新版本，如非最新，请先编译、[打包](#应用容器镜像打包) 最新镜像
>
>    > 测试阶段版本号为 **SNAPSHOT<sup>[8](#snapshot)</sup>** ，更新较快且每次更新不会改变版本号
>
> 2. 确定 ***conf*** 下的 **IP - HOST** 映射关系文件（*hosts.ini*，*alias.ini*，*ports.ini*）配置正确，且已分发给所有 **应用节点**，并在所有应用节点上已执行了 `svc create`
>
> 3. 确定 **zookeeper** & **kafka** 集群工作正常

1. 编辑 ***bin/conf/*** 下的 *common.env* 配置文件，以指定交易系统各组件的版本号

   > ```bash
   > $ vim bin/conf/common.env
   > # container version definitions
   > # 场下管理系统 rest 接口服务版本号
   > DIGITAL_REST_VERSION=1.0.4-SNAPSHOT
   > # 场下管理系统 service RPC服务版本号
   > DIGITAL_SERVICEIMPL_VERSION=1.0.4-SNAPSHOT
   > 
   > # 交易核心 委托录入版本号
   > TRADE_ORDER_VERSION=1.0.1-SNAPSHOT
   > # 交易核心 清算系统版本号
   > TRADE_CLEAR_VERSION=1.0.1-SNAPSHOT
   > # 交易核心 撮合系统版本号
   > TRADE_MATCH_VERSION=1.0.1-SNAPSHOT
   > ```

2. 将编辑完的 *common.env* 文件分发给所有 **应用节点<sup>[4](#app-node)</sup>**

   > ```bash
   > # 发布 common.env
   > $ allscp bin/conf/common.env
   > ```

3. 使用集群管理命令：[`manage`](documents/commands/manage.md)， [`trade`](documents/commands/trade.md) 启动各子系统

   > ```bash
   > /*
   >  * 启动 场下管理系统
   >  */
   > # 清理 场下管理系统 数据库
   > $ manage truncate
   > # 初始化 场下管理系统 数据库
   > $ manage init
   > # 启动 场下管理系统
   > $ manage start
   > # 检查 场下管理系统 状态
   > $ manage status
   > /*
   >  * 场下管理系统 启动完成
   >  */
   > 
   > /*********************************************/
   > 
   > /*
   >  * 启动 交易核心
   >  */
   > # 启动 交易核心
   > $ trade start
   > # 检查 交易核心
   > $ trade status
   > /*
   >  * 交易核心 启动完成
   >  */
   > ```
   >

---

> ###### 脚注:
> <a name="node-alias">1. 主机别名</a>：为方便区分不同应用对应的主机，为主机取的别名。
> 
> <a name="app-group">2. 应用组</a>：包含运行了同一应用的所有主机的组名。
> 
> <a name="manage-node">3. 管理节点</a>：运行运维管理脚本的主机。
> 
> <a name="app-node">4. 应用节点</a>：运行应用程序的主机。
> 
> <a name="registry">5. 本地镜像仓库</a>：由用户自建的，为容器镜像提供集中存储的服务，一般用于减少容器启动时，下载镜像的时间。
> 
> <a name="admin-user">6. 管理用户</a>：通过SSH登录应用服务器时使用的账号。
> 
> <a name="replication">7. 主从复制</a>：MySQL提供的一种数据备份机制。
> 
> <a name="snapshot">8. SNAPSHOT</a>：Java代码在开发阶段的一种特殊版本名，正式版本中没有SNAPSHOT；正式版本一旦发布后，不能修改包代码，而SNAPSHOT版本代表了开发状态，可覆盖历史同版本代码。
