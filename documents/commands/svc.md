# 服务管理（svc）命令

> ### 命令行帮助
>
> ```bash
> Usage: svc sync [service_name...]
>     sync  sync specify Host - IP mapping to "/etc/hosts" by service name, if no service name specified, all service in "service.d" will be synced.
> ```
>
> 将服务信息同步至 ***/etc/hosts*** 文件

## 参数说明

* sync：同步命令，将指定的服务列表中定义的 **IP - HOST** 映射关系添加至 ***/etc/hosts*** 文件；根据 **HOST**， **IP** 在 **/etc/hosts** 文件中不同的存在情况，有如下行为：
  1. **IP**，**HOST** 均不存在：直接添加新的映射关系
  2. **IP** 存在，**HOST** 不存在（该 **IP** 还关联其他 **`主机别名`**）：在原有的映射关系的行尾，添加新的 **HOST**
  3. **IP**，**HOST** 均存在，但与服务中的定义不符（应用迁移或资源重分配等情况，修改了新的映射关系）：删除错误的 **IP** 映射关系中的 **HOST**，并以上述1，2的逻辑添加新的映射
  4. **IP**，**HOST** 均存在，且与服务中的定义相符：这很好啊，什么都不用做

## 可自定义的配置项

所有的服务定义均保存于 ***bin/service.d/*** 目录下，且以 ***{服务名}.sh*** 命名

该服务定义保存了提供该服务的所有主机的 **`主机别名`** 和 **IP** 的对应关系

服务定义列表请参看 [ **`主机列表`** ](documents/inventory.md)

服务定义仅需要修改文件中 **XXX_LIST ** 命名数组

## 服务定义示例

* zookeeper服务

  ```bash
  # zookeeper 命名数组声明
  declare -A ZK_LIST
  
  # 主机别名 为 zk，IP 地址为 172.31.24.111 的节点，提供了 zookeeper 服务
  ZK_LIST["zk"]="172.31.24.111"
  
  # 多节点集群配置参考如下示例
  # ZK_LIST["zk001"]="172.31.11.14"
  # ZK_LIST["zk002"]="172.31.11.15"
  # ZK_LIST["zk003"]="172.31.11.16"
  
  # 此项配置留空，由 container.d 下的模块代码动态生成
  ZK_SERVERS=
  # 提供 zookeeper 服务的应用开放的端口号
  ZK_PORT=2181
  
  # 下方还有同步 IP - HOST 至 /etc/hosts 文件的处理逻辑，不需要修改，此处不赘述
  
  ```

其余服务定义大同小异，可参考上述示例