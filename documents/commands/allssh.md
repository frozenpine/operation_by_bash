# 远程执行（allssh）命令

> ### 命令行帮助
>
> ```bash
> $ allssh -h
> Usage: allssh [-u {user_name}] [-H {host_name}] [-p {host_port}] [-g {host_group_name}] commands
>       -u  specify user name used in ssh connection, if not specified, local user will be used.
>       -H  specify a ssh host to connect to.
>       -p  specify a ssh port to connect to, if not specified, default[22] port will be used.
>       -g  specify a ssh host group, if not specified, all hosts in "/etc/hosts" except localhost will be used.
> ```
>
> 将特定的命令行发送至远程主机执行，并显示命令执行结果

## 参数说明

* -u {user_name}：可选参数，指定远程连接的用户名，未指定则默认使用当前用户

* -H {host_name}：可选参数，指定远程连接的主机名（IP），不可与 `-g` 参数共用，当两个参数同时存在时，本参数有更高优先级

* -p {host_port}：可选参数，指定远程连接使用的端口号，未指定则默认为 SSH 端口（22）

* -g {host_group_name}：可选参数，指定远程连接的 **`应用组`** ，组名称必须在 ***hosts.ini*** 文件中定义，如 `-g` 和 `-H` 参数均未指定，则使用 **`管理节点`** 中 ***/etc/hosts*** 文件中定义的，除 localhost 外其他所有地址

* commands：发送至远程主机执行的命令

  > **Note:** 在输入命令行时，需注意部分在 **Bash** 中有特殊含义的字符需要转义，否则将出现意料不到的执行结果

## 可自定义的配置项

***bin/conf/common.env*** 包含将影响命令执行的配置项：

* *IDENTITY_FILE：* 用于指定远程连接时，使用的 SSH 私钥，如不指定，则使用用户默认私钥，如默认私钥亦未创建，则命令执行失败


* *SUDO：* 用于标识 **`管理用户`** 需要使用sudo提权，且该 **`管理用户`** 需支持 sudo 免密提权，否则将导致命令执行挂起/失败；如 **`管理用户`** 为 **root** 则该项配置可留空

## FAQ

1. **Q：** 指定 SSH 私钥后，执行命令时提示：

   ```bash
   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   @         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   Permissions 0666 for '/home/ec2-user/.ssh/Jisheng-func-test.pem' are too open.
   It is required that your private key files are NOT accessible by others.
   This private key will be ignored.
   Load key "/home/ec2-user/.ssh/Jisheng-func-test.pem": bad permissions
   Permission denied (publickey).
   ```

   **A：** 这是由于私钥的权限不正确，取消该私钥 **用户组** 和 **其他用户** 的所有权限即可：`chmod go-rwx ${IDENTITY_FILE}`

2. **Q：** 产生了奇怪的执行结果，或者命令行未按照设想的运行？

   **A：** 一般情况下，均为未正确对发送的命令行进行转义，导致部分有特殊含义的字符在本地 SHELL 中优先产生了效果，请检查命令行的转义是否正确

3. **Q：** 执行命令时提示：`command not found`

   **A：** 

   * 请勿使用由 **alias** 定义的命令行简写，如：`ll` ， `la` 等，请使用该命令的完整版本 `ls -l` ，`ls -la` 
   * 请确认该命令是否在远程服务器上存在，如不存在，请先安装
   * 如命令在远程服务器上存在，请确定该命令的执行是否需要特权，尝试使用 `sudo 命令行` 重新运行

## 示例代码

* 管道符（|）

  ```bash
  # 查看并过滤zookeeper应用组中所有主机安装的应用列表
  # “|” 管道符在 SHELL 中有特殊含义，如需在远程主机进行管道连接，请使用 "" 将完整命令包裹起来
  # 否则，会在远程主机上执行管道左侧命令，并将结果取回后，在本地连接管道右侧命令
  $ allssh -gzookeeper "rpm -qa | grep jq"
  ```

* 重定向（>）

  ```bash
  # 查看特定主机的服务运行状态，并将状态结果保存在远程服务器
  # ">" 重定向符默认将stdout重定向至指定的 文件系统/其他管道，如需在远程主机进行重定向，
  # 除上述例子中使用 "" 包裹完整命令外，也可使用 "\" 将 ">" 转义，
  # 使其在本地 SHELL中失去原有含义
  # 否则，重定向将在本地主机执行，docker.status文件将在本地服务器建立，而非远程服务器
  $ allssh -Hkfk sudo service docker status \> docker.status
  ```


* 美元符（$）

  ```bash
  # 查看远程服务器的环境变量
  # "$" 表示环境变量的引用，由于变量替换发生在 Bash 执行命令前，如需使用的变量为远程服务器变量，
  # 则需对 "$" 进行转义，以免变量替换在本地发生
  # 注意：双引号内也会进行变量替换，故无法简单的使用 "" 包裹命令来避免变量替换
  # 故需使用 "\" 转义 "$"，或者使用单引号 '' 包裹命令，以避免变量替换的发生
  $ allssh -Hnode02 echo \$SSH_CONNECTION
  # 以下命令与上述示例等价
  $ allssh -Hnode02 'echo $SSH_CONNECTION'
  ```

切记，一切 **Bash** 中会产生变量替换、子 SHELL 执行的特殊字符均需要转义

理论上该 `allssh` 命令可以远程执行一切 **Bash** 脚本能做的事情，但是，如无深刻的 **Bash** 开发功底，请勿尝试复杂的组合命令，背景音乐：……多么痛的领悟~~

