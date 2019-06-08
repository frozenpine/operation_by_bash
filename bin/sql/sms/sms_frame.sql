/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 5.7.25 : Database - send
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`sms` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `sms`;

/*Table structure for table `t_info_detail` */

DROP TABLE IF EXISTS `t_info_detail`;

CREATE TABLE `t_info_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增长序列号',
  `templates_id` varchar(20) NOT NULL COMMENT '模板Id',
  `sign_id` varchar(20) DEFAULT NULL COMMENT '签名ID',
  `type` varchar(1) NOT NULL COMMENT '发送类型 1:邮件 2:短信',
  `nation_code` varchar(20) DEFAULT NULL COMMENT '国家代码',
  `receive_code` varchar(30) NOT NULL COMMENT '接收人地址 邮件或者短信',
  `content` varchar(300) NOT NULL COMMENT '发送内容',
  `remark` varchar(300) DEFAULT NULL COMMENT '备注信息',
  `state` varchar(1) NOT NULL COMMENT '发送状态 1:成功 2:异常',
  `operate_date` bigint(20) DEFAULT NULL COMMENT '操作日期',
  `update_date` bigint(20) DEFAULT NULL COMMENT '修改日期',
  `operate_id` varchar(20) DEFAULT NULL COMMENT '操作人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1115580906794721282 DEFAULT CHARSET=utf8 COMMENT='通信明细';

/*Table structure for table `t_info_templates` */

DROP TABLE IF EXISTS `t_info_templates`;

CREATE TABLE `t_info_templates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增长序列号',
  `templates_id` varchar(20) NOT NULL COMMENT '模板id',
  `type` varchar(1) NOT NULL COMMENT '1:普通短信2:运营短信',
  `content` varchar(300) NOT NULL COMMENT '模板内容',
  `state` varchar(1) NOT NULL COMMENT '是否警用 1:正常 2:禁用',
  `international` varchar(1) NOT NULL COMMENT '1国内短信，2海外短信',
  `remark` varchar(300) DEFAULT NULL COMMENT '备注',
  `operate_date` bigint(20) DEFAULT NULL,
  `update_date` bigint(20) DEFAULT NULL,
  `operate_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`,`templates_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='短信邮件模板';

/*Table structure for table `t_sms_sign` */

DROP TABLE IF EXISTS `t_sms_sign`;

CREATE TABLE `t_sms_sign` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增长序列号',
  `sign_id` varchar(100) NOT NULL,
  `sign_name` varchar(20) NOT NULL,
  `remark` varchar(300) DEFAULT NULL,
  `operate_date` bigint(20) DEFAULT NULL,
  `update_date` bigint(20) DEFAULT NULL,
  `operate_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`,`sign_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='短信签名';

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
