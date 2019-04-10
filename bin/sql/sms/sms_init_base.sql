/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

USE `sms`;

/*Data for the table `t_info_detail` */

LOCK TABLES `t_info_detail` WRITE;

UNLOCK TABLES;

/*Data for the table `t_info_templates` */

LOCK TABLES `t_info_templates` WRITE;

insert  into `t_info_templates`(`id`,`templates_id`,`type`,`content`,`state`,`international`,`remark`,`operate_date`,`update_date`,`operate_id`) values (1,'261015','1','{code}为您的登录验证码，请于{time}分钟内填写。如非本人操作，请忽略本短信','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(2,'261016','1','三家有效交易所,{exchange}交易所的{product}品种价格{price}偏离所有样本交易所中位数价格{midPrice}的{value},超过阈值{peakValue}时被剔除,触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(3,'261017','1','两家有效交易所,{product}品种指数价格偏离绝对值{value}大于{peakValue}时,{exchange}交易所最新指数价格与上次指数价格偏离更大,被剔除,触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(4,'261018','1','一家交易所时{exchange},获取到{product}品种指数价格{price}与上一次获取到的指数价格{lastPrice}偏差绝对值{value}大于{peakValue},以上一次价格为准，触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(5,'261019','1','{product}品种指数来源中，一家交易所价格获取不到，触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(6,'261020','1','{product}品种指数来源中，仅剩一家交易所可获取价格，触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(7,'261021','1','{product}品种指数来源中，所有交易所价格都获取不到，触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(8,'261022','1','{product}品种所有指数来源交易所和Bitmex 价格都获取不到，触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(9,'261023','1','{product}品种所有指数来源价格都获取不到，且秒内无人工干预，触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(10,'261024','1','当日保险基金减少，触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(11,'261025','1','保险基金在{time}日内降低{value}BTC，触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(12,'261026','1','保险基金减少至安全阈值{value}BTC，触发预警','1','1','登陆注册验证',1547375715000,1547375715000,'admin'),(13,'261027','1','每日保险基金降低{value}BTC，触发自动减仓','1','1','登陆注册验证',1547375715000,1547375715000,'admin');

UNLOCK TABLES;

/*Data for the table `t_sms_sign` */

LOCK TABLES `t_sms_sign` WRITE;

insert  into `t_sms_sign`(`id`,`sign_id`,`sign_name`,`remark`,`operate_date`,`update_date`,`operate_id`) values (1,'189809','苏小稣','注册登录验证',1547375715000,1547375715000,'admin');

UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;