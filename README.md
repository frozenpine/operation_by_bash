# 运维脚本使用说明

> [TOC]

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

* **conf：** 基础配置文件目录

  > * *common.env：* 基本环境变量
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
  > * *hosts.ini：* 应用组定义
  > 
  > * *image.list：* 基础依赖镜像列表
  > 
  > * *topic.list：* Kafka初始化 topic 列表
  > 
  > * **dockerfile：** dockerfile模板目录

* **container.d：** 容器启动模块目录，一个模块文件对应一种容器启动逻辑，模块文件名（不含 “*.sh*” 后缀）即 **`应用组`** 名

* **logger.d：** 自定义日志记录器模块目录，不同的日志模块对应不同的日志存储，目前暂无用，日志输出至 ***stdout*** & ***stderr***

* **module.d：** 功能模块目录，提供命令行所需的各种功能函数

* **service.d：** 应用服务模块目录，解决应用组成员的 **`主机别名`** 和 **IP** 地址在 ***/etc/hosts*** 文件中的映射关系

* **sql：** 数据库初始化脚本目录

* **templates：** 模板文件目录

  > * **dockerfiles：** 自定义 **docker** 镜像打包所使用的 ***dockerfile*** 模板文件目录

## 运维框架初始化

1. 定义运维脚本需要管理的 [**`主机列表`**](documents/inventory.md/#nodes)

   > 将所有节点的 **IP** 和 **主机名** 添加至 **`管理节点`** 的 ***/etc/hosts*** 文件内
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

2. 规划 [**`应用组`**](documents/inventory.md/#应用分组) 在主机上的分布

3. 根据规划，编辑 **service.d** 下的应用服务模块中的 [**`主机别名`**](documents/inventory.md/#alias) 和 **IP** 地址的对应关系，[示例](documents/commands/svc.md/#service-define)

4. 在 **`管理节点`** 上执行 [ ***`服务管理`*** ](documents/commands/svc.md "svc") 命令，完成 **IP - 主机名** 的初始化

5. **`管理节点`** 与 [**`应用节点`**](documents/inventory.md/#nodes) 间建立 SSH 互信

   > * **`管理节点`** 应该能免密登录到任意一台运行应用的节点服务器
   > * **`管理节点`** 免密登录 **`应用节点`** 的 **`管理账号`**，应具备 **root** 权限，或至少应能免密使用 **sudo** 以运行需要特权的管理命令

以上操作完成后，**`管理节点`** 应该具备基本的 [ ***`远程执行`*** ](documents/commands/allssh.md "allssh") 管理命令的功能：

```bash
[ec2-user@node03 ~]$ allssh uname -n
Results from remote host[ec2-user@172.31.24.111]:
node01

Results from remote host[ec2-user@172.31.24.112]:
node02

Results from remote host[ec2-user@172.31.24.114]:
node03

[ec2-user@node03 ~]$ 
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


2. 将所有节点上 **`本地镜像仓库`** 的连接方式设置为 **HTTP**

   > 编辑 ***/etc/docker/daemon.json*** 文件， 如不存在则新建即可
   > ```yaml
   > {
   > "insecure-registries" : ["registry:5000"]
   > }
   > ```
   > 可先在 **`管理节点`** 上先创建完该文件，再使用 [ ***`远程分发`*** ](documents/commands/allscp.md "allscp") 命令下发至所有服务器
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
   > ● docker.service - Docker Application Container Engine
   >    Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   >    Active: active (running) since Wed 2019-01-30 17:39:03 CST; 2 months 2 days ago
   >      Docs: https://docs.docker.com
   >  Main PID: 4058 (dockerd)
   >     Tasks: 21
   >    Memory: 6.2G
   >    CGroup: /system.slice/docker.service
   >            ├─4058 /usr/bin/dockerd -H fd://
   >            └─9176 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 9000 -container-ip 172.17.0.4 -container-port 9000
   > 
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

4. 将 **`应用节点`** 及 **`管理节点`** 上的 **`管理账号`** 加入 **docker** 组，以具备 **docker** 命令执行权限

   > ```bash
   > # ec2-user 请修改为实际的用户账号
   > # 设置 应用节点 的管理账号
   > $ allssh sudo useradd -Gdocker -a ec2-user
   >
   > # 设置 应用节点 的管理账号
   > $ sudo useradd -Gdocker -a ec2-user
   > ```
   >
   > **`管理节点`** 上配置完 **docker** 用户组后，需重新登录以使配置生效

5. 在 **`管理节点`** 上使用 [ ***`容器管理`*** ](documents/commands/container.md "container") 命令启动 **`本地镜像仓库`**，并配置 [ ***`仓库管理`*** ](documents/commands/registry.md "registry") 命令的默认连接仓库

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
   > 
   > ```

6. 编辑 [ **`基础镜像列表`** ](documents/images.md/#依赖的外部镜像) 并使用 [ ***`仓库管理`*** ](documents/commands/registry.md "registry") 命令从 **docker-hub** <a name="sync-image">同步</a> 这些基础镜像

   > 列表文件位于 ***config/image.list***
   >
   > ```bash
   > # 基础镜像均从 docker-hub 同步，请确保环境能访问 docker-hub
   > $ cat config/image.list
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

至此，**docker** 运行环境部署完成。

以上内容仅在第一次部署服务器时进行，后续应用部署无论进行多少次，均无需再次进行上述操作。

------



## 应用容器镜像打包

> **Note：** 该运维脚本不包括应用的编译功能，请用户自行编译目标应用



1. 将编译完成的程序包存放至 **`管理节点`** 的 ***${DATA_BASE}/docker-hub/{工程名}*** 目录下

2. 程序包名必须符合如下的命名规则：

   > {工程名}-{模块名}-{版本号}.jar， 例如：
   >
   > ```bash
   > $ ll /data/docker-hub/trade/
   > total 128836
   > -rw-rw-r-- 1 ec2-user ec2-user 64425301 Apr  4 02:17 trade-clear-1.0.1-SNAPSHOT.jar
   > -rw-rw-r-- 1 ec2-user ec2-user 32671908 Apr  4 02:16 trade-match-1.0.1-SNAPSHOT.jar
   > -rw-rw-r-- 1 ec2-user ec2-user 34825790 Apr  4 02:17 trade-order-1.0.1-SNAPSHOT.jar
   > 
   > ```
   > 
   > 不符合规则的程序包，请手工修改为符合规则的命名

3. 使用 [ ***`镜像打包`*** ](documents/commands/build-image.md "build-image") 命令，将程序包打包为 **docker** 镜像，并上传至 **`本地镜像仓库`**

   > 打包过程中，将自动清理 **`应用节点`** 上同名的历史镜像，以确保 **容器** 启动时，使用的是最新的镜像
   >
   > ```bash
   > # 此处 trade 为 ${DATA_BASE}/docker-hub/ 下存在的工程名
   > # all 表示打包该工程下所有模块，也可指定模块列表（模块名以空格分隔），以更新特定的模块
   > $ build-image -cp -b trade all
   > 
   > ```

---

## Zookeeper集群搭建

> **Note：** 建立 **zookeeper** 集群前，请先确保以下操作完成：
>
> 1. **`本地仓库`** 中存在指定版本号的 **zookeeper** 镜像，该镜像应该在 [**Docker运行环境部署**](#Docker运行环境部署) 的 [同步](#sync-image) 操作中完成下载
> 2. **service.d** 下的 ***zookeeper.sh*** 服务模块有正确的 **IP - HOST** 映射，[示例](documents/commands/svc.md/#服务定义示例)

1. 编辑 **container.d** 下的 ***zookeeper.sh*** 容器模块：

   ```bash
   $ vim bin/container.d/zookeeper.sh
   # zookeeper 镜像版本号
   VERSION="3.4.13"
   # zookeeper 镜像名，不包含 本地仓库 地址
   NAME=zookeeper
   # zookeeper 启动用户
   USER=${NAME}
   
   # zookeeper 客户端连接端口
   CLIENT_PORT=2181
   # zookeeper leader 开放端口
   SVR_PORT1=2888
   # zookeeper 选举端口
   SVR_PORT2=3888
   
   # zookeeper 依赖的服务列表
   # registry 服务为所有容器启动模块的固定依赖，不可变
   # 由于该模块脚本支持启动 zookeeper 集群，集群成员需要知道所有的成员地址
   # 故还需依赖 zookeeper 自身服务，以获取全部成员的 IP-HOST
   SERVICE_LIST="registry zookeeper"
   
   # 以下是模块启动逻辑，不赘述...
   ```

   

2. 将编辑后的启动模块分发给 **zookeeper** 应用组的全部成员节点

   ```bash
   $ zk pub
   ```

3. 使用 [ ***`zk`*** ](documents/commands/zk.md) 集群管理命令启动 **zookeeper** 集群

   ```bash
   # 检查集群当前状态，包括：1.容器是否运行；2.数据目录状态
   $ zk check
   # start 命令将启动集群
   $ zk start
   # 检查集群运行状态
   $ zk status
   ```


## Kafka集群搭建

> **Note：** 建立 **kafka** 集群前请确保以下操作已完成：
>
> 1. **`本地仓库`** 中存在指定版本号的 **kafka** 镜像
> 2. **service.d** 下的 ***zookeeper.sh*** & ***kafka.sh*** 模块文件有正确的 **IP - HOST** 映射关系
> 3. **zookeeper** 集群已正确启动完成

1. 编辑 **container.d** 下的 ***kafka.sh*** 模块文件：

   ```bash
   $ vim bin/container.d/kafka.sh
   # kafka 的镜像版本号
   VERSION="2.12-2.1.0"
   # kafka 的镜像名
   NAME=kafka
   # kafka 容器启动所用用户
   USER=${NAME}
   
   # kafka 依赖的服务列表
   SERVICE_LIST="registry zookeeper kafka"
   
   # 以下为启动逻辑，无需修改
   ```

2. 将编辑后的启动模块分发给 **kafka** 应用组的全部成员节点

   ```bash
   $ kfk pub
   ```

3. 编辑 ***topic.list*** 列表文件，指定 **kafka** 集群需要创建的 **topic** 列表

   > **Note：** 列表文件每行指定一个 **topic** 名，后可选指定 **`分区数`** 和 **`副本数`**

   ```bash
   $ vim bin/conf/topic.list
   # TOPIC_NAME PARTIONS REPLICAS
   # if want to define replicas without partions, use "null" in partions column
   MATCH
   MATCH-SS
   MATCH-SS-INCREMENT
   MATCH-JSON-SS
   MATCH-JSON-SS-INCREMENT
   
   BACK-ORDER
   SS-BOOK-ORDER
   
   CLEAR                   # 30
   APO-FULL                # 30
   APO-INCREMENT           # 30
   
   NOTIFY
   ACCESS
   ```

4. 使用 [ ***`kfk`*** ](documents/commands/kfk.md) 集群管理命令启动 **kafka** 集群

   ```bash
   # 检查 kafka 集群当前状态及数据目录
   $ kfk check
   # 启动 kafka 集群并创建 topic.list 中指定的 topic
   $ kfk create
   # 检查集群运行状态
   $ kfk status
   # 检查 kafka topic
   $ kfk topic --list
   ```

   