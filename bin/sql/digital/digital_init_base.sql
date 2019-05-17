/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 10.3.11-MariaDB : Database - digital
*********************************************************************
*/

USE `digital`;


/*Data for the table `t_dict` */

LOCK TABLES `t_dict` WRITE;
TRUNCATE t_dict;
insert  into `t_dict`(`id`,`dict_class`,`dict_value`,`dict_name_cn`,`dict_name_en`) values (1,'applyStatus','0','注册完成','Register'),(2,'applyStatus','1','邮箱验证已打开','Email Checked'),(3,'applyStatus','2','证件审核已提交','Identity Submit'),(4,'applyStatus','3','证件审核已驳回','Identity Refuse'),(5,'applyStatus','4','证件审核已通过','Idengtidy Adops'),(6,'applyStatus','5','两步验证已通过','Double Checked'),(7,'applyStatus','6','资金密码已设置','Account Password Set'),(8,'applyStatus','7','正常','Active'),(9,'applyStatus','8','冻结','Frozen'),(10,'driction','0','买','Buy'),(11,'driction','1','卖','Sell'),(12,'cycleType','1','周','Week'),(13,'cycleType','2','月','Month'),(14,'cycleType','3','永续','Sustainable'),(15,'productStatus','1','待审核','To Be Audited'),(16,'productStatus','2','未上市','Unlisted'),(17,'productStatus','3','上市','On The Marke'),(18,'productStatus','4','退市','Delisting'),(19,'productType','1','期货','Futures'),(20,'productType','2','期权','Option'),(21,'tradeMode','1','永续反向','Sustainable Reverse'),(22,'tradeMode','3','定期反向','Regular Reverse'),(23,'delivSeriesType','1','周','Week'),(24,'delivSeriesType','2','近月','Month'),(25,'delivSeriesType','3','季月','Quarter'),(26,'positionType','1','综合持仓','All Position'),(27,'positionType','2','单边持仓','Side Position'),(28,'feeMode','1','百分比','Percentage'),(29,'feeMode','2','绝对值','Absolute VALUE'),(30,'week','1','周一','Monday'),(31,'week','2','周二','Tuesday'),(32,'week','3','周三','Wednesday'),(33,'week','4','周四','Thursday'),(34,'week','5','周五','Friday'),(35,'week','6','周六','Saturated'),(36,'week','7','周日','Sunday'),(37,'order','1','正数','Asc'),(38,'order','2','倒数','Desc'),(39,'tradeMode','4','定期正向','Regular Forward'),(40,'tradeMode','2','永续正向','Sustainable Forward'),(41,'underlyingType','1','现货指数','Spot Index'),(42,'rakeBack','0','注册送币数量',NULL),(43,'rakeBack','1','邀请一级返币数量',NULL),(44,'rakeBack','2','邀请二级返币数量',NULL),(45,'rakeBack','3','邀请三级返币数量',NULL),(46,'rakeBack','4','邀请四级返币数量',NULL),(47,'tradeRakeBack','1','一级交易返币',NULL),(48,'tradeRakeBack','2','二级交易返币',NULL),(49,'tradeRakeBack','3','三级交易返币',NULL),(50,'tradeRakeBack','4','四级交易返币',NULL),(51,'rakeBackType','1','邀请返币',NULL),(52,'rakeBackType','2','交易返币',NULL),(53,'invitationLevel','1','一级','Level One'),(54,'invitationLevel','2','二级','Level Two'),(55,'invitationLevel','3','三级','Level Three'),(56,'invitationLevel','4','四级','Level Four'),(57,'country','93','阿富汗','Afghanistan'),(58,'country','355','阿尔巴尼亚','Albania'),(59,'country','213','阿尔及利亚','Algeria'),(60,'country','684','美属萨摩亚','American Samoa'),(61,'country','376','安道尔','Andorra'),(62,'country','244','安哥拉','Angola'),(63,'country','1264','安圭拉','Anguilla'),(64,'country','672','南极洲','Antarctica'),(65,'country','1268','安提瓜和巴布达','Antigua and Barbuda'),(66,'country','54','阿根廷','Argentina'),(67,'country','374','亚美尼亚','Armenia'),(68,'country','297','阿鲁巴','Aruba'),(69,'country','61','澳大利亚','Australia'),(70,'country','43','奥地利','Austria'),(71,'country','994','阿塞拜疆','Azerbaijan'),(72,'country','973','巴林','Bahrain'),(73,'country','880','孟加拉国','Bangladesh'),(74,'country','1246','巴巴多斯','Barbados'),(75,'country','375','白俄罗斯','Belarus'),(76,'country','32','比利时','Belgium'),(77,'country','501','伯利兹','Belize'),(78,'country','229','贝宁','Benin'),(79,'country','1441','百慕大','Bermuda'),(80,'country','975','不丹','Bhutan'),(81,'country','591','玻利维亚','Bolivia'),(82,'country','387','波黑','Bosnia and Herzegovina'),(83,'country','267','博茨瓦纳','Botswana'),(84,'country','55','巴西','Brazil'),(85,'country','1284','英属维尔京群岛','British Virgin Islands'),(86,'country','673','文莱','Brunei Darussalam'),(87,'country','359','保加利亚','Bulgaria'),(88,'country','226','布基纳法索','Burkina Faso'),(89,'country','95','缅甸','Burma'),(90,'country','257','布隆迪','Burundi'),(91,'country','855','柬埔寨','Cambodia'),(92,'country','237','喀麦隆','Cameroon'),(93,'country','1','加拿大','Canada'),(94,'country','238','佛得角','Cape Verde'),(95,'country','1345','开曼群岛','Cayman Islands'),(96,'country','236','中非','Central African Republic'),(97,'country','235','乍得','Chad'),(98,'country','56','智利','Chile'),(99,'country','86','中国','China'),(100,'country','61','圣诞岛','Christmas Island'),(101,'country','61','科科斯（基林）群岛','Cocos (Keeling) Islands'),(102,'country','57','哥伦比亚','Colombia'),(103,'country','269','科摩罗','Comoros'),(104,'country','243','刚果（金）','Democratic Republic of the Congo'),(105,'country','242','刚果（布）','Republic of the Congo'),(106,'country','682','库克群岛','Cook Islands'),(107,'country','506','哥斯达黎加','Costa Rica'),(108,'country','225','科特迪瓦','Cote d Ivoire'),(109,'country','385','克罗地亚','Croatia'),(110,'country','53','古巴','Cuba'),(111,'country','357','塞浦路斯','Cyprus'),(112,'country','420','捷克','Czech Republic'),(113,'country','45','丹麦','Denmark'),(114,'country','253','吉布提','Djibouti'),(115,'country','1767','多米尼克','Dominica'),(116,'country','1809','多米尼加','Dominican Republic'),(117,'country','593','厄瓜多尔','Ecuador'),(118,'country','20','埃及','Egypt'),(119,'country','503','萨尔瓦多','El Salvador'),(120,'country','240','赤道几内亚','Equatorial Guinea'),(121,'country','291','厄立特里亚','Eritrea'),(122,'country','372','爱沙尼亚','Estonia'),(123,'country','251','埃塞俄比亚','Ethiopia'),(124,'country','500','福克兰群岛（马尔维纳斯）','Falkland Islands (Islas Malvinas)'),(125,'country','298','法罗群岛','Faroe Islands'),(126,'country','679','斐济','Fiji'),(127,'country','358','芬兰','Finland'),(128,'country','33','法国','France'),(129,'country','594','法属圭亚那','French Guiana'),(130,'country','689','法属波利尼西亚','French Polynesia'),(131,'country','241','加蓬','Gabon'),(132,'country','995','格鲁吉亚','Georgia'),(133,'country','49','德国','Germany'),(134,'country','233','加纳','Ghana'),(135,'country','350','直布罗陀','Gibraltar'),(136,'country','30','希腊','Greece'),(137,'country','299','格陵兰','Greenland'),(138,'country','1473','格林纳达','Grenada'),(139,'country','590','瓜德罗普','Guadeloupe'),(140,'country','1671','关岛','Guam'),(141,'country','502','危地马拉','Guatemala'),(142,'country','1481','根西岛','Guernsey'),(143,'country','224','几内亚','Guinea'),(144,'country','245','几内亚比绍','Guinea-Bissau'),(145,'country','592','圭亚那','Guyana'),(146,'country','509','海地','Haiti'),(147,'country','379','梵蒂冈','Holy See (Vatican City)'),(148,'country','504','洪都拉斯','Honduras'),(149,'country','852','香港','Hong Kong (SAR)'),(150,'country','36','匈牙利','Hungary'),(151,'country','354','冰岛','Iceland'),(152,'country','91','印度','India'),(153,'country','62','印度尼西亚','Indonesia'),(154,'country','98','伊朗','Iran'),(155,'country','964','伊拉克','Iraq'),(156,'country','353','爱尔兰','Ireland'),(157,'country','972','以色列','Israel'),(158,'country','39','意大利','Italy'),(159,'country','1876','牙买加','Jamaica'),(160,'country','81','日本','Japan'),(161,'country','962','约旦','Jordan'),(162,'country','73','哈萨克斯坦','Kazakhstan'),(163,'country','254','肯尼亚','Kenya'),(164,'country','686','基里巴斯','Kiribati'),(165,'country','850','朝鲜','North Korea'),(166,'country','82','韩国','South Korea'),(167,'country','965','科威特','Kuwait'),(168,'country','996','吉尔吉斯斯坦','Kyrgyzstan'),(169,'country','856','老挝','Laos'),(170,'country','371','拉脱维亚','Latvia'),(171,'country','961','黎巴嫩','Lebanon'),(172,'country','266','莱索托','Lesotho'),(173,'country','231','利比里亚','Liberia'),(174,'country','218','利比亚','Libya'),(175,'country','423','列支敦士登','Liechtenstein'),(176,'country','370','立陶宛','Lithuania'),(177,'country','352','卢森堡','Luxembourg'),(178,'country','853','澳门','Macao'),(179,'country','389','前南马其顿','The Former Yugoslav Republic of Macedonia'),(180,'country','261','马达加斯加','Madagascar'),(181,'country','265','马拉维','Malawi'),(182,'country','60','马来西亚','Malaysia'),(183,'country','960','马尔代夫','Maldives'),(184,'country','223','马里','Mali'),(185,'country','356','马耳他','Malta'),(186,'country','692','马绍尔群岛','Marshall Islands'),(187,'country','596','马提尼克','Martinique'),(188,'country','222','毛里塔尼亚','Mauritania'),(189,'country','230','毛里求斯','Mauritius'),(190,'country','269','马约特','Mayotte'),(191,'country','52','墨西哥','Mexico'),(192,'country','691','密克罗尼西亚','Federated States of Micronesia'),(193,'country','373','摩尔多瓦','Moldova'),(194,'country','377','摩纳哥','Monaco'),(195,'country','976','蒙古','Mongolia'),(196,'country','1664','蒙特塞拉特','Montserrat'),(197,'country','212','摩洛哥','Morocco'),(198,'country','258','莫桑比克','Mozambique'),(199,'country','264','纳米尼亚','Namibia'),(200,'country','674','瑙鲁','Nauru'),(201,'country','977','尼泊尔','Nepal'),(202,'country','31','荷兰','Netherlands'),(203,'country','599','荷属安的列斯','Netherlands Antilles'),(204,'country','687','新喀里多尼亚','New Caledonia'),(205,'country','64','新西兰','New Zealand'),(206,'country','505','尼加拉瓜','Nicaragua'),(207,'country','227','尼日尔','Niger'),(208,'country','234','尼日利亚','Nigeria'),(209,'country','683','纽埃','Niue'),(210,'country','6723','诺福克岛','Norfolk Island'),(211,'country','1','北马里亚纳','Northern Mariana Islands'),(212,'country','47','挪威','Norway'),(213,'country','968','阿曼','Oman'),(214,'country','92','巴基斯坦','Pakistan'),(215,'country','680','帕劳','Palau'),(216,'country','507','巴拿马','Panama'),(217,'country','675','巴布亚新几内亚','Papua New Guinea'),(218,'country','595','巴拉圭','Paraguay'),(219,'country','51','秘鲁','Peru'),(220,'country','63','菲律宾','Philippines'),(221,'country','48','波兰','Poland'),(222,'country','351','葡萄牙','Portugal'),(223,'country','1809','波多黎各','Puerto Rico'),(224,'country','974','卡塔尔','Qatar'),(225,'country','262','留尼汪','Reunion'),(226,'country','40','罗马尼亚','Romania'),(227,'country','7','俄罗斯','Russia'),(228,'country','250','卢旺达','Rwanda'),(229,'country','290','圣赫勒拿','Saint Helena'),(230,'country','1869','圣基茨和尼维斯','Saint Kitts and Nevis'),(231,'country','1758','圣卢西亚','Saint Lucia'),(232,'country','508','圣皮埃尔和密克隆','Saint Pierre and Miquelon'),(233,'country','1784','圣文森特和格林纳丁斯','Saint Vincent and the Grenadines'),(234,'country','685','萨摩亚','Samoa'),(235,'country','378','圣马力诺','San Marino'),(236,'country','239','圣多美和普林西比','Sao Tome and Principe'),(237,'country','966','沙特阿拉伯','Saudi Arabia'),(238,'country','221','塞内加尔','Senegal'),(239,'country','381','塞尔维亚和黑山','Serbia and Montenegro'),(240,'country','248','塞舌尔','Seychelles'),(241,'country','232','塞拉利','Sierra Leone'),(242,'country','65','新加坡','Singapore'),(243,'country','421','斯洛伐克','Slovakia'),(244,'country','386','斯洛文尼亚','Slovenia'),(245,'country','677','所罗门群岛','Solomon Islands'),(246,'country','252','索马里','Somalia'),(247,'country','27','南非','South Africa'),(248,'country','34','西班牙','Spain'),(249,'country','94','斯里兰卡','Sri Lanka'),(250,'country','249','苏丹','Sudan'),(251,'country','597','苏里南','Suriname'),(252,'country','47','斯瓦尔巴岛和扬马延岛','Svalbard'),(253,'country','268','斯威士兰','Swaziland'),(254,'country','46','瑞典','Sweden'),(255,'country','41','瑞士','Switzerland'),(256,'country','963','叙利亚','Syria'),(257,'country','886','台湾','Taiwan'),(258,'country','992','塔吉克斯坦','Tajikistan'),(259,'country','255','坦桑尼亚','Tanzania'),(260,'country','66','泰国','Thailand'),(261,'country','1242','巴哈马','The Bahamas'),(262,'country','220','冈比亚','The Gambia'),(263,'country','228','多哥','Togo'),(264,'country','690','托克劳','Tokelau'),(265,'country','676','汤加','Tonga'),(266,'country','1868','特立尼达和多巴哥','Trinidad and Tobago'),(267,'country','216','突尼斯','Tunisia'),(268,'country','90','土耳其','Turkey'),(269,'country','993','土库曼斯坦','Turkmenistan'),(270,'country','1649','特克斯和凯科斯群岛','Turks and Caicos Islands'),(271,'country','688','图瓦卢','Tuvalu'),(272,'country','256','乌干达','Uganda'),(273,'country','380','乌克兰','Ukraine'),(274,'country','971','阿拉伯联合酋长国','United Arab Emirates'),(275,'country','44','英国','United Kingdom'),(276,'country','1','美国','United States'),(277,'country','598','乌拉圭','Uruguay'),(278,'country','998','乌兹别克斯坦','Uzbekistan'),(279,'country','678','瓦努阿图','Vanuatu'),(280,'country','58','委内瑞拉','Venezuela'),(281,'country','84','越南','Vietnam'),(282,'country','1340','美属维尔京群岛','Virgin Islands'),(283,'country','681','瓦利斯和富图纳','Wallis and Futuna'),(284,'country','967','也门','Yemen'),(285,'country','260','赞比亚','Zambia'),(286,'country','263','津巴布韦','Zimbabwe'),(287,'forbidType','0','禁止出金','No Withdraw'),(288,'forbidType','1','允许转出','Withdraw'),(289,'trader_forbid_type','0','禁止开仓','No Open'),(290,'trader_forbid_type','1','禁止交易','No Trade'),(291,'compulsion_status','0','关闭','Close'),(292,'compulsion_status','1','开启','Open'),(293,'exchangeStatus','1','交易中','On Trade'),(294,'exchangeStatus','2','只可撤单','Only Cancel Order'),(295,'exchangeStatus','3','停止交易','No Trade'),(296,'operFuncDesc','1','客户信息管理','Customer Manager'),(297,'operType','4','登录','Login'),(298,'operType','5','登出','Logout'),(299,'operType','1','新增','Add'),(300,'operType','2','修改','Update'),(301,'operType','3','删除','Delete'),(302,'operFuncDesc','2','开户黑名单管理','Open Black List Manager'),(303,'operFuncDesc','4','客户分类管理','Customer Class Manager'),(304,'operFuncDesc','5','设置分类客户','Customer Class Set'),(305,'operFuncDesc','7','交易所管理','Exchange Manager'),(306,'operFuncDesc','8','币种管理','Currency Manager'),(307,'operFuncDesc','9','标的物管理','Underlying Manager'),(308,'operFuncDesc','10','创建新品种','Product Manager'),(309,'operFuncDesc','11','设置品种参数','Product Set'),(310,'operFuncDesc','12','设置挂牌基准价','Instrument Manager'),(311,'operFuncDesc','13','合约参数设置','Instrument Set'),(312,'operFuncDesc','14','交易手续费管理','Trade Fee Set '),(313,'operFuncDesc','15','交割手续费管理','Delivery Fee Set'),(314,'operFuncDesc','16','风险限额管理','Risk Limit '),(315,'operFuncDesc','17','客户提现管理','withdraw Manager'),(316,'operFuncDesc','18','邀请返佣参数设置','Invitation Set '),(317,'operFuncDesc','19','交易返佣参数设置','Trade Invitation Set '),(318,'operFuncDesc','20','全局出金设置','Risk Withdraw Limit'),(319,'operFuncDesc','21','交易权限设置','Trade Right Limit'),(320,'operFuncDesc','22','出入权限管理','Risk Withdraw Right Limit'),(321,'operFuncDesc','23','强平参数设置','Risk Mandatory Reduction Set'),(322,'operFuncDesc','24','垃圾用户管理','Rubicon User Manager '),(323,'warnType','1','短信','MsM'),(324,'warnType','2','邮件','Mail'),(325,'riskId','1','指数异常预警','Risk Index'),(326,'riskId','2','保险基金预警','Risk Capital'),(327,'riskId','3','垃圾委托预警','Risk Garbage'),(328,'warnLevel','1','一级','One'),(329,'warnLevel','2','二级','One'),(330,'warnLevel','3','三级','One'),(331,'warnLevel','4','四级','One'),(332,'warnLevel','5','五级','One'),(333,'crossMargin','0','全仓','All Position'),(334,'crossMargin','1','逐仓','Every Position'),(335,'instrumentStatus','0','未上市','Every Position'),(336,'instrumentStatus','1','上市','Every Position'),(337,'instrumentStatus','2','停牌','Every Position'),(338,'instrumentStatus','3','下市','Every Position'),(339,'instrumentStatus','4','终止','Every Position'),(340,'noticeStatus','0','已完成','Success'),(341,'noticeStatus','1','处理中','Add Noticing'),(342,'noticeStatus','2','处理中','Update Noticing'),(343,'noticeStatus','3','处理中','Delete Notice '),(344,'noticeStatus','4','交易返回失败','Notice Trade Error');

