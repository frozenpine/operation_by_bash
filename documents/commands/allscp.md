# 远程分发（allscp）命令

> ### 命令行帮助
>
> ```bash
> $ allscp -h
> Usage: allscp [-g {app_group}] [-P {host_port}] [-u {user_name}] [-h]
>               [-H {host_name}] [-r]
>               PATH [PATH...]
> Args:
>      -g    Specify a application group name, if not specified, all hosts in
>            "/etc/hosts" except localhost will be used.
>      -P    Specify a ssh port to connect to, if not specified, default[22] port
>            will be used.
>      -u    Specify user name used in ssh connection, if not specified, local user
>            will be used.
>      -h    Show this help message.
>      -H    Specify a ssh host to connect to.
>      -r    Recursively transfer data under a directory.
> ```
>
> 将本地文件发送至远程服务器

## 参数说明

* *`-u {user_name}`*：可选参数，指定远程连接的用户名，未指定则默认使用当前用户

* *`-H {host_name}`*：可选参数，指定远程连接的主机名（IP），不可与 *`-g`* 参数共用，当两个参数同时存在时，本参数有更高优先级

* *`-p {host_port}`*：可选参数，指定远程连接使用的端口号，未指定则默认为 SSH 端口（22）

* *`-g {host_group_name}`*：可选参数，指定远程连接的 **`应用组`** ，组名称必须在 ***hosts.ini*** 文件中定义，如 *`-g`* 和 *`-H`* 参数均未指定，则使用 **管理节点** 中 ***/etc/hosts*** 文件中定义的，除 localhost 外其他所有地址

* *`-r`*：可选参数，递归的将指定目录下的所有文件传输到远程服务器，该模式下至少需要2个 *`PATH`* 路径，最后一个 *`PATH`* 路径为目的路径

## 位置参数说明

* *`PATH`*： 至少指定一个 *`PATH`* 路径

  > **Note：** 
  >
  > * 源、目的 路径的使用逻辑同系统自带的 `scp` 命令
  > * 如目标服务器中包含了源主机，脚本将自动跳过目的为自身的分发动作
  >
  > 1. 仅存在一个 *`PATH`* 路径时，表示本地源文件路径，且默认目的路径与源文件一致
  > 2. 存在一个以上的 *`PATH`* 路径时，最后一个 *`PATH`* 为目的路径，路径格式遵循系统 `scp` 命令的规则

## 可自定义的配置项

*bin/conf/common.env* 包含将影响命令执行的配置项：

> **Note：** SUDO 配置不会为文件传输执行提权，即 **`管理用户`** 在不进行提权的前提下，必须对远程目的路径具有可写权限
>
> * *IDENTITY_FILE：* 用于指定远程连接时，使用的 SSH 私钥，如不指定，则使用用户默认私钥，如默认私钥亦未创建，则命令执行失败

## FAQ

1. **Q：** 文件未按设想传输至远程服务器的指定路径？

   **A：** `allscp` 命令实质上为 `scp` 多目标服务器传输的封装，请确保指定的 *`PATH`* 在 `scp` 命令下有正确的行为

2. **Q：** 传输时提示：**permision deny**

   **A：** **管理用户** 对远程服务器的目的路径不具备可写权限，请先将文件传输至 **管理用户** 具备可写权限的目录（*/home/{**`管理用户`**}*，*/tmp* 等），然后使用 `allssh sudo mv {src} {dst}` 再将文件移动至目标路径

3. **Q：** 传输时，某个目标节点出现 **WARNIN** 信息：**Destination is same as localhost**

   **A：** 不要紧张，这不是分发失败，而是由于分发的目标服务器中包含了自身，脚本自动跳过了以自身服务器为目的的分发动作，相同的源、目的传输是浪费时间和性能，不是么 **\^_\^**

## 示例代码

* 单文件传输

  > ```bash
  > # 将 java 的 tar 包文件分发至 zookeeper 应用组下所有主机
  > $ allscp -gzookeeper /data/packages/zookeeper-3.4.13.tar.gz
  > ```

* 目录传输

  > ```bash
  > # 将 bin 目录下所有文件分发给全部节点
  > # 在目录递归传输中，一定要注意结尾的路径分隔符 "/"，否则将有意想不到的“惊喜”
  > $ allscp -r bin/* bin/
  > ```

* 多文件传输

  > **Note：** 理论上应该支持该模式，暂未测试
  >
  > ```bash
  > $ allscp -gkafka bin/service.d/zookeeper.sh bin/service.d/kafka.sh bin/service.d/
  > ```

更多传输模式，请实践 `scp` 命令后，解锁新的传输姿势

