# 系统架构

## 主机信息

| 序号 | 主机名 | 内部地址      | 外部地址     | <a name="alias">主机别名</a>                        |
| ---- | ------ | ------------- | ------------ | --------------------------------------------------- |
| 01   | node01 | 172.31.24.111 | 3.112.87.67  | zk \| redis \| sso \| match \| index \| tmdb        |
| 02   | node02 | 172.31.24.112 | 3.112.74.27  | kfk \| mysql \| order \| mgmt \| sms \| sched       |
| 03   | node03 | 172.31.24.114 | 3.112.97.161 | consul \| es \| clear \| nginx \| registry \| query |

## 应用分组

| 序号 | 应用名    | 成员主机 | 服务端口 | 服务协议  | 备注                                                         |
| ---- | --------- | -------- | -------- | --------- | ------------------------------------------------------------ |
|      | registry  | registry | 5000     | http      | 私有镜像仓库服务                                             |
| 01   | zookeeper | zk       | 2181     | zookeeper | Zookeeper 集群，为交易系统的Kafka集群提供服务                |
| 02   | kafka     | kfk      | 9092     | kafka     | Kafka 集群，交易系统的消息中间件                             |
| 03   | consul    | consul   | 8500     | http      | Consul 集群，为 clear & order 提供服务注册/发现，及数据缓存业务 |
| 04   | mysql     | mysql    | 3306     | mysql     | MySQL 双主复制集群，为场下管理系统及场内数据提供持久性存储   |
| 05   | redis     | redis    | 6379     | redis     | Redis 集群，为场下管理系统提供数据缓存服务                   |
| 06   | elastic   | es       | 9200     | http      | Elasticsearch 集群                                           |
| 07   | front     | nginx    | 80       | http      | 前置反向代理集群                                             |
| 08   | tradebase | sso      | 9091     | http      | 交易用户管理集群，提供交易用户的注册、登录、查询以及API-Key管理服务 |
| 09   | order     | order    | 9191     | http      | 报单录入接口集群，以nginx反向代理发布                        |
| 10   | query     | query    | 9192     | http      | 查询接口集群，以nginx反向代理发布                            |
| 11   | clear     | clear    | 9291     | http      | 清算服务集群，以 clientId 进行负载均衡                       |
| 12   | tmdb      | tmdb     | 9292     | http      | 数据落地服务                                                 |
| 13   | match     | match    | 9391     | http      | 撮合服务集群，以 symbol 进行负载均衡                         |
| 14   | digital   | mgmt     | 9089     | http      | 场下管理系统，以nginx反向代理发布                            |
| 15   | sms       | sms      | 9189     | http      | 短信验证码服务                                               |
| 16   | scheduler | sched    | 9289     | http      | 定时任务                                                     |
| 17   | index     | index    |          |           | 指数计算服务                                                 |