UNLOCK TABLES;

/*Data for the table `t_risk_withdraw_limit` */

LOCK TABLES `t_risk_withdraw_limit` WRITE;
/*!40000 ALTER TABLE `t_risk_withdraw_limit` DISABLE KEYS */;
INSERT INTO `t_risk_withdraw_limit` VALUES (2,'1',1553242793638,'admin');
/*!40000 ALTER TABLE `t_risk_withdraw_limit` ENABLE KEYS */;
UNLOCK TABLES;

/*Data for the table `t_identification_type` */

LOCK TABLES `t_identification_type` WRITE;
TRUNCATE t_identification_type;
insert  into `t_identification_type`(`id`,`identification_type`,`identification_name`,`operate_time`,`operator_id`) values (1,'1','身份证',20181211,'admin'),(2,'2','军官证',NULL,NULL),(3,'4','huzhao',NULL,NULL);

UNLOCK TABLES;


/*Data for the table `t_invitation_set` */

LOCK TABLES `t_invitation_set` WRITE;
TRUNCATE t_invitation_set;
insert  into `t_invitation_set`(`id`,`invitation_type`,`arithmetic`,`invitation_value`,`operate_time`,`operator_id`,`currency`) values (1,'0','2','0.0001000000',1545896347124,'ADMIN','XBT'),(2,'1','2','0.0008000000',1545896347124,'ADMIN','XBT'),(3,'2','2','0.0006000000',1545896347124,'ADMIN','XBT'),(4,'3','2','0.0002000000',1545896347124,'ADMIN','XBT'),(5,'4','2','0.0001000000',1545896347124,'ADMIN','XBT');

