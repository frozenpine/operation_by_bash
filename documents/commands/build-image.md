# 容器镜像打包

> 命令行帮助：
>
> ```bash
> $ build-image -h
> Usage: build-image -b {build_name} [-D] [-c] [-h] [-p]
> Args:
>      -b    Project name to build.
>      -D    Dry run command for test.
>      -c    Clean local build image.
>      -h    Show this help message.
>      -p    Push image to registry.
> 
> Available {build_name}:
>     1. trade
>     2. tradebase
>     3. digital
> ```
>
> `docker` 镜像打包命令行的封装，可根据预定义的 *dockerfile.template* 生成应用容器镜像

# 参数说明

* *`-b {build_name}`*：指定需要打包镜像的工程名，该工程名必须为 ***${DATA_BASE}/docker-hub/*** 目录下的目录名，**工程名** 目录下存放编译完成的应用包
* *`-c`*：本地编译镜像清除标记，如指定该标记，则自动清理打包服务器上打包后的本地镜像文件
* *`-p`*：推送 **本地镜像仓库** 标记，如指定该标记，则在打包成功后自动将镜像推送至 **本地镜像仓库**
* *`-D`*：仅向 **console** 数据将要执行的命令行，而不实际执行命令，用于测试功能

## 可用的工程名

所有需要打包的应用包均需按照特定格式存放于 ***${DATA_BASE}/docker-hub/{工程名}/***  目录下

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