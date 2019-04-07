# 容器镜像设置

## 依赖的外部镜像

* **registry:** registry:latest
* **redis:** redis:5.0.3
* **nginx:** nginx:1.14.2
* **elasticsearch:** elasticsearch:6.6.0
* **kafaka:** wurstmeister/kafka:2.12-2.1.0
* **openjdk:** openjdk:8u181-jre
* **zookeeper:** zookeeper:3.4.13
* **mysql:** mysql:5.7.25
* **consul:** consul:1.4.3

以上依赖镜像来源均为 [Docker Hub](<https://hub.docker.com/>)， 除 **registry** 外，全部推送至本地仓库存储

## 本地镜像仓库配置

* 镜像仓库位于测试节点3(**172.31.24.144**)，使用容器运行

  > 容器名：**registry**
  >
  > 本地卷：*/data/registry*

* 仓库配置位于： */etc/registry/config.yml*

  > ```yaml
  > version: 0.1
  > log:
  >   fields:
  >     service: registry
  > storage:
  >   delete:
  >     enabled: true
  >   cache:
  >     blobdescriptor: inmemory
  >   filesystem:
  >     rootdirectory: /var/lib/registry
  > http:
  >   addr: :5000
  >   headers:
  >     X-Content-Type-Options: [nosniff]
  > health:
  >   storagedriver:
  >     enabled: true
  >     interval: 10s
  >     threshold: 3
  > ```

* 仓库连接方式：**http**

* 仓库使用 **htpasswd** 进行登录验证

  > 用户名：**quantdo**
  >
  > 密    码：**quantdo123456**

## 镜像管理命令行

命令：`registry`

> 命令行帮助：
>
> ```bash
> $ registry -h
> Usage: registry [-H {uri}] [-s {scheme}] [-h] [-p]
>                 { manifests | list | show | default | sync }
> Args:
>          -H    Specify host uri used in management, if not specified, default one
>                stored by "default" command will be used.
>          -s    Specify connection type(http|https), if not specified, default one
>                stored by "default" command will be used.
>          -h    Show this help message.
>          -p    Format result with `jq`.
> Commands:
>   manifests    Show all/specified image's manifest id.
>        list    List all images in registry.
>        show    Show all/specified image with tags.
>     default    Save default registry's URI & connection type.
>        sync    Sync a image fron source registry to dest.
> ```

### 参数说明

* *`-H {uri}`*：可选参数，指定命令行连接的仓库，如无指定，则使用 `default` 命令保存的默认地址
* *`-s {scheme}`*：可选参数，指定连接使用的协议（http|https），如无指定，则使用 `default` 命令保存的默认协议类型
* *`-p`*：可选参数，是否使用 `jq` 命令格式化数据信息

### 命令说明

1. `list`：列出本地仓库内的所有镜像
2. `show`：显示镜像的 **tag** 信息
3. `manifests`：显示镜像的 **manifest** 信息
4. `default`：设置命令行连接的默认仓库
5. `sync`：同步两个仓库的指定镜像