UNLOCK TABLES;


/*Data for the table `t_key_right_relation` */

LOCK TABLES `t_key_right_relation` WRITE;
TRUNCATE t_key_right_relation;
insert  into `t_key_right_relation`(`id`,`key_right`,`request_path`,`request_type`,`operate_time`,`operator_id`) values (2,'1','/api/v1/order','PUT',1546827823414,'admin'),(3,'1','/api/v1/order','POST',1546827823414,'admin'),(4,'1','/api/v1/order','GET',1546827823414,'admin'),(5,'1','/api/v1/order','DELETE',1546827823414,'admin');

UNLOCK TABLES;


/*Data for the table `t_risk_index` */

 -- 指数预警设置
LOCK TABLES `t_risk_index` WRITE;
TRUNCATE t_risk_index;
insert  into `t_risk_index`(`id`,`warn_type`,`risk_flag`,`peek_value`,`operate_time`,`warn_level`,`accounts`,`interval_time`) values (1,'2','261016','0.100',1545896347124,'1','suhb@quantdo.com.cn',5),(2,'2','261017','0.250',1545896347124,'1','suhb@quantdo.com.cn',5),(3,'2','261018','0.250',1545896347124,'1','suhb@quantdo.com.cn',5),(4,'2','261019','0.000',1545896347124,'1','suhb@quantdo.com.cn',5),(5,'2','261020','0.000',1545896347124,'1','suhb@quantdo.com.cn',5),(6,'2','261021','0.000',1545896347124,'1','suhb@quantdo.com.cn',5),(7,'2','261022','0.000',1545896347124,'1','suhb@quantdo.com.cn',5),(8,'2','261023','0.000',1545896347124,'1','suhb@quantdo.com.cn',5);

