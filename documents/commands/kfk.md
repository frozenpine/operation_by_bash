# Kafka集群管理

> 命令行帮助：
>
> ```bash
> $ kfk -h
> Usage: kfk [-D] [-h]
>            { stop | create | start | init | status | delete | consumer | destory
>            | topic | kill | restart | logs | pub | check | group }
> Args:
>         -D    Dry run command for test.
>         -h    Show this help message.
> Commands:
>       stop    Stop an Kafka cluster/standalone.
>     create    Combine start & init command.
>      start    Start an Kafka cluster/standalone.
>       init    Create topics specified in topic.list
>     status    Check Kafka cluster/standalone status.
>     delete    Delete all topics in Kafka cluster/standalone.
>   consumer   Wrapper for consule-consumer.sh without specify kafka bootstraps.
>    destory    Stop an Kafka cluster/standalone forcely & delete data files.
>      topic    Wrapper for kafka-topic.sh without specify zookeeper address.
>       kill    Stop an Kafka cluster/standalone forcely.
>    restart    Restart an Kafka cluster/standalone.
>       logs    Get all kafka's last 100 logs
>        pub    Publish kafka.sh module in container.d to all memeber hosts.
>      check    Check Kafka cluster/standalone status & data file exists.
>      group    Wrapper for kafak-groups.sh without specify kafka bootstraps.
> ```
>
> 管理 **kafka** 集群及 **topic** 的创建、删除，同时封装了部分 **kafka** 命令行脚本：
>
> 1.  `topic`： *kafka-topics.sh*，封装了 *`--zookeeper`* 参数
> 2. `group`： *kafka-consumer-groups.sh*，封装了 *`--bootstrap-server`* 参数
> 3. `consumer`：*kafka-console-consumer.sh*，封装了 *`--bootstrap-server`* 参数

## 参数说明

* *`-D`*：仅显示命令行至 **console**，而非执行，用于测试

## 命令说明

* `start`：启动 **kafka** 集群/单服务器
* `stop`：正常停止 **kafka** 集群/单服务器，而不删除数据文件
* `status`：查看 **kafka** 集群/单服务器的运行状态
* `restart`：重启 **kafka** 集群/单服务器
* `kill`：强制停止 **kafka** 集群/单服务器
* `delete`：删除全部 **kafka** 的 **topic**
* `check`：检查 **kafka** 容器的运行状态及数据文件
* `destory`：强制停止 **kafka** 集群/单服务器并删除所有的数据文件
* `init`：根据 ***topic.list*** 文件的定义，创建 **topic**
* `create`：这是一个 `start` & `init` 的组合命令
* `logs`：获取 **kafka** 所有节点的最新100条日志
* `pub`：将 **container.d** 下的 ***kafka.sh*** 模块文件发布给所有 **kafka** 节点
* `topic`：***kafka-topics.sh*** 脚本的封装，自动配置 *`--zookeeper`* 参数而无需输入，同时支持其余全部参数
* `group`：***kafka-consumer-groups.sh*** 脚本的封装，自动配置 *`--bootstrap-server`* 参数而无需输入，同时支持其余全部参数
* `consumer`： ***kafka-console-consumer.sh*** 脚本的封装，自动配置 *`--bootstrap-server`* 参数而无需输入，同时支持其余全部参数

