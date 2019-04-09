# 服务管理（svc）命令

> ### 命令行帮助
>
> ```bash
> Usage: svc [-h]
>            { create | sync }
> Args:
>      -h    Show this help message.
> Commands:
>  create    Create service module in "service.d" by definition in "hosts.ini"
>            "alias.ini" "ports.ini"
>    sync    Sync specified IP-HOST mapping to "/etc/hosts" by service name, if no
>            service name specified, all service in "service.d" will be synced.
> ```
>
> 将服务信息同步至 */etc/hosts* 文件

## 命令说明

* `create`：服务模块文件创建命令，该命令根据 *hosts.ini*，*alias.ini*，*ports.ini*，中的定义自动生成 ***service.d*** 目录下的服务模块，同时更新 */etc/hosts* 下的主机映射
* `sync`：同步命令，将指定的服务列表中定义的 **IP - HOST** 映射关系添加至 */etc/hosts* 文件；根据 **HOST**， **IP** 在 */etc/hosts* 文件中不同的存在情况，有如下行为：
  1. **IP**，**HOST** 均不存在：直接添加新的映射关系
  2. **IP** 存在，**HOST** 不存在（该 **IP** 还关联其他 **`主机别名`**）：在原有的映射关系的行尾，添加新的 **HOST**
  3. **IP**，**HOST** 均存在，但与服务中的定义不符（应用迁移或资源重分配等情况，修改了新的映射关系）：删除错误的 **IP** 映射关系中的 **HOST**，并以上述1，2的逻辑添加新的映射
  4. **IP**，**HOST** 均存在，且与服务中的定义相符：这很好啊，什么都不用做

## 可自定义的配置项

> 所有此章节提到的配置文件，均支持以 “#” 开始的单行注释

所有的服务定义均保存于 ***bin/conf/*** 目录下

1. *hosts.ini*：主机 **应用组** 定义文件，此处配置了 **应用组** 的所有成员 **应用节点** ，及远程管理这些节点时使用的连接方式，连接格式：ssh://[[管理用户\]\[:管理密码]@]主机别名[:连接端口]，配置节名即 **应用组** 名

   > ```bash
   > $ vim bin/conf/hosts.ini
   > ## pattern in [] is optional
   > ## ssh://[[[user][:password]]@]host[:port]
   > [elastic]
   > ssh://es
   > 
   > [zookeeper]
   > ssh://zk
   > 
   > [consul]
   > ssh://consul
   > 
   > [digital]
   > ssh://mgmt
   > 
   > [mysql]
   > ssh://mysql
   > 
   > [redis]
   > ssh://redis
   > 
   > [kafka]
   > ssh://kfk
   > 
   > [clear]
   > ssh://clear
   > 
   > [match]
   > ssh://match
   > 
   > [order]
   > ssh://order
   > 
   > [tradebase]
   > ssh://sso
   > 
   > [front]
   > ssh://nginx
   > 
   > [index]
   > ssh://index
   > 
   > [sms]
   > ssh://sms
   > 
   > [registry]
   > ssh://registry
   > ```

2. *alias.ini*：主机别名定义，配置节格式为：[节点主机名:节点IP]，配置内容为该主机的其他 **主机别名**

   > ```bash
   > $ vim bin/conf/alias.ini
   > [node01:172.31.24.111]
   > zk
   > redis
   > sso
   > match
   > index
   > 
   > [node02:172.31.24.112]
   > kfk
   > mysql
   > order
   > mgmt
   > sms
   > 
   > [node03:172.31.24.114]
   > consul
   > es
   > clear
   > nginx
   > registry
   > ```
   >
   > 

3. *ports.ini*：应用服务的默认端口号，如该文件不存在，运行 `create` 命令时将自动创建默认值

   > ```bash
   > $ vim bin/conf/ports.ini
   > zookeeper=2181
   > kafka=9092
   > elastic=9200
   > consul=8500
   > mysql=3306
   > redis=6379
   > front=80
   > digital=9089
   > sms=8180
   > tradebase=9091
   > order=9191
   > clear=9291
   > match=9391
   > registry=5000
   > ```