UNLOCK TABLES;

-- 保险基金预警设置
/*Data for the table `t_warn_insurance_fund` */

LOCK TABLES `t_warn_insurance_fund` WRITE;
/*!40000 ALTER TABLE `t_warn_insurance_fund` DISABLE KEYS */;
INSERT INTO `t_warn_insurance_fund` VALUES (4,'261024',NULL,NULL,'1','2',5,'sub@quantdo.com.cn','admin',1545896347124,'0',NULL),(5,'261025',2,1000000000.0000000000,'1','2',5,'sub@quantdo.com.cn','admin',1545896347124,'0',NULL),(6,'261026',NULL,1000000000.0000000000,'1','2',5,'sub@quantdo.com.cn','admin',1545896347124,'0',NULL),(7,'261027',NULL,500000000.0000000000,'1','2',5,'sub@quantdo.com.cn','admin',1545896347124,'0',NULL);
/*!40000 ALTER TABLE `t_warn_insurance_fund` ENABLE KEYS */;
UNLOCK TABLES;


/*Data for the table `t_system_config` */

LOCK TABLES `t_system_config` WRITE;
TRUNCATE t_system_config;
insert  into `t_system_config`(`id`,`config_key`,`config_value`) values (1,'invitationLevel','4'),(2,'automaticAdoptCheck','0'),(3,'automaticKycCheck','0');

