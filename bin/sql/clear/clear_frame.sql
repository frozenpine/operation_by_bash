/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 5.7.25 : Database - clear
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`clear` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `clear`;

/*Table structure for table `t_account` */

DROP TABLE IF EXISTS `t_account`;

CREATE TABLE `t_account` (
  `account_id` bigint(20) NOT NULL COMMENT '资金账号',
  `currency` varchar(10) NOT NULL COMMENT '币种',
  `client_id` varchar(30) NOT NULL COMMENT '用户代码',
  `prev_wallet_balance` decimal(30,10) NOT NULL COMMENT '上日钱包余额',
  `wallet_balance` decimal(30,10) NOT NULL COMMENT '钱包余额',
  `availilable` decimal(30,10) NOT NULL COMMENT '可用余额',
  `margin_balance` decimal(30,10) NOT NULL COMMENT '保证金余额',
  `frozen_margin` decimal(30,10) NOT NULL COMMENT '冻结保证金',
  `frozen_available` decimal(30,10) NOT NULL DEFAULT '0.0000000000',
  `current_margin` decimal(30,10) DEFAULT NULL COMMENT '占用保证金',
  `affiliate_payout` decimal(30,10) DEFAULT NULL,
  `withdraw` decimal(30,10) DEFAULT NULL COMMENT '出金',
  `deposit` decimal(30,10) DEFAULT NULL COMMENT '入金',
  `capital_fee` decimal(30,10) DEFAULT NULL COMMENT '资金费用',
  `realised_pnl` decimal(30,10) NOT NULL COMMENT '已实现盈亏',
  `unrealised_pnl` decimal(30,10) NOT NULL COMMENT '未实现盈亏',
  `no_filed_cnt` bigint(20) DEFAULT NULL,
  `sell_vol_sum` bigint(20) DEFAULT NULL,
  `buy_vol_sum` bigint(20) DEFAULT NULL,
  `sell_cost` decimal(30,10) DEFAULT NULL,
  `buy_cost` decimal(30,10) DEFAULT NULL,
  `transfer` decimal(30,10) DEFAULT NULL COMMENT '今日转账',
  `trading_day` varchar(30) NOT NULL,
  `settlement_id` bigint(20) NOT NULL COMMENT '结算编号',
  `commission` decimal(30,10) NOT NULL COMMENT '佣金',
  `kafka_partition` int(11) NOT NULL,
  `kafka_offset` bigint(20) DEFAULT NULL,
  `kafka_checkpoint` bigint(20) DEFAULT NULL,
  `update_time` bigint(30) DEFAULT NULL COMMENT '更新时间',
  `insert_time` bigint(30) DEFAULT NULL COMMENT '插入时间',
  PRIMARY KEY (`account_id`,`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_order_history` */

DROP TABLE IF EXISTS `t_order_history`;

CREATE TABLE `t_order_history` (
  `order_id` bigint(20) NOT NULL COMMENT '订单编号',
  `order_local_id` varchar(50) DEFAULT NULL COMMENT '本地报单编号',
  `client_id` varchar(30) NOT NULL COMMENT '客户代码',
  `bound_price` char(10) DEFAULT NULL COMMENT '约束价格',
  `stop_px` decimal(30,10) DEFAULT NULL COMMENT '止损价格',
  `open_volume` bigint(20) DEFAULT NULL,
  `each_fee` decimal(30,10) DEFAULT NULL COMMENT '每手冻结手续费',
  `each_margin` decimal(30,10) DEFAULT NULL COMMENT '每手冻结保证金',
  `trading_day` varchar(30) DEFAULT NULL,
  `account_id` bigint(20) DEFAULT NULL COMMENT '资金账号',
  `instrument_id` varchar(30) NOT NULL COMMENT '合约代码',
  `direction` varchar(4) NOT NULL COMMENT '买卖方向:buy,sell',
  `offset_flag` varchar(30) DEFAULT NULL COMMENT '开平标志:open,close',
  `limit_price` decimal(30,10) DEFAULT NULL COMMENT '价格',
  `last_traded_volume` bigint(20) DEFAULT NULL COMMENT '最新成交量',
  `traded_volume` bigint(20) DEFAULT NULL COMMENT '成交量',
  `display_volume` bigint(20) DEFAULT NULL COMMENT '隐藏单显示数量',
  `order_volume` bigint(20) NOT NULL COMMENT '委托量',
  `time_in_force` varchar(20) DEFAULT NULL COMMENT 'GoodTillCancel(一直有效直至取消),ImmediateOrCancel(立刻成交或取消，能成交的部分成交，其余撤单),FillOrKill(全部成交或取消)',
  `order_time` bigint(20) DEFAULT NULL COMMENT '报单时间',
  `trade_time` bigint(20) DEFAULT NULL COMMENT '最后成交时间',
  `cancel_time` bigint(20) DEFAULT NULL COMMENT '撤销时间',
  `active_time` bigint(20) DEFAULT NULL COMMENT '激活时间',
  `peg_offset_value` decimal(30,10) DEFAULT NULL COMMENT '追踪价距',
  `peg_price_type` varchar(20) DEFAULT NULL COMMENT '价格偏差类型，Optional peg price type. Valid options: LastPeg, MidPricePeg, MarketPeg, PrimaryPeg, TrailingStopPeg.',
  `exec_inst` varchar(60) DEFAULT NULL COMMENT '执行说明',
  `order_status` varchar(20) NOT NULL COMMENT '报单状态:New(新建订单),PartiallyFilled(部分成交),Filled(完全成交),Canceled(撤单),Rejected(拒绝)',
  `force_close_reason` varchar(10) DEFAULT NULL COMMENT '强平原因',
  `stop_order_price_type` varchar(30) DEFAULT NULL COMMENT '条件单报单价格条件',
  `order_price_type` varchar(30) DEFAULT NULL COMMENT '报单价格条件',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `triggered` varchar(100) DEFAULT NULL COMMENT '触发状态；"",表示未触发；StopOrderTriggered已触发',
  `order_rej_reason` varchar(200) DEFAULT NULL COMMENT '订单拒绝原因',
  `settle_currency` varchar(10) NOT NULL COMMENT '结算币种',
  `currency` varchar(10) NOT NULL COMMENT '币种',
  `timestamp` bigint(20) NOT NULL,
  `transact_time` bigint(20) NOT NULL,
  `kafka_partition` int(11) NOT NULL,
  `leaves_qty` bigint(20) DEFAULT NULL,
  `cum_qty` bigint(20) DEFAULT NULL,
  `avg_px` decimal(30,10) DEFAULT NULL,
  `exec_cost` decimal(30,10) DEFAULT NULL,
  `exec_comm` decimal(30,10) DEFAULT NULL,
  `multiLeg_reporting_type` varchar(30) DEFAULT NULL,
  `modify_time` bigint(20) DEFAULT NULL,
  `order_type` int(11) DEFAULT NULL COMMENT 'OT_NORMAL(0,"用户下单"),\nOT_RISK(1,"风控爆仓下单"),\nOT_RISK_REDUCE(2,"风控爆仓减仓下单")',
  `order_source` int(11) DEFAULT NULL,
  `kafka_offset` bigint(20) DEFAULT NULL,
  `kafka_checkpoint` bigint(20) DEFAULT NULL,
  `bankrupt_price` decimal(30,10) DEFAULT NULL COMMENT '破产价格',
  `realisedPnl` decimal(30,10) DEFAULT NULL COMMENT '已实现盈亏',
  `openAvg` decimal(30,10) DEFAULT NULL COMMENT '开仓均价',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='已完成订单';

/*Table structure for table `t_position` */

DROP TABLE IF EXISTS `t_position`;

CREATE TABLE `t_position` (
  `client_id` varchar(30) NOT NULL COMMENT '用户代码',
  `instrument_id` varchar(30) NOT NULL COMMENT '合约代码',
  `direction` varchar(4) NOT NULL COMMENT '持仓多空方向',
  `position_margin_type` varchar(30) DEFAULT NULL,
  `currency` varchar(10) NOT NULL COMMENT '币种',
  `leverage_rate` decimal(30,10) DEFAULT NULL,
  `underlying` varchar(5) DEFAULT NULL,
  `quote_currency` varchar(5) DEFAULT NULL,
  `commission` decimal(30,10) DEFAULT NULL COMMENT '费率',
  `position` bigint(20) NOT NULL COMMENT '持仓',
  `position_avg_price` decimal(30,10) DEFAULT NULL,
  `open_cost` decimal(30,10) NOT NULL COMMENT '开仓成本',
  `position_cost` decimal(30,10) NOT NULL COMMENT '持仓成本',
  `current_comm` decimal(30,10) NOT NULL COMMENT '当前费用',
  `cross_margin` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否使用全仓保证金',
  `position_margin` decimal(10,2) DEFAULT NULL,
  `leverage` decimal(10,2) DEFAULT NULL COMMENT '杠杆',
  `risk_limit` decimal(30,10) DEFAULT NULL COMMENT '风险限额',
  `init_margin_rate` decimal(30,10) DEFAULT NULL COMMENT '起始保证金率',
  `maint_margin_rate` decimal(30,10) DEFAULT NULL COMMENT '维持保证金率',
  `init_margin` decimal(30,10) DEFAULT NULL COMMENT '起始保证金',
  `maint_margin` decimal(30,10) DEFAULT NULL COMMENT '维持保证金',
  `deleverage_percentile` tinyint(3) DEFAULT NULL COMMENT '自动减仓风险度',
  `rebalanced_pnl` decimal(30,10) DEFAULT NULL COMMENT '已划入账户的盈亏',
  `prev_realised_pnl` decimal(30,10) DEFAULT NULL COMMENT '上一次平仓已划入账户的盈亏',
  `current_cost` decimal(30,10) DEFAULT NULL COMMENT '当前仓位价值',
  `realised_cost` decimal(30,10) NOT NULL DEFAULT '0.0000000000' COMMENT '已平仓所获得的资金',
  `unrealised_cost` decimal(30,10) DEFAULT NULL COMMENT 'current_cost-realised_cost',
  `realised_pnl` decimal(30,10) DEFAULT NULL COMMENT '当日已实现盈亏',
  `unrealised_pnl` decimal(30,10) DEFAULT NULL COMMENT '未实现盈亏',
  `bankrupt_price` decimal(30,10) DEFAULT NULL COMMENT '破产价格',
  `liquidation_price` decimal(30,10) DEFAULT NULL COMMENT '强平价格',
  `gross_open_cost` decimal(30,10) DEFAULT NULL COMMENT '所有开仓委托单的价值',
  `gross_exec_cost` decimal(30,10) DEFAULT NULL COMMENT '成交总额',
  `prev_close_price` decimal(30,10) DEFAULT NULL COMMENT '上次平仓价格',
  `open_time` bigint(20) DEFAULT NULL COMMENT '开仓时间',
  `open_order_buy_qty` bigint(20) DEFAULT NULL COMMENT '买委托数量',
  `open_order_buy_cost` decimal(30,10) DEFAULT NULL COMMENT '买委托价值',
  `open_order_sell_qty` bigint(20) DEFAULT NULL COMMENT '卖委托数量',
  `open_order_sell_cost` decimal(30,10) DEFAULT NULL COMMENT '卖委托价值',
  `order_cost` decimal(30,10) DEFAULT NULL,
  `exec_buy_qty` bigint(20) DEFAULT NULL COMMENT '买成交数量',
  `exec_buy_cost` decimal(30,10) DEFAULT NULL COMMENT '买成交金额',
  `exec_sell_qty` bigint(20) DEFAULT NULL COMMENT '卖成交数量',
  `exec_sell_cost` decimal(30,10) DEFAULT NULL COMMENT '卖成交金额',
  `exec_cost` decimal(30,10) DEFAULT NULL COMMENT '成交金额',
  `exec_qty` bigint(20) DEFAULT NULL COMMENT '成交数量',
  `exec_comm` decimal(30,10) DEFAULT NULL COMMENT '成交费用',
  `mark_price` decimal(30,10) DEFAULT NULL COMMENT '标记价格',
  `mark_value` decimal(30,10) DEFAULT NULL COMMENT '标记价值',
  `mark_cost` decimal(30,10) DEFAULT NULL,
  `home_notional` decimal(30,10) DEFAULT NULL COMMENT '本地货币价值',
  `is_open` tinyint(4) DEFAULT NULL COMMENT '完全平仓后为false',
  `foreign_notional` decimal(30,10) DEFAULT NULL COMMENT '外地货币价值',
  `last_trade_id` char(32) DEFAULT NULL COMMENT '最后一笔影响持仓的成交编号',
  `long_bankrupt` decimal(30,10) DEFAULT NULL COMMENT '多头破产价值',
  `short_bankrupt` decimal(30,10) DEFAULT NULL COMMENT '空头破产价值',
  `kafka_partition` int(11) NOT NULL,
  `partition_offset` bigint(20) DEFAULT NULL,
  `insert_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间戳',
  `closeable_volume` bigint(20) DEFAULT NULL,
  `order_fee` decimal(30,10) DEFAULT NULL,
  `close_fee` decimal(30,10) DEFAULT NULL,
  `capital_fee` decimal(30,10) DEFAULT NULL,
  `pos_cross` decimal(30,10) DEFAULT NULL,
  `pos_loss` decimal(30,10) DEFAULT NULL,
  `transfer` decimal(30,10) DEFAULT NULL,
  `kafka_offset` bigint(20) DEFAULT NULL,
  `kafka_checkpoint` bigint(20) DEFAULT NULL,
  `frozen_margin` decimal(30,10) DEFAULT NULL,
  PRIMARY KEY (`client_id`,`instrument_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='持仓';

/*Table structure for table `t_settlement` */

DROP TABLE IF EXISTS `t_settlement`;

CREATE TABLE `t_settlement` (
  `account_id` bigint(20) NOT NULL COMMENT '资金账号',
  `currency` varchar(10) NOT NULL COMMENT '币种',
  `client_id` varchar(30) NOT NULL COMMENT '用户代码',
  `settlement_day` varchar(30) NOT NULL COMMENT '结算日',
  `settlement_serial_number` varchar(50) NOT NULL COMMENT '结算批次号',
  `prev_wallet_balance` decimal(30,10) NOT NULL COMMENT '上日钱包余额',
  `wallet_balance` decimal(30,10) NOT NULL COMMENT '钱包余额',
  `availilable` decimal(30,10) NOT NULL COMMENT '可用余额',
  `margin_balance` decimal(30,10) NOT NULL COMMENT '保证金余额',
  `frozen_margin` decimal(30,10) NOT NULL COMMENT '冻结保证金',
  `frozen_available` decimal(30,10) NOT NULL DEFAULT '0.0000000000' COMMENT '冻结可用(出金)',
  `current_margin` decimal(30,10) DEFAULT NULL COMMENT '占用保证金',
  `affiliate_payout` decimal(30,10) DEFAULT NULL COMMENT '推荐人返佣',
  `withdraw` decimal(30,10) DEFAULT NULL COMMENT '出金',
  `deposit` decimal(30,10) DEFAULT NULL COMMENT '入金',
  `capital_fee` decimal(30,10) DEFAULT NULL COMMENT '资金费用',
  `realised_pnl` decimal(30,10) NOT NULL COMMENT '已实现盈亏',
  `unrealised_pnl` decimal(30,10) NOT NULL COMMENT '未实现盈亏',
  `transfer` decimal(30,10) DEFAULT NULL COMMENT '今日转账',
  `trading_day` varchar(30) NOT NULL COMMENT '交易日',
  `commission` decimal(30,10) NOT NULL COMMENT '佣金',
  `kafka_partition` int(11) NOT NULL,
  `kafka_offset` bigint(20) DEFAULT NULL,
  `kafka_checkpoint` bigint(20) DEFAULT NULL,
  `update_time` bigint(30) DEFAULT NULL COMMENT '更新时间',
  `insert_time` bigint(30) DEFAULT NULL COMMENT '插入时间',
  PRIMARY KEY (`account_id`,`currency`,`client_id`,`settlement_day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_statement` */

DROP TABLE IF EXISTS `t_statement`;

CREATE TABLE `t_statement` (
  `statement_id` varchar(50) NOT NULL COMMENT '流水编号',
  `account_id` bigint(20) NOT NULL COMMENT '资金账号',
  `client_id` varchar(30) NOT NULL COMMENT '用户代码',
  `wallet_balance` decimal(30,0) DEFAULT '0' COMMENT '钱包余额',
  `currency` varchar(10) NOT NULL COMMENT '币种',
  `statement_type` int(11) NOT NULL COMMENT '流水类型',
  `amount` decimal(30,10) NOT NULL COMMENT '流水金额',
  `net_fee` decimal(30,30) DEFAULT NULL COMMENT '比特币网络费用',
  `address` varchar(50) DEFAULT NULL COMMENT '地址',
  `status` int(2) NOT NULL DEFAULT '0' COMMENT '0:完成  1:等待 2:撤销 3:无状态',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `kafka_partition` bigint(20) NOT NULL,
  `kafka_offset` bigint(20) NOT NULL,
  `kafka_checkpoint` bigint(20) NOT NULL,
  `trading_day` varchar(8) DEFAULT NULL COMMENT '交易日',
  `insert_time` bigint(20) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`statement_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资金流水';

/*Table structure for table `t_trade` */

DROP TABLE IF EXISTS `t_trade`;

CREATE TABLE `t_trade` (
  `trade_id` char(32) NOT NULL COMMENT 'trade id',
  `client_id` varchar(30) NOT NULL COMMENT '客户代码',
  `instrument_id` varchar(30) NOT NULL COMMENT '合约代码',
  `order_id` bigint(20) NOT NULL COMMENT '报单编号',
  `other_order_id` bigint(20) NOT NULL COMMENT '对方委托id',
  `direction` varchar(4) NOT NULL COMMENT '买卖方向:buy,sell',
  `price` decimal(30,10) NOT NULL COMMENT '价格',
  `volume` bigint(20) NOT NULL COMMENT '数量',
  `close_profit` decimal(30,10) DEFAULT NULL COMMENT '平仓盈亏',
  `exec_comm` decimal(30,10) DEFAULT NULL COMMENT '成交手续费',
  `trade_time` bigint(20) NOT NULL COMMENT '成交时间',
  `trade_type` varchar(10) NOT NULL COMMENT '成交类型：MATCH,OTC,RISK',
  `account_id` bigint(20) DEFAULT NULL COMMENT '资金账号',
  `offset_flag` varchar(10) DEFAULT NULL COMMENT '开平标志',
  `order_volume` bigint(20) NOT NULL COMMENT '委托数量',
  `home_notional` decimal(30,10) DEFAULT NULL COMMENT '本地货币价值',
  `foreign_notional` decimal(30,10) DEFAULT NULL COMMENT '外地货币价值',
  `exec_cost` decimal(30,10) DEFAULT NULL COMMENT '成交价值',
  `remark` varchar(50) DEFAULT NULL COMMENT '备注',
  `kafka_partition` bigint(20) NOT NULL,
  `kafka_offset` bigint(20) NOT NULL,
  `kafka_checkpoint` bigint(20) NOT NULL,
  `insert_time` bigint(20) NOT NULL,
  PRIMARY KEY (`order_id`,`trade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='成交';

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

