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

insert into `t_instrument` (`instrumentid`, `instrument_name`, `product_id`, `product_type`, `underlying_id`, `cycle_type`, `contract_size`, `tick`, `trade_mode`, `reverse`, `quote_currency`, `clear_currency`, `price_source`, `max_order_price`, `funding_times`, `create_date`, `open_date`, `open_date_expr`, `volume_multiple`, `end_trading_day`, `instrument_status`, `end_trading_day_expr`, `expire_date`, `expire_date_expr`, `start_deliv_date`, `start_deliv_date_expr`, `end_deliv_date`, `end_deliv_date_expr`, `open_year_month`, `deliv_year_month`, `option_series_id`, `option_type`, `strike_price`, `is_auto`, `is_confirm_needed`, `no_trade_days`, `qty_unit`, `basis_rate`, `quote_rate`, `basis_price_type`, `basis_price`, `position_type`, `deliv_mode`, `deliv_type`, `exec_type`, `trading_day_type`, `oper_id`, `oper_time`, `recheck_oper_id`, `recheck_oper_time`)
    values('XBTUSD','比特币永续','XBT','1','XBT-USD','3','1.0000000000','0.0010000000','1','1','USD','XBT','1','10000.0000000000','3','20190227','20190227','20991227','100','20991227','0','20991227','20991227','20991227','20991227','20991227','20991227','20991227','1902','12','XBTUSDP','1','3500.0000000000','0','1','1','1','0.0600000000','0.0100000000','1','3500.0000000000','1','1','1','1','2','admin','1550645616397','admin','1550645616397');

insert into `t_risk_mandatory_reduction_set` (`product_id`, `instrument_id`, `reduction_price_ladder`, `max_market_fluctuate_tolerate`, `max_order_time_tolerate`, `amount`, `interval`, `compulsion_status`, `operate_time`, `operator_id`) values('XBT','XBTUSD','1','0.100000','5.000000','1000','1.0000000000','0','1551440015059','admin');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