UNLOCK TABLES;



/*Data for the table `t_currency` */

LOCK TABLES `t_currency` WRITE;
TRUNCATE t_currency;

insert into `t_currency` (`currency`, `currency_name`, `digits`, `min_withdraw_tick`, `min_withdraw_amount`, `recommend_withdraw_fee`, `min_withdraw_fee`, `block_chain_address`, `oper_id`, `oper_time`, `recheck_oper_id`, `recheck_oper_time`) values('XBT','XBTbit','1','1.0000000000','1.0000000000','1.0000000000','1.0000000000','1',NULL,'1551751787106',NULL,NULL);

UNLOCK TABLES;

 --  kyc认证所需限制额度
/*Data for the table `t_kyc_identify` */

LOCK TABLES `t_kyc_identify` WRITE;

insert  into `t_kyc_identify`(`id`,`currency`,`value`,`operate_time`,`operator_id`) values (1,'XBT','3.0000000000',1545896347124,'admin');

UNLOCK TABLES;



/*Data for the table `t_underlying` */

LOCK TABLES `t_underlying` WRITE;
/*!40000 ALTER TABLE `t_underlying` DISABLE KEYS */;
INSERT INTO `t_underlying` VALUES (1,'XBT-USD','比特币','1','ADMIN',1545807237,'ADMIN',1545807237);
/*!40000 ALTER TABLE `t_underlying` ENABLE KEYS */;
UNLOCK TABLES;

/*Data for the table `t_underlying_detail` */

LOCK TABLES `t_underlying_detail` WRITE;
/*!40000 ALTER TABLE `t_underlying_detail` DISABLE KEYS */;
INSERT INTO `t_underlying_detail` VALUES (1,'XBT-USD','KRAKEN','XBT-USD',0.3333),(4,'XBT-USD','COINBASE','BTC-USD',0.3333),(7,'XBT-USD','BITSTAMP','btcusd',0.3333),(13,'XBT-USD','BITMEX','.BXBT',0.3333);
/*!40000 ALTER TABLE `t_underlying_detail` ENABLE KEYS */;
UNLOCK TABLES;

/*   交易所状态  */
TRUNCATE t_risk_exchange_limit;
INSERT INTO `t_risk_exchange_limit` (`exchange_status`, `operate_time`, `operator_id`) VALUES('1','1545896347124','admin');



