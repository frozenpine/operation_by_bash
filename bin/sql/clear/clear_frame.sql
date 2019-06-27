CREATE DATABASE /*!32312 IF NOT EXISTS */`clear` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `clear`;


DROP TABLE IF EXISTS `t_account`;

CREATE TABLE `t_account`
(
    `account_id`          bigint(20)      NOT NULL COMMENT '资金账号',
    `currency`            varchar(10)     NOT NULL COMMENT '币种',
    `client_id`           varchar(30)     NOT NULL COMMENT '用户代码',
    `prev_wallet_balance` decimal(30, 10) NOT NULL COMMENT '上日钱包余额',
    `wallet_balance`      decimal(30, 10) NOT NULL COMMENT '钱包余额',
    `available`           decimal(30, 10) NOT NULL COMMENT '可用余额',
    `margin_balance`      decimal(30, 10) NOT NULL COMMENT '保证金余额',
    `frozen_margin`       decimal(30, 10) NOT NULL COMMENT '委托冻结保证金',
    `frozen_available`    decimal(30, 10) NOT NULL DEFAULT '0.0000000000',
    `current_margin`      decimal(30, 10)          DEFAULT NULL COMMENT '占用保证金(持仓保证金)',
    `affiliate_payout`    decimal(30, 10)          DEFAULT NULL,
    `fee`                 decimal(30, 10)          DEFAULT NULL COMMENT '成交手续费',
    `withdraw`            decimal(30, 10)          DEFAULT NULL COMMENT '出金',
    `deposit`             decimal(30, 10)          DEFAULT NULL COMMENT '入金',
    `capital_fee`         decimal(30, 10)          DEFAULT NULL COMMENT '资金费用',
    `realised_pnl`        decimal(30, 10) NOT NULL COMMENT '已实现盈亏',
    `unrealised_pnl`      decimal(30, 10) NOT NULL COMMENT '未实现盈亏',
    `no_filed_cnt`        bigint(20)               DEFAULT NULL,
    `sell_vol_sum`        bigint(20)               DEFAULT NULL,
    `buy_vol_sum`         bigint(20)               DEFAULT NULL,
    `sell_cost`           decimal(30, 10)          DEFAULT NULL,
    `buy_cost`            decimal(30, 10)          DEFAULT NULL,
    `transfer`            decimal(30, 10)          DEFAULT NULL COMMENT '今日转账',
    `commission`          decimal(30, 10) NOT NULL COMMENT '交易手续费',
    `withdraw_fee`        decimal(30, 10)          DEFAULT NULL COMMENT '提现手续费(比特币网络费用)',
    `transfer_account`    decimal(30, 10)          DEFAULT NULL COMMENT '（同用户资金账号间）划转',
    `transfer_client`     decimal(30, 10)          DEFAULT NULL COMMENT '（不同用户间）今日转账',
    `largess`             decimal(30, 10)          DEFAULT NULL COMMENT '赠币',
    `compensation`        decimal(10, 0)           DEFAULT NULL COMMENT '补偿',
    `kafka_partition`     int(11)         NOT NULL,
    `kafka_offset`        bigint(20)               DEFAULT NULL,
    `update_time`         bigint(20)               DEFAULT NULL COMMENT '更新时间',
    `insert_time`         bigint(20)               DEFAULT NULL COMMENT '插入时间',
    PRIMARY KEY (`account_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

/*Table structure for table `t_account_snap` */

DROP TABLE IF EXISTS `t_account_snap`;

CREATE TABLE `t_account_snap`
(
    `account_id`          bigint(20)      NOT NULL COMMENT '资金账号',
    `settlement_id`       bigint(20)      NOT NULL COMMENT '数据标签',
    `client_id`           varchar(30)     NOT NULL COMMENT '用户代码',
    `currency`            varchar(10)     NOT NULL COMMENT '币种',
    `prev_wallet_balance` decimal(30, 10) NOT NULL COMMENT '上日钱包余额',
    `wallet_balance`      decimal(30, 10) NOT NULL COMMENT '钱包余额',
    `available`           decimal(30, 10) NOT NULL COMMENT '可用余额',
    `margin_balance`      decimal(30, 10) NOT NULL COMMENT '保证金余额',
    `frozen_margin`       decimal(30, 10) NOT NULL COMMENT '委托冻结保证金',
    `frozen_available`    decimal(30, 10) NOT NULL DEFAULT '0.0000000000',
    `current_margin`      decimal(30, 10)          DEFAULT NULL COMMENT '占用保证金(持仓保证金)',
    `affiliate_payout`    decimal(30, 10)          DEFAULT NULL,
    `fee`                 decimal(30, 10)          DEFAULT NULL COMMENT '成交手续费',
    `withdraw`            decimal(30, 10)          DEFAULT NULL COMMENT '出金',
    `deposit`             decimal(30, 10)          DEFAULT NULL COMMENT '入金',
    `capital_fee`         decimal(30, 10)          DEFAULT NULL COMMENT '资金费用',
    `realised_pnl`        decimal(30, 10) NOT NULL COMMENT '已实现盈亏',
    `unrealised_pnl`      decimal(30, 10) NOT NULL COMMENT '未实现盈亏',
    `no_filed_cnt`        bigint(20)               DEFAULT NULL,
    `sell_vol_sum`        bigint(20)               DEFAULT NULL,
    `buy_vol_sum`         bigint(20)               DEFAULT NULL,
    `sell_cost`           decimal(30, 10)          DEFAULT NULL,
    `buy_cost`            decimal(30, 10)          DEFAULT NULL,
    `transfer`            decimal(30, 10)          DEFAULT NULL COMMENT '今日转账',
    `commission`          decimal(30, 10) NOT NULL COMMENT '交易手续费',
    `withdraw_fee`        decimal(30, 10)          DEFAULT NULL COMMENT '提现手续费(比特币网络费用)',
    `transfer_account`    decimal(30, 10)          DEFAULT NULL COMMENT '（同用户资金账号间）划转',
    `transfer_client`     decimal(30, 10)          DEFAULT NULL COMMENT '（不同用户间）今日转账',
    `largess`             decimal(30, 10)          DEFAULT NULL COMMENT '赠币',
    `compensation`        decimal(10, 0)           DEFAULT NULL COMMENT '补偿',
    `kafka_partition`     int(11)         NOT NULL,
    `kafka_offset`        bigint(20)               DEFAULT NULL,
    `insert_time`         bigint(20)               DEFAULT NULL COMMENT '插入时间',
    PRIMARY KEY (`account_id`, `settlement_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

/*Table structure for table `t_order_history` */

DROP TABLE IF EXISTS `t_order_history`;

CREATE TABLE `t_order_history`
(
    `order_id`                bigint(20)  NOT NULL COMMENT '订单编号',
    `order_local_id`          varchar(50)     DEFAULT NULL COMMENT '本地报单编号',
    `client_id`               varchar(30) NOT NULL COMMENT '客户代码',
    `account_id`              bigint(20)      DEFAULT NULL COMMENT '资金账号',
    `bound_price`             decimal(30, 10) DEFAULT NULL COMMENT '约束价格',
    `stop_px`                 decimal(30, 10) DEFAULT NULL COMMENT '止损价格',
    `open_volume`             bigint(20)      DEFAULT NULL,
    `each_fee`                decimal(30, 10) DEFAULT NULL COMMENT '每手冻结手续费',
    `each_margin`             decimal(30, 10) DEFAULT NULL COMMENT '每手冻结保证金',
    `instrument_id`           varchar(30) NOT NULL COMMENT '合约代码',
    `direction`               varchar(4)  NOT NULL COMMENT '买卖方向:buy,sell',
    `offset_flag`             varchar(30)     DEFAULT NULL COMMENT '开平标志:open,close',
    `limit_price`             decimal(30, 10) DEFAULT NULL COMMENT '价格',
    `last_traded_volume`      bigint(20)      DEFAULT NULL COMMENT '最新成交量',
    `traded_volume`           bigint(20)      DEFAULT NULL COMMENT '成交量',
    `display_volume`          bigint(20)      DEFAULT NULL COMMENT '隐藏单显示数量',
    `order_volume`            bigint(20)  NOT NULL COMMENT '委托量',
    `time_in_force`           varchar(20)     DEFAULT NULL COMMENT 'GoodTillCancel(一直有效直至取消),ImmediateOrCancel(立刻成交或取消，能成交的部分成交，其余撤单),FillOrKill(全部成交或取消)',
    `order_time`              bigint(20)      DEFAULT NULL COMMENT '报单时间',
    `trade_time`              bigint(20)      DEFAULT NULL COMMENT '最后成交时间',
    `cancel_time`             bigint(20)      DEFAULT NULL COMMENT '撤销时间',
    `active_time`             bigint(20)      DEFAULT NULL COMMENT '激活时间',
    `peg_offset_value`        decimal(30, 10) DEFAULT NULL COMMENT '追踪价距',
    `peg_price_type`          varchar(20)     DEFAULT NULL COMMENT '价格偏差类型，Optional peg price type. Valid options: LastPeg, MidPricePeg, MarketPeg, PrimaryPeg, TrailingStopPeg.',
    `exec_inst`               varchar(60)     DEFAULT NULL COMMENT '执行说明',
    `order_status`            varchar(30) NOT NULL COMMENT '报单状态:New(新建订单),PartiallyFilled(部分成交),Filled(完全成交),Canceled(撤单),Rejected(拒绝)',
    `force_close_reason`      varchar(10)     DEFAULT NULL COMMENT '强平原因',
    `stop_order_price_type`   varchar(30)     DEFAULT NULL COMMENT '条件单报单价格条件',
    `order_price_type`        varchar(30)     DEFAULT NULL COMMENT '报单价格条件',
    `remark`                  varchar(255)    DEFAULT NULL COMMENT '备注',
    `triggered`               varchar(100)    DEFAULT NULL COMMENT '触发状态；"",表示未触发；StopOrderTriggered已触发',
    `order_rej_reason`        varchar(200)    DEFAULT NULL COMMENT '订单拒绝原因',
    `settle_currency`         varchar(10) NOT NULL COMMENT '结算币种',
    `currency`                varchar(10) NOT NULL COMMENT '币种',
    `transact_time`           bigint(20)  NOT NULL,
    `leaves_qty`              bigint(20)      DEFAULT NULL,
    `cum_qty`                 bigint(20)      DEFAULT NULL,
    `avg_px`                  decimal(30, 10) DEFAULT NULL,
    `exec_cost`               decimal(30, 10) DEFAULT NULL,
    `exec_comm`               decimal(30, 10) DEFAULT NULL,
    `multiLeg_reporting_type` varchar(30)     DEFAULT NULL,
    `modify_time`             bigint(20)      DEFAULT NULL,
    `order_type`              int(11)         DEFAULT NULL COMMENT 'OT_NORMAL(0,"用户下单"),\nOT_RISK(1,"风控爆仓下单"),\nOT_RISK_REDUCE(2,"风控爆仓减仓下单")',
    `order_source`            int(11)         DEFAULT NULL,
    `kafka_partition`         int(11)     NOT NULL,
    `kafka_offset`            bigint(20)      DEFAULT NULL,
    `bankrupt_price`          decimal(30, 10) DEFAULT NULL COMMENT '破产价格',
    `realisedPnl`             decimal(30, 10) DEFAULT NULL COMMENT '已实现盈亏',
    `openAvg`                 decimal(30, 10) DEFAULT NULL COMMENT '开仓均价',
    `timestamp`               bigint(20)  NOT NULL,
    PRIMARY KEY (`order_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='已完成订单';

/*Table structure for table `t_position` */

DROP TABLE IF EXISTS `t_position`;

CREATE TABLE `t_position` (
  `client_id` varchar(30) NOT NULL COMMENT '用户代码',
  `account_id` bigint(20) NOT NULL,
  `instrument_id` varchar(30) NOT NULL COMMENT '合约代码',
  `direction` varchar(4) NOT NULL COMMENT '持仓多空方向',
  `direction_net` varchar(4) NOT NULL COMMENT '业务主键',
  `position_margin_type` varchar(30) DEFAULT NULL,
  `currency` varchar(10) NOT NULL COMMENT '币种',
  `underlying` varchar(30) DEFAULT NULL,
  `quote_currency` varchar(5) DEFAULT NULL,
  `commission` decimal(30,10) DEFAULT NULL COMMENT '费率',
  `position` bigint(20) NOT NULL COMMENT '持仓',
  `position_avg_price` decimal(30,10) DEFAULT NULL,
  `open_cost` decimal(30,10) NOT NULL COMMENT '开仓成本',
  `position_cost` decimal(30,10) NOT NULL COMMENT '持仓成本',
  `current_comm` decimal(30,10) NOT NULL COMMENT '当前费用',
  `cross_margin` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否使用全仓保证金',
  `position_margin` decimal(30,10) DEFAULT NULL,
  `leverage` decimal(10,2) DEFAULT NULL COMMENT '杠杆',
  `risk_limit` decimal(30,10) DEFAULT NULL COMMENT '风险限额',
  `init_margin_rate` decimal(30,10) DEFAULT NULL COMMENT '起始保证金率',
  `maint_margin_rate` decimal(30,10) DEFAULT NULL COMMENT '维持保证金率',
  `init_margin` decimal(30,10) DEFAULT NULL COMMENT '起始保证金',
  `maint_margin` decimal(30,10) DEFAULT NULL COMMENT '维持保证金',
  `deleverage_percentile` decimal(30,10) DEFAULT NULL COMMENT '自动减仓排序',
  `rebalanced_pnl` decimal(30,10) DEFAULT NULL COMMENT '已划入账户的盈亏',
  `prev_realised_pnl` decimal(30,10) DEFAULT NULL COMMENT '上一次平仓已划入账户的盈亏',
  `current_cost` decimal(30,10) DEFAULT NULL COMMENT '当前仓位价值',
  `realised_cost` decimal(30,10) DEFAULT '0.0000000000' COMMENT '已平仓所获得的资金',
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
  `partition_offset` bigint(20) DEFAULT NULL,
  `order_fee` decimal(30,10) DEFAULT NULL,
  `close_fee` decimal(30,10) DEFAULT NULL,
  `capital_fee` decimal(30,10) DEFAULT NULL,
  `pos_cross` decimal(30,10) DEFAULT NULL,
  `pos_loss` decimal(30,10) DEFAULT NULL,
  `transfer` decimal(30,10) DEFAULT NULL,
  `frozen_margin` decimal(30,10) DEFAULT NULL,
  `kafka_partition` int(11) NOT NULL,
  `kafka_offset` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间戳',
  `insert_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`account_id`,`instrument_id`,`direction_net`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='持仓';

/*Table structure for table `t_settlement` */

DROP TABLE IF EXISTS `t_settlement`;

CREATE TABLE `t_settlement`
(
    `account_id`          bigint(20)      NOT NULL COMMENT '资金账号',
    `client_id`           varchar(30)     NOT NULL COMMENT '用户代码',
    `settlement_id`       bigint(20)      NOT NULL COMMENT '结算ID',
    `currency`            varchar(10)     NOT NULL COMMENT '币种',
    `prev_wallet_balance` decimal(30, 10) NOT NULL COMMENT '上日钱包余额',
    `wallet_balance`      decimal(30, 10) NOT NULL COMMENT '钱包余额',
    `realised_gross_pnl`  decimal(30, 10) NOT NULL COMMENT '平仓盈亏',
    `frozen_available`    decimal(30, 10) NOT NULL COMMENT '冻结资金',
    `realised_pnl`        decimal(30, 10) NOT NULL COMMENT '已实现盈亏',
    `withdraw`            decimal(30, 10) DEFAULT NULL COMMENT '出金',
    `deposit`             decimal(30, 10) DEFAULT NULL COMMENT '入金',
    `fee`                 decimal(30, 10) DEFAULT NULL COMMENT '成交手续费',
    `capital_fee`         decimal(30, 10) DEFAULT NULL COMMENT '资金费用',
    `withdraw_fee`        decimal(30, 10) DEFAULT NULL COMMENT '提现手续费(比特币网络费用)',
    `transfer`            decimal(30, 10) DEFAULT NULL COMMENT '今日转账',
    `transfer_account`    decimal(30, 10) DEFAULT NULL COMMENT '（同用户资金账号间）划转',
    `transfer_client`     decimal(30, 10) DEFAULT NULL COMMENT '（不同用户间）今日转账',
    `affiliate_payout`    decimal(30, 10) DEFAULT NULL COMMENT '返佣',
    `largess`             decimal(30, 10) DEFAULT NULL COMMENT '赠币',
    `compensation`        decimal(30, 10) DEFAULT NULL COMMENT '补偿',
    `kafka_partition`     int(11)         NOT NULL,
    `kafka_offset`        bigint(20)      NOT NULL,
    `insert_time`         bigint(20)      NOT NULL COMMENT '插入时间',
    PRIMARY KEY (`account_id`, `settlement_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

/*Table structure for table `t_statement` */

DROP TABLE IF EXISTS `t_statement`;

CREATE TABLE `t_statement`
(
    `id`                  bigint(20)      NOT NULL AUTO_INCREMENT COMMENT '自增主键',
    `client_id`           varchar(36)     NOT NULL COMMENT '用户Id',
    `account_id`          bigint(20)      NOT NULL COMMENT '用户资金账号Id',
    `currency`            varchar(10)     NOT NULL COMMENT '币种',
    `money_type`          int(11)         NOT NULL COMMENT '资金类型',
    `wallet_balance`      decimal(30, 10) DEFAULT NULL,
    `amount`              decimal(36, 18) NOT NULL COMMENT '金额',
    `address`             varchar(50)     DEFAULT NULL COMMENT '业务源',
    `opposite_client_id`  varchar(36)     DEFAULT NULL COMMENT '对手方用户Id',
    `opposite_account_id` bigint(20)      DEFAULT NULL COMMENT '对手方用户资金账号Id',
    `command_id`          varchar(100)    DEFAULT NULL COMMENT '如果是外部交互，填充命令Id，如果是内部交易引起，填交易id',
    `remark`              varchar(128)    DEFAULT NULL COMMENT '备注',
    `settlement_id`       bigint(20)      DEFAULT NULL COMMENT '数据标签',
    `kafka_partition`     int(11)         NOT NULL,
    `kafka_offset`        bigint(20)      NOT NULL,
    `insert_time`         bigint(20)      NOT NULL COMMENT '插入时间',
    PRIMARY KEY (`id`),
    KEY `IDX_STLID_PRTN` (`settlement_id`, `kafka_partition`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;


/*Table structure for table `t_trade` */

DROP TABLE IF EXISTS `t_trade`;

CREATE TABLE `t_trade`
(
    `trade_id`         char(36)        NOT NULL COMMENT 'trade id',
    `client_id`        varchar(30)     NOT NULL COMMENT '客户代码',
    `instrument_id`    varchar(30)     NOT NULL COMMENT '合约代码',
    `order_id`         bigint(20)      NOT NULL COMMENT '报单编号',
    `other_order_id`   bigint(20)      NOT NULL COMMENT '对方委托id',
    `direction`        varchar(4) COMMENT '买卖方向:buy,sell',
    `order_status`     varchar(30)              DEFAULT '' COMMENT '成交状态',
    `currency`         varchar(10)     NOT NULL COMMENT '币种',
    `price`            decimal(30, 10) NOT NULL COMMENT '价格',
    `trade_amount`     decimal(30, 10) NOT NULL DEFAULT '0.0000000000' COMMENT '成交金额',
    `volume`           bigint(20)      NOT NULL COMMENT '数量',
    `side`             varchar(10)              DEFAULT '' COMMENT 'Taker/Maker',
    `order_kind`       varchar(20)              DEFAULT '' COMMENT '成交里的委托类型',
    `close_profit`     decimal(30, 10)          DEFAULT NULL COMMENT '平仓盈亏',
    `exec_comm`        decimal(30, 10)          DEFAULT NULL COMMENT '成交手续费',
    `trade_time`       bigint(20)      NOT NULL COMMENT '成交时间',
    `trade_type`       varchar(10)     NOT NULL COMMENT '成交类型：MATCH,OTC,RISK',
    `account_id`       bigint(20)               DEFAULT NULL COMMENT '资金账号',
    `offset_flag`      varchar(10)              DEFAULT NULL COMMENT '开平标志',
    `order_volume`     bigint(20)      NOT NULL COMMENT '委托数量',
    `home_notional`    decimal(30, 10)          DEFAULT NULL COMMENT '本地货币价值',
    `foreign_notional` decimal(30, 10)          DEFAULT NULL COMMENT '外地货币价值',
    `order_price`      decimal(30, 10) NOT NULL DEFAULT '0.0000000000' COMMENT '委托价格',
    `exec_cost`        decimal(30, 10)          DEFAULT NULL COMMENT '成交价值',
    `commission`       decimal(30, 10)          DEFAULT '0.0000000000' COMMENT '佣金费率',
    `remark`           varchar(50)              DEFAULT NULL COMMENT '备注',
    `kafka_partition`  int(11)         NOT NULL,
    `kafka_offset`     bigint(20)      NOT NULL,
    `loopIndex`        bigint(20)      NOT NULL DEFAULT '0' COMMENT '排序新增字段',
    `insert_time`      bigint(20)      NOT NULL,
    PRIMARY KEY (`order_id`, `trade_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='成交';


DROP TABLE IF EXISTS `t_verify_account`;

CREATE TABLE `t_verify_account`
(
    `account_id`          bigint(20)      NOT NULL COMMENT '资金账号',
    `client_id`           varchar(30)     NOT NULL COMMENT '用户代码',
    `source_type`         int(1)          NOT NULL COMMENT '来源 1:结算 2:流水汇总',
    `status`              int(1)          NOT NULL COMMENT '是否最新跑批结果 0 ：最新 1：历史',
    `settlement_id`       bigint(20)      NOT NULL COMMENT '结算ID',
    `currency`            varchar(10)     NOT NULL COMMENT '币种',
    `prev_wallet_balance` decimal(30, 10) NOT NULL COMMENT '上日钱包余额',
    `wallet_balance`      decimal(30, 10) NOT NULL COMMENT '钱包余额',
    `realised_gross_pnl`  decimal(30, 10) NOT NULL COMMENT '平仓盈亏',
    `frozen_available`    decimal(30, 10) NOT NULL COMMENT '冻结资金',
    `realised_pnl`        decimal(30, 10) NOT NULL COMMENT '已实现盈亏',
    `withdraw`            decimal(30, 10) DEFAULT NULL COMMENT '出金',
    `deposit`             decimal(30, 10) DEFAULT NULL COMMENT '入金',
    `fee`                 decimal(30, 10) DEFAULT NULL COMMENT '成交手续费',
    `capital_fee`         decimal(30, 10) DEFAULT NULL COMMENT '资金费用',
    `withdraw_fee`        decimal(30, 10) DEFAULT NULL COMMENT '提现手续费(比特币网络费用)',
    `transfer`            decimal(30, 10) DEFAULT NULL COMMENT '今日转账',
    `transfer_account`    decimal(30, 10) DEFAULT NULL COMMENT '（同用户资金账号间）划转',
    `transfer_client`     decimal(30, 10) DEFAULT NULL COMMENT '（不同用户间）今日转账',
    `affiliate_payout`    decimal(30, 10) DEFAULT NULL COMMENT '返佣',
    `largess`             decimal(30, 10) DEFAULT NULL COMMENT '赠币',
    `compensation`        decimal(30, 10) DEFAULT NULL COMMENT '补偿',
    `insert_time`         bigint(20)      NOT NULL COMMENT '插入时间',
    PRIMARY KEY (`account_id`, `settlement_id`, `source_type`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;


