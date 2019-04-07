# Zookeeper集群管理

> 命令行帮助：
>
> ```bash
> $ zk -h
> Usage: zk [-D] [-h]
>           { stop | start | log | status | destory | kill | restart | pub | shell
>           | check }
> Args:
>        -D    Dry run command for test.
>        -h    Show this help message.
> Commands:
>      stop    Stop zookeeper cluster/standalone and keep container & local volume.
>     start    Start zookeeper cluster/standalone.
>      logs    Get zookeeper all memeber nodes's last logs specified by "-t NUM",
>              defualt: 100.
>    status    Check zookeeper cluster/standalone status.
>   destory   Destory zookeeper cluster/standalone and remove container & local
>              volume.
>      kill    Kill zookeeper cluster/standalone forcely and keep container & local
>              volume.
>   restart   Restart zookeeper cluster/standalone.
>       pub    Publish zookeeper container module to all memeber nodes.
>     shell    Get zookeeper container's remote shell in random memeber nodes.
>     check    Check zookeeper cluster/standalone status and local volume exists.
> ```
>
> 管理 **zookeeper** 集群的创建、删除，同时支持命令行连接 **zookeeper** 集群获取 **console** **shell**

## 参数说明

* *`-D`*：仅显示命令行至 **console**，而非执行，用于测试

## 命令说明

* `start`：启动 **zookeeper** 集群/standalone
* `stop`：正常停止 **zookeeper** 集群/standalone
* `status`：查看 **zookeeper** 集群/standalone状态及各成员节点的角色状态
* `restart`：重启 **zookeeper** 集群/standalone
* `check`：检查 **zookeeper** 集群/standalone状态及数据文件
* `kill`：强制停止 **zookeeper** 集群/standalone
* `destory`：强制停止 **zookeeper** 集群/standalone并删除数据文件
* `logs`：获取 **zookeeper** 所有成员的最后100条日志记录
* `pub`：将 **zookeeper** 容器模块发布至所有成员节点
* `shell`：随机连接一个成员节点并获取容器的 **console** **shell**，用于执行 *zkCli.sh*