-- 初始化系统用户
TRUNCATE t_trade_user;
insert into `t_trade_user` (`application_id`, `user_id`, `user_name`, `country_code`, `email`, `nick_name`, `password`, `invite_code`, `account_password`, `registered_rake_back`, `identification_type`, `identification_id`, `apply_status`, `level`, `google_status`, `secret`, `message_switch`, `is_active`, `telephone`, `id_back_photo`, `id_front_photo`, `self_card_photo`, `client_channel`, `register_time`, `recheck_time`, `rechecker_id`, `reject_remark`, `remark`, `user_type`, `old_id`, `notice_status`) values('qm8EH9sV','9752877235',NULL,NULL,'yinkangxi1@gmail.com',NULL,'30753214d78a4f77828e0277a24fe450',NULL,NULL,NULL,NULL,NULL,'4','2345678',NULL,'OVW5Z2A4PUNKVTSN','1',NULL,NULL,NULL,NULL,NULL,NULL,'1560804365890',NULL,NULL,NULL,NULL,'2',NULL,'0');
insert into `t_trade_user` (`application_id`, `user_id`, `user_name`, `country_code`, `email`, `nick_name`, `password`, `invite_code`, `account_password`, `registered_rake_back`, `identification_type`, `identification_id`, `apply_status`, `level`, `google_status`, `secret`, `message_switch`, `is_active`, `telephone`, `id_back_photo`, `id_front_photo`, `self_card_photo`, `client_channel`, `register_time`, `recheck_time`, `rechecker_id`, `reject_remark`, `remark`, `user_type`, `old_id`, `notice_status`) values('8UFc4nAo','7828251072',NULL,NULL,'yinkangxi2@gmail.com',NULL,'457382aa003f49e1c335ac1832d504c6',NULL,NULL,NULL,NULL,NULL,'4','2345678',NULL,'VR25NDHYFBRMDT42','1',NULL,NULL,NULL,NULL,NULL,NULL,'1560804365890',NULL,NULL,NULL,NULL,'3',NULL,'0');
insert into `t_trade_user` (`application_id`, `user_id`, `user_name`, `country_code`, `email`, `nick_name`, `password`, `invite_code`, `account_password`, `registered_rake_back`, `identification_type`, `identification_id`, `apply_status`, `level`, `google_status`, `secret`, `message_switch`, `is_active`, `telephone`, `id_back_photo`, `id_front_photo`, `self_card_photo`, `client_channel`, `register_time`, `recheck_time`, `rechecker_id`, `reject_remark`, `remark`, `user_type`, `old_id`, `notice_status`) values('8r7SdDOq','8949355047',NULL,NULL,'yinkangxi3@gmail.com',NULL,'d21c3cb58ef185e465b3e0ca8a0d19f3',NULL,NULL,NULL,NULL,NULL,'4','2345678',NULL,'K3LGAB47NI3S47HA','1',NULL,NULL,NULL,NULL,NULL,NULL,'1560804365890',NULL,NULL,NULL,NULL,'4',NULL,'0');
insert into `t_trade_user` (`application_id`, `user_id`, `user_name`, `country_code`, `email`, `nick_name`, `password`, `invite_code`, `account_password`, `registered_rake_back`, `identification_type`, `identification_id`, `apply_status`, `level`, `google_status`, `secret`, `message_switch`, `is_active`, `telephone`, `id_back_photo`, `id_front_photo`, `self_card_photo`, `client_channel`, `register_time`, `recheck_time`, `rechecker_id`, `reject_remark`, `remark`, `user_type`, `old_id`, `notice_status`) values('cE5e1WFv','6789776272',NULL,NULL,'yinkangxi4@gmail.com',NULL,'0d7e0debc3ee70621111434f88af721a','',NULL,'0.0001000000',NULL,NULL,'1',NULL,NULL,'DVQSCAMEDXJRVKJ6','1','1',NULL,NULL,NULL,NULL,NULL,'1556872440059',NULL,NULL,NULL,NULL,'5',NULL,'0');


-- 初始化系统用户资金
TRUNCATE t_account_capital;
insert into `t_account_capital` (`account_id`, `user_id`, `currency`, `balance`, `avail_balance`, `margin_balance`, `positionl_margin`, `order_margin`, `unrealised_pnl`, `transfer_in`, `transfer_out`, `deposited`, `withdrawn`, `realised_pnl`, `update_time`) values('4416046734','9752877235','XBT','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000',NULL);
insert into `t_account_capital` (`account_id`, `user_id`, `currency`, `balance`, `avail_balance`, `margin_balance`, `positionl_margin`, `order_margin`, `unrealised_pnl`, `transfer_in`, `transfer_out`, `deposited`, `withdrawn`, `realised_pnl`, `update_time`) values('9734990447','7828251072','XBT','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000',NULL);
insert into `t_account_capital` (`account_id`, `user_id`, `currency`, `balance`, `avail_balance`, `margin_balance`, `positionl_margin`, `order_margin`, `unrealised_pnl`, `transfer_in`, `transfer_out`, `deposited`, `withdrawn`, `realised_pnl`, `update_time`) values('9380754040','8949355047','XBT','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000',NULL);
insert into `t_account_capital` (`account_id`, `user_id`, `currency`, `balance`, `avail_balance`, `margin_balance`, `positionl_margin`, `order_margin`, `unrealised_pnl`, `transfer_in`, `transfer_out`, `deposited`, `withdrawn`, `realised_pnl`, `update_time`) values('5926325374','6789776272','XBT','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000','0.0000000000',NULL);


