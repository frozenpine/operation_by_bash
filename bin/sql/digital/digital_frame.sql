/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 5.7.25 : Database - digital
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`digital` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `digital`;

/*Table structure for table `job_execution_log` */

DROP TABLE IF EXISTS `job_execution_log`;

CREATE TABLE `job_execution_log` (
  `id` varchar(40) NOT NULL,
  `job_name` varchar(100) NOT NULL,
  `task_id` varchar(255) NOT NULL,
  `hostname` varchar(255) NOT NULL,
  `ip` varchar(50) NOT NULL,
  `sharding_item` int(11) NOT NULL,
  `execution_source` varchar(20) NOT NULL,
  `failure_cause` varchar(4000) DEFAULT NULL,
  `is_success` int(11) NOT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `complete_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `job_status_trace_log` */

DROP TABLE IF EXISTS `job_status_trace_log`;

CREATE TABLE `job_status_trace_log` (
  `id` varchar(40) NOT NULL,
  `job_name` varchar(100) NOT NULL,
  `original_task_id` varchar(255) NOT NULL,
  `task_id` varchar(255) NOT NULL,
  `slave_id` varchar(50) NOT NULL,
  `source` varchar(50) NOT NULL,
  `execution_type` varchar(20) NOT NULL,
  `sharding_item` varchar(100) NOT NULL,
  `state` varchar(20) NOT NULL,
  `message` varchar(4000) DEFAULT NULL,
  `creation_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `TASK_ID_STATE_INDEX` (`task_id`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_account_capital` */

DROP TABLE IF EXISTS `t_account_capital`;

CREATE TABLE `t_account_capital` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `account_id` varchar(50) NOT NULL COMMENT '资金账号',
  `user_id` varchar(30) DEFAULT NULL COMMENT '用户代码',
  `currency` varchar(10) NOT NULL COMMENT '币种',
  `balance` decimal(30,10) NOT NULL COMMENT '账户余额',
  `avail_balance` decimal(30,10) NOT NULL COMMENT '可用余额',
  `margin_balance` decimal(30,10) NOT NULL COMMENT '保证金余额',
  `positionl_margin` decimal(30,10) NOT NULL COMMENT '持仓保证金',
  `order_margin` decimal(30,10) NOT NULL COMMENT '委托保证金',
  `unrealised_pnl` decimal(30,10) NOT NULL COMMENT '未实现盈亏',
  `transfer_in` decimal(30,10) DEFAULT NULL COMMENT '转入金额',
  `transfer_out` decimal(30,10) DEFAULT NULL COMMENT '转出金额',
  `deposited` decimal(30,10) DEFAULT NULL COMMENT '入金',
  `withdrawn` decimal(30,10) DEFAULT NULL COMMENT '出金',
  `realised_pnl` decimal(30,10) DEFAULT NULL COMMENT '已实现盈亏',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间戳',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_t_account_capital` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10329 DEFAULT CHARSET=utf8 COMMENT='账户资金';

/*Table structure for table `t_api_key` */

DROP TABLE IF EXISTS `t_api_key`;

CREATE TABLE `t_api_key` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `user_id` varchar(20) DEFAULT NULL COMMENT '用户代码',
  `key_id` varchar(50) DEFAULT NULL COMMENT '秘钥ID',
  `key_type` varchar(1) DEFAULT NULL COMMENT '秘钥生成类型1，系统自动生成 2 用户手工创建',
  `key_name` varchar(50) DEFAULT NULL COMMENT '秘钥名称',
  `cidr` varchar(50) DEFAULT NULL COMMENT 'CIDR 限制',
  `key_right` varchar(3) DEFAULT NULL COMMENT '权限类型 1 阅读，2委托 3 取消委托 4 提现',
  `secret_key` varchar(512) DEFAULT NULL COMMENT '秘钥',
  `is_active` varchar(1) DEFAULT NULL COMMENT '是否活跃 0 停用 1 启用',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10353 DEFAULT CHARSET=utf8 COMMENT='API秘钥';

/*Table structure for table `t_black_list` */

DROP TABLE IF EXISTS `t_black_list`;

CREATE TABLE `t_black_list` (
  `telephone` varchar(20) DEFAULT NULL COMMENT '电话号码',
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `country_code` varchar(4) DEFAULT NULL COMMENT '国家代码',
  `email` varchar(50) DEFAULT NULL COMMENT '电子邮件',
  `identification_type` varchar(2) DEFAULT NULL COMMENT '证件类型',
  `identification_id` varchar(50) DEFAULT NULL COMMENT '证件代码',
  `operate_time` bigint(13) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='开户黑名单';

/*Table structure for table `t_clear_fund_rate` */

DROP TABLE IF EXISTS `t_clear_fund_rate`;

CREATE TABLE `t_clear_fund_rate` (
  `id` bigint(20) NOT NULL COMMENT 'id自增长序列',
  `instrumentid` varchar(30) NOT NULL COMMENT '合约代码',
  `fund_rate` decimal(30,10) DEFAULT NULL COMMENT '资金费率',
  `fund_rate_limit` decimal(30,10) DEFAULT NULL COMMENT '资金费率上限',
  `rate_avg` decimal(30,10) DEFAULT NULL COMMENT '加权利率',
  `premium_price_avg` decimal(30,10) DEFAULT NULL COMMENT '加权溢价指数',
  `oper_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  `oper_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `recheck_oper_id` varchar(20) DEFAULT NULL COMMENT '复核员',
  `recheck_oper_time` bigint(20) DEFAULT NULL COMMENT '复核时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资金费率';

/*Table structure for table `t_clear_premium_price` */

DROP TABLE IF EXISTS `t_clear_premium_price`;

CREATE TABLE `t_clear_premium_price` (
  `id` bigint(20) NOT NULL COMMENT 'id自增长序列',
  `instrument_id` varchar(30) NOT NULL COMMENT '合约代码',
  `basis_rate` decimal(30,10) DEFAULT NULL COMMENT '基准利率',
  `quote_rate` decimal(30,10) DEFAULT NULL COMMENT '计价利率',
  `rate` decimal(30,10) DEFAULT NULL COMMENT '利率',
  `wap_buy` decimal(30,10) DEFAULT NULL COMMENT '深度加权买家',
  `wap_sell` decimal(30,10) DEFAULT NULL COMMENT '深度加权卖家',
  `fair_price` decimal(30,10) DEFAULT NULL COMMENT '合理标记价格',
  `premium_price` decimal(30,10) DEFAULT NULL COMMENT '溢价指数',
  `oper_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  `oper_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `recheck_oper_id` varchar(20) DEFAULT NULL COMMENT '复核员',
  `recheck_oper_time` bigint(20) DEFAULT NULL COMMENT '复核时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='清算汇率和溢价指数';

/*Table structure for table `t_currency` */

DROP TABLE IF EXISTS `t_currency`;

CREATE TABLE `t_currency` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id自增长序列',
  `currency` varchar(10) DEFAULT NULL COMMENT '币种代码',
  `currency_name` varchar(100) DEFAULT NULL COMMENT '币种名称',
  `digits` tinyint(3) DEFAULT NULL COMMENT '小数位数',
  `min_withdraw_tick` decimal(30,10) DEFAULT NULL COMMENT '最小提现单位',
  `min_withdraw_amount` decimal(30,10) DEFAULT NULL COMMENT '最小提现金额',
  `recommend_withdraw_fee` decimal(30,10) DEFAULT NULL COMMENT '推荐手续费',
  `min_withdraw_fee` decimal(30,10) DEFAULT NULL COMMENT '最小提现手续费',
  `block_chain_address` varchar(100) DEFAULT NULL COMMENT '区块链地址',
  `oper_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  `oper_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `recheck_oper_id` varchar(20) DEFAULT NULL COMMENT '复核员',
  `recheck_oper_time` bigint(20) DEFAULT NULL COMMENT '复核时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pk_t_currency` (`currency`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='币种';

/*Table structure for table `t_deliv_series` */

DROP TABLE IF EXISTS `t_deliv_series`;

CREATE TABLE `t_deliv_series` (
  `id` bigint(20) NOT NULL COMMENT 'id自增长序列',
  `product_id` varchar(30) NOT NULL COMMENT '产品代码',
  `deliv_series_id` varchar(50) NOT NULL COMMENT '到期序列代码',
  `deliv_series_no` decimal(13,0) NOT NULL COMMENT '到期序列编号',
  `deliv_series_type` tinyint(4) NOT NULL COMMENT '到期序列类型:(t_dict-5023) 1,周 2,近月 3,季月',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='到期序列';

/*Table structure for table `t_dict` */

DROP TABLE IF EXISTS `t_dict`;

CREATE TABLE `t_dict` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `dict_class` varchar(30) NOT NULL DEFAULT '' COMMENT '字典项 ',
  `dict_value` varchar(4) NOT NULL COMMENT '字典值 ',
  `dict_name_cn` varchar(50) DEFAULT NULL COMMENT '中文描述',
  `dict_name_en` varchar(50) DEFAULT NULL COMMENT '英文描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=978 DEFAULT CHARSET=utf8 COMMENT='数据字典';

/*Table structure for table `t_garbage_user` */

DROP TABLE IF EXISTS `t_garbage_user`;

CREATE TABLE `t_garbage_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `product_id` varchar(30) DEFAULT NULL COMMENT '产品代码',
  `instrumentid` varchar(30) DEFAULT NULL COMMENT '合约代码',
  `user_id` varchar(20) DEFAULT NULL COMMENT '用户代码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='垃圾用户';

/*Table structure for table `t_identification_type` */

DROP TABLE IF EXISTS `t_identification_type`;

CREATE TABLE `t_identification_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `identification_type` varchar(2) DEFAULT NULL COMMENT '证件类型',
  `identification_name` varchar(50) DEFAULT NULL COMMENT '证件名称',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='证件类型管理';

/*Table structure for table `t_index_price` */

DROP TABLE IF EXISTS `t_index_price`;

CREATE TABLE `t_index_price` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id自增长序列',
  `underlying_id` varchar(30) DEFAULT NULL COMMENT '标的物代码',
  `index_price` decimal(30,10) unsigned DEFAULT NULL COMMENT '指数价格',
  `price_time` bigint(20) unsigned DEFAULT NULL COMMENT '价格时间',
  `crash_times` int(10) unsigned DEFAULT NULL COMMENT '中断次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_t_index_price` (`underlying_id`,`price_time`)
) ENGINE=InnoDB AUTO_INCREMENT=420 DEFAULT CHARSET=utf8 COMMENT='标的指数价格';

/*Table structure for table `t_instrument` */

DROP TABLE IF EXISTS `t_instrument`;

CREATE TABLE `t_instrument` (
  `id` bigint(20) NOT NULL COMMENT 'id自增长序列',
  `instrumentid` varchar(30) NOT NULL COMMENT '合约代码',
  `instrument_name` varchar(100) NOT NULL COMMENT '合约名称',
  `product_id` varchar(30) NOT NULL COMMENT '产品代码',
  `product_type` varchar(1) NOT NULL COMMENT '产品类别:(t_dict-0034) 1,期货 2,期权',
  `underlying_id` varchar(30) DEFAULT NULL COMMENT '标的',
  `cycle_type` varchar(1) NOT NULL COMMENT '周期类型:1,周 2,月 3,永续',
  `contract_size` decimal(30,10) DEFAULT NULL COMMENT '合约面值',
  `tick` decimal(30,10) NOT NULL COMMENT 'Tick值',
  `trade_mode` varchar(1) NOT NULL COMMENT '交易模式:1,永续 2,定期',
  `reverse` varchar(1) DEFAULT NULL COMMENT '反向:0,正向 1,反向',
  `quote_currency` varchar(10) NOT NULL COMMENT '计价币种',
  `clear_currency` varchar(10) NOT NULL COMMENT '结算币种',
  `price_source` char(10) DEFAULT NULL COMMENT '成交价来源: 1,三价取中 2,对手价',
  `max_order_price` decimal(30,10) DEFAULT NULL COMMENT '最大委托价格',
  `funding_times` tinyint(3) DEFAULT NULL COMMENT '资金费用计算次数',
  `create_date` varchar(8) NOT NULL COMMENT '创建日',
  `open_date` varchar(8) NOT NULL COMMENT '上市日',
  `open_date_expr` varchar(100) DEFAULT NULL COMMENT '上市日表达式',
  `volume_multiple` int(13) NOT NULL COMMENT '合约乘数',
  `end_trading_day` varchar(8) DEFAULT NULL COMMENT '最后交易日',
  `instrument_status` varchar(1) NOT NULL COMMENT '合约状态:(t_dict-0039) 0,未上市 1,上市 2,停牌 3,下市 4,终止',
  `end_trading_day_expr` varchar(100) DEFAULT NULL COMMENT '最后交易日表达式',
  `expire_date` varchar(8) DEFAULT NULL COMMENT '到期日',
  `expire_date_expr` varchar(100) DEFAULT NULL COMMENT '到期日表达式',
  `start_deliv_date` varchar(8) DEFAULT NULL COMMENT '开始交割日',
  `start_deliv_date_expr` varchar(100) DEFAULT NULL COMMENT '开始交割日表达式',
  `end_deliv_date` varchar(8) DEFAULT NULL COMMENT '最后交割日',
  `end_deliv_date_expr` varchar(100) DEFAULT NULL COMMENT '最后交割日表达式',
  `open_year_month` varchar(8) NOT NULL COMMENT '上市年月',
  `deliv_year_month` varchar(8) DEFAULT NULL COMMENT '交割年月',
  `option_series_id` varchar(30) DEFAULT NULL COMMENT '期权系列代码',
  `option_type` varchar(1) DEFAULT NULL COMMENT '期权类型:(t_dict-0814)  0,期货 1,看涨期权 2,看跌期权',
  `strike_price` decimal(30,10) DEFAULT NULL COMMENT '期权执行价',
  `is_auto` varchar(1) DEFAULT NULL COMMENT '是否自动暂停:(t_dict-0001) 0,否 1,是',
  `is_confirm_needed` varchar(1) DEFAULT NULL COMMENT '暂停是否需要确认:(t_dict-0001) 0,否 1,是',
  `no_trade_days` int(13) DEFAULT NULL COMMENT '无交易暂停天数,null表示表示不判断该暂停规则',
  `qty_unit` int(13) NOT NULL COMMENT '报价数量单位(与合约乘数配合使用)',
  `basis_rate` decimal(30,10) DEFAULT NULL COMMENT '基准利率',
  `quote_rate` decimal(30,10) DEFAULT NULL COMMENT '计价利率',
  `basis_price_type` varchar(1) NOT NULL COMMENT '挂牌基准价定义方式:(t_dict-5024) 1上一合约结算价;2上一合约收盘价;3理论价',
  `basis_price` decimal(30,10) DEFAULT NULL COMMENT '挂牌基准价',
  `position_type` varchar(1) NOT NULL COMMENT '持仓类型:(t_dict-5056) 1净持仓,2综合持仓',
  `deliv_mode` varchar(1) DEFAULT NULL COMMENT '交割方式:(t_dict-5006) 1,现金 2,实物',
  `deliv_type` varchar(1) DEFAULT NULL COMMENT '交割类型:(t_dict-0604) 0,滚动交割 1,集中交割 2,混合交割',
  `exec_type` varchar(1) DEFAULT NULL COMMENT '行权类型:(t_dict-5007) 0,美式 1,欧式',
  `trading_day_type` varchar(1) DEFAULT NULL COMMENT '交易日类型:(t_dict-5047) 0,非交易日 1,首交易日 2,普通交易日 3,最后交易日',
  `oper_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  `oper_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `recheck_oper_id` varchar(20) DEFAULT NULL COMMENT '复核员',
  `recheck_oper_time` bigint(20) DEFAULT NULL COMMENT '复核时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ak_uk_t_instrument` (`instrumentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合约';

/*Table structure for table `t_invitation_detail` */

DROP TABLE IF EXISTS `t_invitation_detail`;

CREATE TABLE `t_invitation_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `user_id` varchar(30) DEFAULT NULL COMMENT '邀请人用户代码',
  `beuser_id` varchar(30) DEFAULT NULL COMMENT '被邀请人用户代码',
  `invitation_level` varchar(3) DEFAULT NULL COMMENT '邀请人级别 1 一级 2 二级 3三级 4四级',
  `reward_date` bigint(20) DEFAULT NULL COMMENT '邀请日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COMMENT='邀请明细';

/*Table structure for table `t_invitation_rake_back_action` */

DROP TABLE IF EXISTS `t_invitation_rake_back_action`;

CREATE TABLE `t_invitation_rake_back_action` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `user_id` varchar(30) DEFAULT NULL COMMENT '邀请人用户代码',
  `beuser_id` varchar(30) DEFAULT NULL COMMENT '被邀请人用户代码',
  `rake_back_type` varchar(1) DEFAULT NULL COMMENT '返佣类别  1 邀请返币 2 交易返币',
  `arithmetic` varchar(1) NOT NULL COMMENT '算法类别 0 绝对值 1 百分比',
  `invitation_level` varchar(1) DEFAULT NULL COMMENT '邀请人级别 1 一级 2 二级 3三级 4四级',
  `invitation_rate` decimal(30,10) DEFAULT NULL COMMENT '返币费率',
  `invitation_value` decimal(30,10) NOT NULL COMMENT '返币金额',
  `transaction_time` bigint(20) NOT NULL COMMENT '流水时间',
  `currency` varchar(10) NOT NULL COMMENT '币种',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='返佣明细';

/*Table structure for table `t_invitation_set` */

DROP TABLE IF EXISTS `t_invitation_set`;

CREATE TABLE `t_invitation_set` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `invitation_type` varchar(1) DEFAULT NULL COMMENT '参数类别 0 注册送币 1 邀请一级返币 2 邀请二级返币 3邀请三级返币 4 邀请四级返币',
  `arithmetic` varchar(1) NOT NULL COMMENT '算法类别 0 绝对值 1 百分比',
  `invitation_value` decimal(30,10) NOT NULL COMMENT '返币数量',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  `currency` varchar(10) NOT NULL COMMENT '币种',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='返佣参数设置';

/*Table structure for table `t_invitation_trade_set` */

DROP TABLE IF EXISTS `t_invitation_trade_set`;

CREATE TABLE `t_invitation_trade_set` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `product_id` varchar(30) DEFAULT NULL COMMENT '产品代码',
  `instrumentid` varchar(30) DEFAULT NULL COMMENT '合约代码',
  `invitation_type` varchar(1) DEFAULT NULL COMMENT '参数类别  1 一级交易返币 2 二级交易返币 3三级交易返币 4 四级交易返币',
  `arithmetic` varchar(1) NOT NULL COMMENT '算法类别 0 绝对值 1 百分比',
  `max_trade_value` decimal(30,10) NOT NULL COMMENT '成交价值(范围最大)',
  `min_trade_value` decimal(30,10) NOT NULL COMMENT '成交价值(范围最小)',
  `invitation_value` decimal(30,10) NOT NULL COMMENT '返币数量',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='返佣参数设置';

/*Table structure for table `t_key_rigth_relation` */

DROP TABLE IF EXISTS `t_key_rigth_relation`;

CREATE TABLE `t_key_rigth_relation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `key_right` varchar(3) DEFAULT NULL COMMENT '权限类型',
  `request_path` varchar(50) DEFAULT NULL COMMENT '请求路径',
  `request_type` varchar(10) DEFAULT NULL COMMENT '请求类型  get post delete put  ',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='权限请求关系';

/*Table structure for table `t_level_type` */

DROP TABLE IF EXISTS `t_level_type`;

CREATE TABLE `t_level_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `level` varchar(20) DEFAULT NULL COMMENT '客户分类等级',
  `level_name` varchar(50) DEFAULT NULL COMMENT '客户分类名称',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='客户分类';

/*Table structure for table `t_operation_log` */

DROP TABLE IF EXISTS `t_operation_log`;

CREATE TABLE `t_operation_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `log_level` varchar(1) NOT NULL COMMENT '日志类型 1 成功 2 失败  3 其他 ',
  `oper_content` longtext COMMENT '操作内容 ',
  `oper_content_desc` longtext COMMENT '操作内容描述 ',
  `oper_func` varchar(200) DEFAULT NULL COMMENT '操作功能名称 ',
  `oper_func_desc` varchar(200) DEFAULT NULL COMMENT '操作功能名称描述 ',
  `oper_type` varchar(1) DEFAULT NULL COMMENT '操作类型 1  新增 2修改 3删除 4登录 5 登出 99 其他',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作人',
  `operator_ip` varchar(20) DEFAULT NULL COMMENT '操作人ip地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=341 DEFAULT CHARSET=utf8 COMMENT='系统操作日志';

/*Table structure for table `t_product` */

DROP TABLE IF EXISTS `t_product`;

CREATE TABLE `t_product` (
  `id` bigint(20) NOT NULL COMMENT 'id自增长序列',
  `product_id` varchar(30) NOT NULL COMMENT '产品代码',
  `product_name` varchar(100) NOT NULL COMMENT '产品名称',
  `underlying_id` varchar(30) NOT NULL COMMENT '标的代码',
  `product_type` varchar(1) NOT NULL COMMENT '产品类别:1,期货 2,期权',
  `currency` varchar(10) NOT NULL COMMENT '基础币种:XBT ETH等',
  `trade_mode` varchar(1) DEFAULT NULL COMMENT '交易模式:1,永续 2,定期反向',
  `quote_currency` varchar(10) NOT NULL COMMENT '计价币种',
  `clear_currency` varchar(10) NOT NULL COMMENT '结算币种',
  `deliv_series_num` decimal(13,0) NOT NULL COMMENT '到期序列数量',
  `cycle_type` varchar(1) NOT NULL COMMENT '周期类型:1,周 2,月 3,永续',
  `product_status` varchar(1) NOT NULL COMMENT '产品状态:1,待审核 2,未上市 3,上市 4,退市',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  `recheck_operate_time` bigint(20) DEFAULT NULL COMMENT '复核时间',
  `recheck_operator_id` varchar(20) DEFAULT NULL COMMENT '复核员',
  `match_rule` varchar(1) DEFAULT NULL COMMENT '撮合规则:(t_dict-5001)  0,价格优先时间优先 1,价格优先按比例分配',
  `price_limit_before_fuse` decimal(19,6) DEFAULT NULL COMMENT '熔断前涨跌停',
  `price_mode` varchar(1) DEFAULT NULL COMMENT '报价方式:(t_dict-5002)  0,价格 1,收益率 2,波动率',
  `market_id` varchar(30) DEFAULT NULL COMMENT '市场代码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='产品信息';

/*Table structure for table `t_risk_exchange_limit` */

DROP TABLE IF EXISTS `t_risk_exchange_limit`;

CREATE TABLE `t_risk_exchange_limit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `exchange_status` varchar(1) DEFAULT NULL COMMENT '交易所状态 1 交易中 2 只可撤单 3 停止交易 ',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='交易所状态管理';

/*Table structure for table `t_risk_index` */

DROP TABLE IF EXISTS `t_risk_index`;

CREATE TABLE `t_risk_index` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `warn_type` varchar(1) NOT NULL COMMENT '报警类型  1 发送短信 2 发送邮件',
  `risk_flag` varchar(1) DEFAULT NULL COMMENT '报警标识',
  `peek_value` decimal(4,3) DEFAULT NULL COMMENT '报警阈值',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `warn_level` varchar(1) DEFAULT NULL COMMENT '报警等级',
  `accounts` varchar(1000) DEFAULT NULL COMMENT '警报信息接收人',
  `interval_time` bigint(20) DEFAULT NULL COMMENT '报警间隔时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='报警记录';

/*Table structure for table `t_risk_leverage_point_detail` */

DROP TABLE IF EXISTS `t_risk_leverage_point_detail`;

CREATE TABLE `t_risk_leverage_point_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增长序列号',
  `product_id` varchar(30) NOT NULL COMMENT '品种代码',
  `risk_limit` decimal(30,10) NOT NULL COMMENT '风险限额',
  `leverage` decimal(10,2) NOT NULL COMMENT '杠杆',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='杠杆点分布明细\n初始化配置';

/*Table structure for table `t_risk_limit` */

DROP TABLE IF EXISTS `t_risk_limit`;

CREATE TABLE `t_risk_limit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增长序列号',
  `product_id` varchar(30) NOT NULL COMMENT '品种代码',
  `instrument_id` varchar(30) DEFAULT NULL COMMENT '合约代码',
  `level` varchar(10) DEFAULT NULL COMMENT '客户分类代码',
  `base_risk_limit` decimal(30,10) DEFAULT NULL COMMENT '最低风险限额',
  `step_risk_limit` decimal(30,10) DEFAULT NULL COMMENT '风险限额递增量',
  `step_times` tinyint(3) DEFAULT NULL COMMENT '递增次数',
  `base_maint_margin` decimal(5,4) DEFAULT NULL COMMENT '基础维持保证金',
  `base_init_margin` decimal(5,4) DEFAULT NULL COMMENT '基础起始保证金',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作人',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='风险限额';

/*Table structure for table `t_risk_mandatory_reduction_set` */

DROP TABLE IF EXISTS `t_risk_mandatory_reduction_set`;

CREATE TABLE `t_risk_mandatory_reduction_set` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `product_id` varchar(30) NOT NULL COMMENT '产品代码',
  `instrument_id` varchar(30) NOT NULL COMMENT '合约代码',
  `reduction_price_ladder` varchar(30) NOT NULL COMMENT '强平价格阶梯',
  `max_market_fluctuate_tolerate` decimal(19,6) NOT NULL COMMENT '行情波动最大容忍值',
  `max_order_time_tolerate` decimal(19,6) NOT NULL COMMENT '挂单时间最大容忍值',
  `amount` int(10) DEFAULT NULL COMMENT '每笔下单量',
  `interval` decimal(13,10) NOT NULL COMMENT '下单时间间隔',
  `compulsion_status` varchar(1) NOT NULL COMMENT '自动减仓状态:0,关闭 1 开启',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='强平参数设置';

/*Table structure for table `t_risk_trade_rigth_limit` */

DROP TABLE IF EXISTS `t_risk_trade_rigth_limit`;

CREATE TABLE `t_risk_trade_rigth_limit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `product_id` varchar(30) DEFAULT NULL COMMENT '产品代码',
  `instrument_id` varchar(30) DEFAULT NULL COMMENT '合约代码',
  `user_id` varchar(20) DEFAULT NULL COMMENT '用户代码',
  `forbid_type` varchar(1) DEFAULT NULL COMMENT ' 交易权限限制类型 0 禁止开仓 1 禁止交易 ',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='交易权限设置';

/*Table structure for table `t_risk_withdraw_limit` */

DROP TABLE IF EXISTS `t_risk_withdraw_limit`;

CREATE TABLE `t_risk_withdraw_limit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `forbid_out` varchar(1) DEFAULT NULL COMMENT '禁止转出 0 禁止转出 1 允许转出',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='出金权限开关';

/*Table structure for table `t_risk_withdraw_rigth_set` */

DROP TABLE IF EXISTS `t_risk_withdraw_rigth_set`;

CREATE TABLE `t_risk_withdraw_rigth_set` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `currency` varchar(10) DEFAULT NULL COMMENT '币种',
  `user_id` varchar(20) DEFAULT NULL COMMENT '用户代码',
  `forbid_type` varchar(1) DEFAULT NULL COMMENT ' 出金权限限制类型 0 禁止转出 ',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='出金权限设置';

/*Table structure for table `t_system_config` */

DROP TABLE IF EXISTS `t_system_config`;

CREATE TABLE `t_system_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `config_key` varchar(30) DEFAULT NULL COMMENT '系统设置项',
  `config_value` varchar(30) DEFAULT NULL COMMENT '系统设置值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='系统设置';

/*Table structure for table `t_tpl_instrument_create` */

DROP TABLE IF EXISTS `t_tpl_instrument_create`;

CREATE TABLE `t_tpl_instrument_create` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `product_id` varchar(30) NOT NULL COMMENT '产品代码',
  `instrument_id_expr` varchar(50) NOT NULL COMMENT '合约代码规则(期货期权共用)',
  `instrument_name_expr` varchar(50) NOT NULL COMMENT '合约名称规则(期货期权共用)',
  `create_date_expr` varchar(100) NOT NULL COMMENT '创建日表达式',
  `open_date_expr` varchar(100) NOT NULL COMMENT '上市日表达式',
  `end_trading_day_expr` varchar(100) NOT NULL COMMENT '最后交易日表达式',
  `expire_date_expr` varchar(100) NOT NULL COMMENT '到期日表达式',
  `contract_size` decimal(30,10) DEFAULT NULL COMMENT '合约面值',
  `volume_multiple` int(13) DEFAULT NULL COMMENT '合约乘数',
  `tick` decimal(30,10) DEFAULT NULL COMMENT 'Tick值',
  `basis_price_type` varchar(1) NOT NULL COMMENT '挂牌基准价定义方式:(t_dict-5024) 1上一合约结算价;2上一合约收盘价;3理论价',
  `position_type` varchar(1) NOT NULL COMMENT '持仓类型:(t_dict-5056) 1净持仓,2综合持仓',
  `deliv_mode` varchar(1) NOT NULL COMMENT '交割方式:(t_dict-5006) 1,现金 2,实物',
  `deliv_type` varchar(1) DEFAULT NULL COMMENT '交割类型:(t_dict-0604) 0,滚动交割 1,集中交割 2,混合交割',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  `operate_time` bigint(13) DEFAULT NULL COMMENT '操作时间',
  `recheck_operator_id` varchar(20) DEFAULT NULL COMMENT '复核员',
  `recheck_operate_time` bigint(20) DEFAULT NULL COMMENT '复核时间',
  `start_deliv_date_expr` varchar(100) DEFAULT NULL COMMENT '开始交割日表达式',
  `end_deliv_date_expr` varchar(100) DEFAULT NULL COMMENT '最后交割日表达式',
  `option_series_id_expr` varchar(50) DEFAULT NULL COMMENT '期权系列代码规则',
  `option_series_name_expr` varchar(50) DEFAULT NULL COMMENT '期权系列名称规则',
  `exec_type` varchar(1) DEFAULT NULL COMMENT '行权类型:(t_dict-5007) 0,美式 1,欧式',
  `is_auto` varchar(1) DEFAULT NULL COMMENT '是否自动暂停:(t_dict-0001) 0,否 1,是',
  `is_confirm_needed` varchar(1) DEFAULT NULL COMMENT '暂停是否需要确认:(t_dict-0001) 0,否 1,是',
  `no_fluctuated_days` int(13) DEFAULT NULL COMMENT '终止波动生成天数',
  `deliv_not_allowed_pro_id` varchar(30) DEFAULT NULL COMMENT '不允许同时交割的月产品代码',
  `qty_unit` int(13) DEFAULT NULL COMMENT '报价数量单位(与合约乘数配合使用)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合约创建参数模板';

/*Table structure for table `t_trade` */

DROP TABLE IF EXISTS `t_trade`;

CREATE TABLE `t_trade` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `trade_id` varchar(30) NOT NULL COMMENT '成交编号',
  `trade_match_id` varchar(30) NOT NULL COMMENT '成交撮合编号',
  `user_id` varchar(30) NOT NULL COMMENT '客户代码',
  `instrument_id` varchar(30) NOT NULL COMMENT '合约代码',
  `direction` varchar(1) NOT NULL COMMENT '买卖方向',
  `price` decimal(30,10) NOT NULL COMMENT '价格',
  `volume` decimal(30,10) NOT NULL COMMENT '数量',
  `fee` decimal(30,10) DEFAULT NULL COMMENT '手续费',
  `close_profit` decimal(30,10) DEFAULT NULL COMMENT '平仓盈亏',
  `order_sys_id` varchar(30) DEFAULT NULL COMMENT '报单编号',
  `order_local_id` varchar(30) DEFAULT NULL COMMENT '本地报单编号',
  `price_source` varchar(1) NOT NULL COMMENT '成交价来源',
  `trade_money` decimal(30,10) DEFAULT NULL COMMENT '成交金额',
  `home_notional` decimal(30,10) DEFAULT NULL COMMENT '本地货币价值',
  `foreign_notional` decimal(30,10) DEFAULT NULL COMMENT '外地货币价值',
  `trade_time` bigint(20) NOT NULL COMMENT '成交时间',
  `tick_direction` varchar(1) DEFAULT NULL COMMENT '价格升跌方向',
  `trade_type` varchar(1) NOT NULL COMMENT '成交类型',
  `account_id` varchar(30) DEFAULT NULL COMMENT '资金账号',
  `business_unit` varchar(30) DEFAULT NULL COMMENT '业务单元',
  `use_margin` varchar(40) DEFAULT NULL COMMENT '释放保证金',
  `settlement_group_id` varchar(8) DEFAULT NULL COMMENT '结算组代码',
  `participant_id` varchar(10) DEFAULT NULL COMMENT '会员代码',
  `trading_role` varchar(1) DEFAULT NULL COMMENT '交易角色',
  `offset_flag` varchar(1) DEFAULT NULL COMMENT '开平标志',
  `hedge_flag` varchar(1) DEFAULT NULL COMMENT '投机套保标志',
  `trade_user_id` varchar(30) DEFAULT NULL COMMENT '交易用户代码(席位)',
  `clearing_part_id` varchar(10) DEFAULT NULL COMMENT '结算会员代码',
  `calendar_date` varchar(8) DEFAULT NULL COMMENT '自然日',
  `trade_millisec` tinyint(3) DEFAULT NULL COMMENT '报单毫秒',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tradeid` (`trade_id`,`direction`),
  UNIQUE KEY `uk_tradematchid` (`trade_match_id`,`order_sys_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='成交';

/*Table structure for table `t_trade_fee_set` */

DROP TABLE IF EXISTS `t_trade_fee_set`;

CREATE TABLE `t_trade_fee_set` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增长序列号',
  `product_id` varchar(30) NOT NULL COMMENT '品种代码',
  `instrument_id` varchar(30) DEFAULT NULL COMMENT '合约代码',
  `user_group_id` varchar(10) DEFAULT NULL COMMENT '客户分类代码',
  `fee_mode` varchar(1) NOT NULL COMMENT '手续费算法：1,百分比 2,绝对值',
  `maker_fee_rate` decimal(30,10) NOT NULL COMMENT 'maker费率',
  `taker_fee_rate` decimal(30,10) NOT NULL COMMENT 'taker费率',
  `maker_fee_amt` decimal(30,10) NOT NULL COMMENT 'maker每手费用',
  `taker_fee_amt` decimal(30,10) NOT NULL COMMENT 'taker每手费用',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='交易手续费';

/*Table structure for table `t_trade_user` */

DROP TABLE IF EXISTS `t_trade_user`;

CREATE TABLE `t_trade_user` (
  `registered_rake_back` varchar(30) DEFAULT NULL COMMENT '注册返币',
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `application_id` varchar(20) DEFAULT NULL COMMENT '注册申请号',
  `user_id` varchar(20) DEFAULT NULL COMMENT '用户代码',
  `user_name` varchar(50) DEFAULT NULL COMMENT '客户名称',
  `country_code` int(10) DEFAULT NULL COMMENT '国家代码',
  `email` varchar(50) DEFAULT NULL COMMENT '电子邮件',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `invite_code` varchar(20) DEFAULT NULL COMMENT '客户邀请码',
  `account_password` varchar(50) DEFAULT NULL COMMENT '资金密码',
  `identification_type` varchar(1) DEFAULT NULL COMMENT '证件类型',
  `identification_id` varchar(50) DEFAULT NULL COMMENT '证件代码',
  `apply_status` varchar(3) DEFAULT NULL COMMENT '客户状态0 注册,1邮箱验证已打开, 2 证件审核已提交, 3 证件审核已驳回, 4证件审核已通过,5两步验证已通过，6资金密码已设置 ,7 正常 8 冻结 9 上场中 10 已上场',
  `level` varchar(20) DEFAULT NULL COMMENT '客户分类等级',
  `google_status` varchar(1) DEFAULT NULL COMMENT 'google验证状态(0:关闭，1：打开)',
  `secret` varchar(50) DEFAULT NULL COMMENT 'google验证码',
  `message_switch` varchar(1) DEFAULT '1' COMMENT '消息开关  0:关；1:开',
  `telephone` varchar(30) DEFAULT NULL COMMENT '联系电话',
  `id_back_photo` varchar(500) DEFAULT NULL COMMENT '证件反面照片',
  `id_front_photo` varchar(500) DEFAULT NULL COMMENT '证件正面照片',
  `self_card_photo` varchar(500) DEFAULT NULL COMMENT '手持证件照片',
  `client_channel` varchar(1) DEFAULT NULL COMMENT '开户渠道',
  `register_time` bigint(20) DEFAULT NULL COMMENT '注册时间',
  `recheck_time` bigint(20) DEFAULT NULL COMMENT '复核时间',
  `rechecker_id` varchar(100) DEFAULT NULL COMMENT '复核员',
  `reject_remark` varchar(255) DEFAULT NULL COMMENT '驳回备注',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `user_type` varchar(2) DEFAULT NULL COMMENT '用户类别：1,普通用户 2,爆仓用户 3, 手续费用户',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10332 DEFAULT CHARSET=utf8 COMMENT='用户信息';

/*Table structure for table `t_transaction_history` */

DROP TABLE IF EXISTS `t_transaction_history`;

CREATE TABLE `t_transaction_history` (
  `id` bigint(20) NOT NULL COMMENT 'id自增长序列',
  `account_id` varchar(50) NOT NULL COMMENT '资金账号',
  `user_id` varchar(30) DEFAULT NULL COMMENT '用户代码',
  `currency` varchar(10) NOT NULL COMMENT '币种',
  `transaction_type` varchar(3) NOT NULL COMMENT '流水类型',
  `amount` decimal(30,10) NOT NULL COMMENT '流水金额',
  `address` varchar(100) DEFAULT NULL COMMENT '地址',
  `balance` decimal(30,10) NOT NULL COMMENT '账户余额',
  `transaction_time` bigint(20) NOT NULL COMMENT '流水时间',
  `text` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资金流水';

/*Table structure for table `t_underlying` */

DROP TABLE IF EXISTS `t_underlying`;

CREATE TABLE `t_underlying` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id自增长序列',
  `underlying_id` varchar(30) DEFAULT NULL COMMENT '标的物代码',
  `underlying_name` varchar(100) DEFAULT NULL COMMENT '标的物名称',
  `underlying_type` varchar(1) DEFAULT NULL COMMENT '标的物类型',
  `oper_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  `oper_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `recheck_oper_id` varchar(20) DEFAULT NULL COMMENT '复核员',
  `recheck_oper_time` bigint(20) DEFAULT NULL COMMENT '复核时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_t_underlying` (`underlying_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='标的';

/*Table structure for table `t_underlying_detail` */

DROP TABLE IF EXISTS `t_underlying_detail`;

CREATE TABLE `t_underlying_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id自增长序列',
  `underlying_id` varchar(30) DEFAULT NULL COMMENT '标的物代码',
  `exch_id` varchar(30) DEFAULT NULL COMMENT '交易所代码',
  `product_id` varchar(30) DEFAULT NULL COMMENT '品种代码',
  `weight` decimal(5,4) DEFAULT NULL COMMENT '权重',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_t_underlying_detail` (`underlying_id`,`exch_id`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='标的物指数';

/*Table structure for table `t_underlying_prices` */

DROP TABLE IF EXISTS `t_underlying_prices`;

CREATE TABLE `t_underlying_prices` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id自增长序列',
  `underlying_id` varchar(30) DEFAULT NULL COMMENT '标的物代码',
  `exch_id` varchar(30) DEFAULT NULL COMMENT '交易所代码',
  `product_id` varchar(30) DEFAULT NULL COMMENT '品种代码',
  `weight` decimal(5,4) DEFAULT NULL COMMENT '权重',
  `spot_price` decimal(30,10) DEFAULT NULL COMMENT '现货价格',
  `ticker_time` bigint(20) DEFAULT NULL COMMENT '成交时间',
  `price_time` bigint(20) DEFAULT NULL COMMENT '价格时间',
  `crash_times` int(10) unsigned DEFAULT '0' COMMENT '中断次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_t_underlying_prices` (`underlying_id`,`exch_id`,`product_id`,`price_time`)
) ENGINE=InnoDB AUTO_INCREMENT=944 DEFAULT CHARSET=utf8 COMMENT='标的依赖价格';

/*Table structure for table `t_wallet_transaction_history` */

DROP TABLE IF EXISTS `t_wallet_transaction_history`;

CREATE TABLE `t_wallet_transaction_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `transaction_id` varchar(100) NOT NULL COMMENT '流水号',
  `user_id` varchar(20) NOT NULL COMMENT '用户代码',
  `currency` varchar(10) DEFAULT NULL COMMENT '币种代码',
  `amount` decimal(30,0) NOT NULL COMMENT '流水金额',
  `withdraw_fee` decimal(30,0) DEFAULT NULL COMMENT '提现费用',
  `address` varchar(100) DEFAULT NULL COMMENT '地址',
  `transaction_type` varchar(3) DEFAULT NULL COMMENT '流水类型 1 充值 2提现',
  `transaction_status` varchar(3) DEFAULT NULL COMMENT '流水状态 1待确认 , 2 已完成 ',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='充提流水（对接钱包）';

/*Table structure for table `t_wallet_user_address` */

DROP TABLE IF EXISTS `t_wallet_user_address`;

CREATE TABLE `t_wallet_user_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `user_id` varchar(20) DEFAULT NULL COMMENT '用户代码',
  `address` varchar(100) DEFAULT NULL COMMENT '用户充值地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='用户充值地址';

/*Table structure for table `t_warn_garbage_user_set` */

DROP TABLE IF EXISTS `t_warn_garbage_user_set`;

CREATE TABLE `t_warn_garbage_user_set` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `amount` int(10) DEFAULT NULL COMMENT '数量',
  `value` decimal(13,10) NOT NULL COMMENT '价值',
  `max_amount` int(10) DEFAULT NULL COMMENT '权限限制的最大垃圾委托数量',
  `min_value` decimal(13,10) NOT NULL COMMENT '定义垃圾委托最小价值',
  `forbid_type` varchar(1) DEFAULT NULL COMMENT ' 交易权限限制类型 0 禁止开仓 1 禁止交易 ',
  `warn_type` varchar(1) DEFAULT NULL COMMENT ' 预警类型  0 发送邮件 1 发送短信 ',
  `operate_time` bigint(20) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='垃圾委托用户参数设置';

/*Table structure for table `t_warn_result` */

DROP TABLE IF EXISTS `t_warn_result`;

CREATE TABLE `t_warn_result` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `risk_id` varchar(20) NOT NULL COMMENT '预警ID',
  `warn_level` varchar(1) DEFAULT NULL COMMENT '报警等级',
  `warn_type` varchar(1) NOT NULL COMMENT '报警类型  1 发送短信 2发送邮件',
  `warn_content` varchar(1000) DEFAULT NULL COMMENT '报警内容',
  `accounts` varchar(1000) NOT NULL COMMENT '警报信息接收人',
  `operate_time` bigint(20) NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='报警记录';

/*Table structure for table `t_withdraw` */

DROP TABLE IF EXISTS `t_withdraw`;

CREATE TABLE `t_withdraw` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID自增长序列',
  `currency` varchar(10) DEFAULT NULL COMMENT '币种代码',
  `user_id` varchar(20) DEFAULT NULL COMMENT '用户代码',
  `amount` decimal(30,0) NOT NULL COMMENT '流水金额',
  `address` varchar(100) DEFAULT NULL COMMENT '提现地址',
  `withdraw_fee` decimal(30,0) NOT NULL COMMENT '提现费用',
  `withdraw_status` varchar(3) DEFAULT NULL COMMENT '提现状态 0 提现申请提交,1 提现申请已拒绝 , 2 提现申请已通过 ',
  `check_time` bigint(20) DEFAULT NULL COMMENT '审核时间',
  `checker_id` varchar(100) DEFAULT NULL COMMENT '审核员',
  `reject_remark` varchar(255) DEFAULT NULL COMMENT '驳回备注',
  `operate_time` bigint(13) DEFAULT NULL COMMENT '操作时间',
  `operator_id` varchar(20) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='提现申请';

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;