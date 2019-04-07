# 容器启动命令

> 命令行帮助：
>
> ```bash
> $ container -h
> Usage: container [-h]
>                  { stop | start | status | list | exec | restart | logs | shell }
> Args:
>        -h    Show this help message.
> Commands:
>      stop    Stop an container by name.
>     start    Start an container by name.
>    status    Check container status by name.
>      list    List all running containers.
>      exec    Execute command in an container by name.
>   restart    Restart an container by name.
>      logs    Get container's logs by name.
>     shell    Get an container's shell by name.
> ```
>
> 管理容器的生命周期，该命令实质为系统命令 `docker` 的封装，**管理用户** 必须为 **docker** 组成员，以拥有执行 **docker** 命令的权限。

## 命令说明

* `start`：启动一个容器，启动逻辑封装于 **container.d**目录下
* `stop`：停止一个容器运行
  * *`-c`*：用于标记是否删除容器的本地卷
  * *`-r`*：用于标记是否删除容器
  * *`-f`*：用于标记是否强制停止容器运行
* `status`：查看一个容器的运行状态
* `restart`：重启一个容器
* `list`：列出当前节点上的所有运行容器
* `logs`：获取容器的日志数据，用法同 `docker logs`
* `exec`：在特定容器上执行命令，用法同 `docker exec`
* `shell`：连接至指定容器获取一个 **console** **shell**
  * *`-s {shell_name}`*：指定需要获取的 **shell** 类型，默认值：bash

## 命令行示例

* 获取容器日志

  > ```bash
  > # 获取名为 order 的容器的最后100条日志记录，跟踪新的日志输出
  > $ container logs -f --tail 100 order
  > 
  > # 将名为 clear 的容器的所有日志数据输出至文件
  > $ container logs clear 2>&1 > clear.log
  > ```

* 获取 zookeeper 容器的 **shell**

  > ```bash
  > # 获取名为 zookeeper 的容器的shell
  > $ container shell -s sh zookeeper
  > ```