-- 初始化系统用户ApiKey
TRUNCATE t_api_key;
insert into `t_api_key` (`user_id`, `key_id`, `key_type`, `key_name`, `cidr`, `key_right`, `secret_key`, `is_active`, `operate_time`, `operator_id`) values('9752877235','wPk4bZUvj4gvI9M9TI92','1','系统默认Key',NULL,'0','vUV7J9vcZAX47gwNEhn3AE99aA8f9Z3Qp4VLsJt1jQn244Q8jHPMR0aW87mZ2ir1Wblha74A9t28FcBSS1712u8kCZtpzsKc14s','1','1550631448291',NULL);
insert into `t_api_key` (`user_id`, `key_id`, `key_type`, `key_name`, `cidr`, `key_right`, `secret_key`, `is_active`, `operate_time`, `operator_id`) values('7828251072','c15n92D8iLfQO0sALXsk','1','系统默认Key',NULL,'0','CH3eVm3d3vFej6a3t1B8l4scEk80VpK799LOGI63yXtw0DBhhEeA95LVE35jOa1OjCM3W0gRksYK2CG5w8329H9i6vbTXg7rs2t','1','1550632430331',NULL);
insert into `t_api_key` (`user_id`, `key_id`, `key_type`, `key_name`, `cidr`, `key_right`, `secret_key`, `is_active`, `operate_time`, `operator_id`) values('8949355047','yk50vqxvDVLm2R6F58XQ','1','系统默认Key',NULL,'0','kCS23OpnB3m0thTpDa05IAG0EgX2jcD58kcWj07U9IE08J23xO888pVvrz47X7DfVzm18ViqUYF7Er11GqaFB6ZxjhS42oo09Uq','1','1550644354307',NULL);
insert into `t_api_key` (`user_id`, `key_id`, `key_type`, `key_name`, `cidr`, `key_right`, `secret_key`, `is_active`, `operate_time`, `operator_id`) values('6789776272','Qz88v8QkG7T5Skm2JgGd','1','系统默认Key',NULL,'0','R5qE1b4gk0Xf5WSRUc53Z9xN606591vii3RgBWCSgbfR1DPP6I78r5qCox2upyB5Zj5N773THNa30xanb2108r2pBeVcWfBQgPK','1','1556872440055',NULL);

-- 委托事前风控参数设置
LOCK TABLES `t_order_prompt` WRITE;
/*!40000 ALTER TABLE `t_order_prompt` DISABLE KEYS */;
INSERT INTO `t_order_prompt` VALUES (1,'buy','1',0.00100000,'admin',1545896347124,'0',NULL),(2,'buy','2',0.05000000,'admin',1545896347124,'0',NULL),(3,'buy','3',0.05000000,'admin',1545896347124,'0',NULL),(4,'sell','1',0.00100000,'admin',1545896347124,'0',NULL),(5,'sell','2',0.05000000,'admin',1545896347124,'0',NULL),(6,'sell','3',0.05000000,NULL,1545896347124,'0',NULL);
/*!40000 ALTER TABLE `t_order_prompt` ENABLE KEYS */;
UNLOCK TABLES;

--  垃圾委托用户参数设置

LOCK TABLES `t_warn_garbage_user_set` WRITE;
TRUNCATE t_warn_garbage_user_set;
insert  into `t_warn_garbage_user_set`(`id`,`prompt_flag`,`amount`,`value`,`operate_time`,`operator_id`) values (1,'1',NULL,'0.0250000000',1545896347124,'admin'),(2,'2',20,'0.0250000000',1545896347124,'admin');
UNLOCK TABLES;

-- 一期 刷进去的 数据    二期 品种，合约自动生成时候不可以刷

