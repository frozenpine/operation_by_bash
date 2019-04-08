/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 10.3.11-MariaDB : Database - digital
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

insert into `t_product` (`product_id`, `product_name`, `underlying_id`, `product_type`, `currency`, `trade_mode`, `quote_currency`, `clear_currency`, `deliv_series_num`, `cycle_type`, `product_status`, `operate_time`, `operator_id`, `recheck_operate_time`, `recheck_operator_id`, `match_rule`, `price_limit_before_fuse`, `price_mode`, `market_id`)
    values('XBT','BTC比特币','XBT-USD','1','XBT','1','XBT','XBT','1','1','1','1550645616397','admin','1550645616397','admin','1','21','1','1');
insert into `t_trade_fee_set` (`product_id`,  `user_group_id`, `fee_mode`, `maker_fee_rate`, `taker_fee_rate`, `maker_fee_amt`, `taker_fee_amt`, `operate_time`, `operator_id`) values('XBT',NULL,'1','0.1120000000','0.1125000000','0.0000000000','0.0000000000','1550826690893',NULL);
insert into `t_risk_limit` (`product_id`, `instrument_id`, `level`, `base_risk_limit`, `step_risk_limit`, `step_times`, `base_maint_margin`, `base_init_margin`, `operator_id`, `operate_time`) values('XBT',NULL,NULL,'0.1000000000','0.0100000000','10','0.2','0.1','admin','1545896347124');


insert into `t_risk_leverage_point_detail` (`id`, `product_id`, `risk_limit`, `leverage`) values('1','XBT','0.1000000000','100.00');
insert into `t_risk_leverage_point_detail` (`id`, `product_id`, `risk_limit`, `leverage`) values('2','XBT','0.2000000000','500.00');
insert into `t_risk_leverage_point_detail` (`id`, `product_id`, `risk_limit`, `leverage`) values('3','XBT','0.3000000000','1000.00');
insert into `t_risk_leverage_point_detail` (`id`, `product_id`, `risk_limit`, `leverage`) values('4','XBT','0.4000000000','2000.00');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