-- 品种及相关刷库
LOCK TABLES `t_product` WRITE;
/*!40000 ALTER TABLE `t_product` DISABLE KEYS */;
INSERT INTO `t_product` VALUES (2,'XBT','BTC比特币','XBT-USD','1','XBT','1','XBT','XBT',1,'1','1',1550645616397,'admin',1550645616397,'admin','1',21.000000,'1','1');
/*!40000 ALTER TABLE `t_product` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `t_deliv_fee_set` WRITE;
/*!40000 ALTER TABLE `t_deliv_fee_set` DISABLE KEYS */;
INSERT INTO `t_deliv_fee_set` VALUES (2,'XBT',NULL,NULL,'1',0.0200000000,0.0000000000,1553049611369,NULL,NULL,'0');
/*!40000 ALTER TABLE `t_deliv_fee_set` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `t_trade_fee_set` WRITE;
/*!40000 ALTER TABLE `t_trade_fee_set` DISABLE KEYS */;
INSERT INTO `t_trade_fee_set` VALUES (115,'XBT',NULL,NULL,'1',-0.0002500000,0.0007500000,0.0000000000,0.0000000000,1555590039518,NULL,NULL,'0');
/*!40000 ALTER TABLE `t_trade_fee_set` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `t_risk_limit` WRITE;
/*!40000 ALTER TABLE `t_risk_limit` DISABLE KEYS */;
INSERT INTO `t_risk_limit` VALUES (11,'XBT',NULL,NULL,20000000000,10000000000,9,0.00500000,0.01000000,'admin',1555980569597,NULL,'0');
/*!40000 ALTER TABLE `t_risk_limit` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `t_risk_leverage_point_detail` WRITE;
/*!40000 ALTER TABLE `t_risk_leverage_point_detail` DISABLE KEYS */;
INSERT INTO `t_risk_leverage_point_detail` VALUES (1,'XBT',20000000000,1.00),(2,'XBT',20000000000,2.00),(3,'XBT',20000000000,3.00),(4,'XBT',20000000000,5.00),(5,'XBT',20000000000,10.00),(6,'XBT',20000000000,25.00),(7,'XBT',20000000000,50.00),(8,'XBT',20000000000,100.00),(13,'XBT',30000000000,1.00),(14,'XBT',30000000000,2.00),(15,'XBT',30000000000,3.00),(16,'XBT',30000000000,5.00),(17,'XBT',30000000000,10.00),(18,'XBT',30000000000,25.00),(19,'XBT',30000000000,50.00),(20,'XBT',30000000000,66.60),(21,'XBT',40000000000,1.00),(22,'XBT',40000000000,2.00),(23,'XBT',40000000000,3.00),(24,'XBT',40000000000,5.00),(25,'XBT',40000000000,10.00),(26,'XBT',40000000000,25.00),(27,'XBT',40000000000,35.00),(28,'XBT',40000000000,50.00),(29,'XBT',50000000000,1.00),(30,'XBT',50000000000,2.00),(31,'XBT',50000000000,3.00),(32,'XBT',50000000000,5.00),(33,'XBT',50000000000,10.00),(34,'XBT',50000000000,25.00),(35,'XBT',50000000000,33.30),(36,'XBT',50000000000,40.00),(37,'XBT',60000000000,1.00),(38,'XBT',60000000000,2.00),(39,'XBT',60000000000,3.00),(40,'XBT',60000000000,5.00),(41,'XBT',60000000000,10.00),(42,'XBT',60000000000,25.00),(43,'XBT',60000000000,33.30),(44,'XBT',70000000000,1.00),(45,'XBT',70000000000,2.00),(46,'XBT',70000000000,3.00),(47,'XBT',70000000000,5.00),(48,'XBT',70000000000,10.00),(49,'XBT',70000000000,15.00),(50,'XBT',70000000000,20.00),(51,'XBT',70000000000,25.00),(52,'XBT',70000000000,28.50),(53,'XBT',80000000000,1.00),(54,'XBT',80000000000,2.00),(55,'XBT',80000000000,3.00),(56,'XBT',80000000000,5.00),(57,'XBT',80000000000,10.00),(58,'XBT',80000000000,15.00),(59,'XBT',80000000000,20.00),(60,'XBT',80000000000,25.00),(61,'XBT',90000000000,1.00),(62,'XBT',90000000000,2.00),(63,'XBT',90000000000,3.00),(64,'XBT',90000000000,4.00),(65,'XBT',90000000000,5.00),(66,'XBT',90000000000,10.00),(67,'XBT',90000000000,15.00),(68,'XBT',90000000000,20.00),(69,'XBT',90000000000,22.20),(70,'XBT',100000000000,1.00),(71,'XBT',100000000000,2.00),(72,'XBT',100000000000,3.00),(73,'XBT',100000000000,4.00),(74,'XBT',100000000000,5.00),(75,'XBT',100000000000,10.00),(76,'XBT',100000000000,15.00),(77,'XBT',100000000000,20.00),(78,'XBT',110000000000,1.00),(79,'XBT',110000000000,2.00),(80,'XBT',110000000000,3.00),(81,'XBT',110000000000,4.00),(82,'XBT',110000000000,5.00),(83,'XBT',110000000000,10.00),(84,'XBT',110000000000,15.00),(85,'XBT',110000000000,18.10);
/*!40000 ALTER TABLE `t_risk_leverage_point_detail` ENABLE KEYS */;
UNLOCK TABLES;


-- 合约及相关刷库

LOCK TABLES `t_instrument` WRITE;
/*!40000 ALTER TABLE `t_instrument` DISABLE KEYS */;
INSERT INTO `t_instrument` VALUES (2,'XBTUSD','比特币永续','XBT','1','XBT-USD','3',1.0000000000,0.5000000000,'1','1','USD','XBT','1',10000.0000000000,3,'20190227','20190227','20991227',-100000000,'20991227','0','20991227','20991227','20991227','20991227','20991227','20991227','20991227','1902','12','XBTUSDP','1',3500.0000000000,'0','1',1,1,0.0003000000,0.0006000000,'1',3500.0000000000,'1','1','1','1','2','admin',1550645616397,'admin',1550645616397,1,10000000);
/*!40000 ALTER TABLE `t_instrument` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `t_risk_mandatory_reduction_set` WRITE;
/*!40000 ALTER TABLE `t_risk_mandatory_reduction_set` DISABLE KEYS */;
INSERT INTO `t_risk_mandatory_reduction_set` VALUES (2,'XBT','XBTUSD',1.0000000000,200.000000,3600,10000,1,'0',1555590607402,'admin',NULL,'0');
/*!40000 ALTER TABLE `t_risk_mandatory_reduction_set` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `t_price_band_detail` WRITE;
/*!40000 ALTER TABLE `t_price_band_detail` DISABLE KEYS */;
INSERT INTO `t_price_band_detail` VALUES (1,'XBTUSD','4','4','4','2','1',5.0000000000,0.9000000000,'admin',1551439903064,'admin',1551439903064);
/*!40000 ALTER TABLE `t_price_band_detail` ENABLE KEYS */;
UNLOCK TABLES;
