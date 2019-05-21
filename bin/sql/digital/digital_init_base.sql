/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 10.3.11-MariaDB : Database - digital
*********************************************************************
*/

USE `digital`;


/*Data for the table `t_dict` */

LOCK TABLES `t_dict` WRITE;
TRUNCATE t_dict;
insert  into `t_dict`(`id`,`dict_class`,`dict_value`,`dict_name_cn`,`dict_name_en`) values (1,'applyStatus','0','注册完成','Register'),(2,'applyStatus','1','邮箱验证已打开','Email Checked'),(3,'applyStatus','2','证件审核已提交','Identity Submit'),(4,'applyStatus','3','证件审核已驳回','Identity Refuse'),(5,'applyStatus','4','证件审核已通过','Idengtidy Adops'),(6,'applyStatus','7','正常','Active'),(7,'applyStatus','8','冻结','Frozen'),(8,'driction','0','买','Buy'),(9,'driction','1','卖','Sell'),(10,'cycleType','1','周','Week'),(11,'cycleType','2','月','Month'),(12,'cycleType','3','永续','Sustainable'),(13,'productStatus','1','待审核','To Be Audited'),(14,'productStatus','2','未上市','Unlisted'),(15,'productStatus','3','上市','On The Marke'),(16,'productStatus','4','退市','Delisting'),(17,'productType','1','期货','Futures'),(18,'productType','2','期权','Option'),(19,'tradeMode','1','永续反向','Sustainable Reverse'),(20,'tradeMode','3','定期反向','Regular Reverse'),(21,'delivSeriesType','1','周','Week'),(22,'delivSeriesType','2','近月','Month'),(23,'delivSeriesType','3','季月','Quarter'),(24,'positionType','1','综合持仓','All Position'),(25,'positionType','2','单边持仓','Side Position'),(26,'feeMode','1','百分比','Percentage'),(27,'feeMode','2','绝对值','Absolute VALUE'),(28,'week','1','周一','Monday'),(29,'week','2','周二','Tuesday'),(30,'week','3','周三','Wednesday'),(31,'week','4','周四','Thursday'),(32,'week','5','周五','Friday'),(33,'week','6','周六','Saturated'),(34,'week','7','周日','Sunday'),(35,'order','1','正数','Asc'),(36,'order','2','倒数','Desc'),(37,'tradeMode','4','定期正向','Regular Forward'),(38,'tradeMode','2','永续正向','Sustainable Forward'),(39,'underlyingType','1','现货指数','Spot Index'),(40,'rakeBack','0','注册送币数量',NULL),(41,'rakeBack','1','邀请一级返币数量',NULL),(42,'rakeBack','2','邀请二级返币数量',NULL),(43,'rakeBack','3','邀请三级返币数量',NULL),(44,'rakeBack','4','邀请四级返币数量',NULL),(45,'tradeRakeBack','1','一级交易返币',NULL),(46,'tradeRakeBack','2','二级交易返币',NULL),(47,'tradeRakeBack','3','三级交易返币',NULL),(48,'tradeRakeBack','4','四级交易返币',NULL),(49,'rakeBackType','1','邀请返币',NULL),(50,'rakeBackType','2','交易返币',NULL),(51,'invitationLevel','1','一级','Level One'),(52,'invitationLevel','2','二级','Level Two'),(53,'invitationLevel','3','三级','Level Three'),(54,'invitationLevel','4','四级','Level Four'),(55,'forbidType','0','禁止出金','No Withdraw'),(56,'forbidType','1','允许转出','Withdraw'),(57,'trader_forbid_type','0','禁止开仓','No Open'),(58,'trader_forbid_type','1','禁止交易','No Trade'),(59,'compulsion_status','0','关闭','Close'),(60,'compulsion_status','1','开启','Open'),(61,'exchangeStatus','1','交易中','On Trade'),(62,'exchangeStatus','2','只可撤单','Only Cancel Order'),(63,'exchangeStatus','3','停止交易','No Trade'),(64,'operFuncDesc','1','客户信息管理','Customer Manager'),(65,'operType','4','登录','Login'),(66,'operType','5','登出','Logout'),(67,'operType','1','新增','Add'),(68,'operType','2','修改','Update'),(69,'operType','3','删除','Delete'),(70,'operFuncDesc','2','开户黑名单管理','Open Black List Manager'),(71,'operFuncDesc','4','客户分类管理','Customer Class Manager'),(72,'operFuncDesc','5','设置分类客户','Customer Class Set'),(73,'operFuncDesc','7','交易所管理','Exchange Manager'),(74,'operFuncDesc','8','币种管理','Currency Manager'),(75,'operFuncDesc','9','标的物管理','Underlying Manager'),(76,'operFuncDesc','10','创建新品种','Product Manager'),(77,'operFuncDesc','11','设置品种参数','Product Set'),(78,'operFuncDesc','12','设置挂牌基准价','Instrument Manager'),(79,'operFuncDesc','13','合约参数设置','Instrument Set'),(80,'operFuncDesc','14','交易手续费管理','Trade Fee Set '),(81,'operFuncDesc','15','交割手续费管理','Delivery Fee Set'),(82,'operFuncDesc','16','风险限额管理','Risk Limit '),(83,'operFuncDesc','17','客户提现管理','withdraw Manager'),(84,'operFuncDesc','18','邀请返佣参数设置','Invitation Set '),(85,'operFuncDesc','19','交易返佣参数设置','Trade Invitation Set '),(86,'operFuncDesc','20','全局出金设置','Risk Withdraw Limit'),(87,'operFuncDesc','21','交易权限设置','Trade Right Limit'),(88,'operFuncDesc','22','出入权限管理','Risk Withdraw Right Limit'),(89,'operFuncDesc','23','强平参数设置','Risk Mandatory Reduction Set'),(90,'operFuncDesc','24','垃圾用户管理','Rubicon User Manager '),(91,'warnType','1','短信','MsM'),(92,'warnType','2','邮件','Mail'),(93,'riskId','1','指数异常预警','Risk Index'),(94,'riskId','2','保险基金预警','Risk Capital'),(95,'riskId','3','垃圾委托预警','Risk Garbage'),(96,'warnLevel','1','一级','One'),(97,'warnLevel','2','二级','One'),(98,'warnLevel','3','三级','One'),(99,'warnLevel','4','四级','One'),(100,'warnLevel','5','五级','One'),(101,'crossMargin','0','全仓','All Position'),(102,'crossMargin','1','逐仓','Every Position'),(103,'instrumentStatus','0','未上市','Every Position'),(104,'instrumentStatus','1','上市','Every Position'),(105,'instrumentStatus','2','停牌','Every Position'),(106,'instrumentStatus','3','下市','Every Position'),(107,'instrumentStatus','4','终止','Every Position'),(108,'noticeStatus','0','已完成','Success'),(109,'noticeStatus','1','处理中','Add Noticing'),(110,'noticeStatus','2','处理中','Update Noticing'),(111,'noticeStatus','3','处理中','Delete Notice '),(112,'noticeStatus','4','交易返回失败','Notice Trade Error'),(113,'country','00244','安哥拉','Angola'),(114,'country','00355','阿尔巴尼亚','Albania'),(115,'country','00213','阿尔及利亚','Algeria'),(116,'country','00376','安道尔共和国','Andorra'),(117,'country','001264','安圭拉岛','Anguilla'),(118,'country','001268','安提瓜和巴布达','Antigua and Barbuda'),(119,'country','0054','阿根廷','Argentina'),(120,'country','00374','亚美尼亚','Armenia'),(121,'country','00247','阿森松','Ascension'),(122,'country','0061','澳大利亚','Australia'),(123,'country','0043','奥地利','Austria'),(124,'country','00994','阿塞拜疆','Azerbaijan'),(125,'country','001242','巴哈马','Bahamas'),(126,'country','00973','巴林','Bahrain'),(127,'country','001246','巴巴多斯','Barbados'),(128,'country','0032','比利时','Belgium'),(129,'country','00501','伯利兹','Belize'),(130,'country','00229','贝宁','Benin'),(131,'country','001441','百慕大群岛','Bermuda'),(132,'country','00267','博茨瓦纳','Botswana'),(133,'country','0055','巴西','Brazil'),(134,'country','00673','文莱','Brunei'),(135,'country','00359','保加利亚','Bulgaria'),(136,'country','00226','布基纳法索','Burkina Faso'),(137,'country','00257','布隆迪','Burundi'),(138,'country','001','加拿大','Canada'),(139,'country','001345','开曼群岛','Cayman Islands.'),(140,'country','0056','智利','Chile'),(141,'country','0086','中国','China'),(142,'country','0057','哥伦比亚','Colombia'),(143,'country','00682','库克群岛','Cook Islands.'),(144,'country','00506','哥斯达黎加','Costa Rica'),(145,'country','00357','塞浦路斯','Cyprus'),(146,'country','00420','捷克','Czech Republic'),(147,'country','0045','丹麦','Denmark'),(148,'country','00253','吉布提','Djibouti'),(149,'country','001809','多米尼加共和国','Dominican Republic'),(150,'country','0020','埃及','Egypt'),(151,'country','00503','萨尔瓦多','El Salvador'),(152,'country','00372','爱沙尼亚','Estonia'),(153,'country','00251','埃塞俄比亚','Ethiopia'),(154,'country','00679','斐济','Fiji'),(155,'country','00358','芬兰','Finland'),(156,'country','0033','法国','France'),(157,'country','00594','法属圭亚那','French Guiana'),(158,'country','00241','加蓬','Gabon'),(159,'country','00220','冈比亚','Gambia'),(160,'country','00995','格鲁吉亚','Georgia'),(161,'country','0049','德国','Germany'),(162,'country','00233','加纳','Ghana'),(163,'country','00350','直布罗陀','Gibraltar'),(164,'country','0030','希腊','Greece'),(165,'country','001473','格林纳达','Grenada'),(166,'country','001671','关岛','Guam'),(167,'country','00502','危地马拉','Guatemala'),(168,'country','00592','圭亚那','Guyana'),(169,'country','00509','海地','Haiti'),(170,'country','00504','洪都拉斯','Honduras'),(171,'country','00852','中国香港','Hong Kong (China)'),(172,'country','0036','匈牙利','Hungary'),(173,'country','00354','冰岛','Iceland'),(174,'country','0091','印度','India'),(175,'country','0062','印度尼西亚','Indonesia'),(176,'country','00353','爱尔兰','Ireland'),(177,'country','00972','以色列','Israel'),(178,'country','0039','意大利','Italy'),(179,'country','001876','牙买加','Jamaica'),(180,'country','0081','日本','Japan'),(181,'country','00962','约旦','Jordan'),(182,'country','00855','柬埔寨','Cambodia'),(183,'country','007','哈萨克斯坦','Kazakstan'),(184,'country','00254','肯尼亚','Kenya'),(185,'country','0082','韩国','Korea'),(186,'country','00965','科威特','Kuwait'),(187,'country','00996','吉尔吉斯坦','Kyrgyzstan'),(188,'country','00856','老挝','Laos'),(189,'country','00371','拉脱维亚','Latvia'),(190,'country','00266','莱索托','Lesotho'),(191,'country','00423','列支敦士登','Liechtenstein'),(192,'country','00370','立陶宛','Lithuania'),(193,'country','00352','卢森堡','Luxembourg'),(194,'country','00261','马达加斯加','Madagascar'),(195,'country','00265','马拉维','Malawi'),(196,'country','0060','马来西亚','Malaysia'),(197,'country','00960','马尔代夫','Maldives'),(198,'country','00223','马里','Mali'),(199,'country','00356','马耳他','Malta'),(200,'country','00223','马里亚那群岛','Mariana Islands'),(201,'country','00596','马提尼克','Martinique'),(202,'country','00230','毛里求斯','Mauritius'),(203,'country','0052','墨西哥','Mexico'),(204,'country','00373','摩尔多瓦','Moldova'),(205,'country','00377','摩纳哥','Monaco'),(206,'country','00976','蒙古','Mongolia'),(207,'country','001664','蒙特塞拉特岛','Montserrat'),(208,'country','00212','摩洛哥','Morocco'),(209,'country','00258','莫桑比克','Mozambique'),(210,'country','00264','纳米比亚','Namibia'),(211,'country','00674','瑙鲁','Nauru'),(212,'country','00977','尼泊尔','Nepal'),(213,'country','00599','荷属安的列斯','Netheriands Antilles'),(214,'country','0031','荷兰','Netherlands'),(215,'country','0064','新西兰','New Zealand'),(216,'country','00505','尼加拉瓜','Nicaragua'),(217,'country','00227','尼日尔','Niger'),(218,'country','00234','尼日利亚','Nigeria'),(219,'country','0047','挪威','Norway'),(220,'country','00968','阿曼','Oman'),(221,'country','00507','巴拿马','Panama'),(222,'country','00675','巴布亚新几内亚','Papua New Cuinea'),(223,'country','00595','巴拉圭','Paraguay'),(224,'country','0051','秘鲁','Peru'),(225,'country','0063','菲律宾','Philippines'),(226,'country','0048','波兰','Poland'),(227,'country','00689','法属玻利尼西亚','French Polynesia'),(228,'country','00351','葡萄牙','Portugal'),(229,'country','001','波多黎各','Puerto Rico'),(230,'country','00974','卡塔尔','Qatar'),(231,'country','00262','留尼旺','Reunion'),(232,'country','0040','罗马尼亚','Romania'),(233,'country','007','俄罗斯','Russia'),(234,'country','001758','圣卢西亚','Saint Lueia'),(235,'country','001784','圣文森特岛','Saint Vincent'),(236,'country','00684','东萨摩亚(美)','Samoa Eastern'),(237,'country','00685','西萨摩亚','Samoa Western'),(238,'country','00378','圣马力诺','San Marino'),(239,'country','00239','圣多美和普林西比','Sao Tome and Principe'),(240,'country','00966','沙特阿拉伯','Saudi Arabia'),(241,'country','00221','塞内加尔','Senegal'),(242,'country','00248','塞舌尔','Seychelles'),(243,'country','00232','塞拉利昂','Sierra Leone'),(244,'country','0065','新加坡','Singapore'),(245,'country','00421','斯洛伐克','Slovakia'),(246,'country','00386','斯洛文尼亚','Slovenia'),(247,'country','00677','所罗门群岛','Solomon Islands'),(248,'country','0034','西班牙','Spain'),(249,'country','0094','斯里兰卡','Sri Lanka'),(250,'country','001758','圣卢西亚','St.Lucia'),(251,'country','001784','圣文森特','St.Vincent'),(252,'country','00597','苏里南','Suriname'),(253,'country','00268','斯威士兰','Swaziland'),(254,'country','0046','瑞典','Sweden'),(255,'country','0041','瑞士','Switzerland'),(256,'country','00886','中国台湾','Taiwan (China)'),(257,'country','00992','塔吉克斯坦','Tajikstan'),(258,'country','00255','坦桑尼亚','Tanzania'),(259,'country','0066','泰国','Thailand'),(260,'country','00228','多哥','Togo'),(261,'country','00676','汤加','Tonga'),(262,'country','001868','特立尼达和多巴哥','Trinidad and Tobago'),(263,'country','00216','突尼斯','Tunisia'),(264,'country','0090','土耳其','Turkey'),(265,'country','00993','土库曼斯坦','Turkmenistan'),(266,'country','00256','乌干达','Uganda'),(267,'country','00380','乌克兰','Ukraine'),(268,'country','00971','阿拉伯联合酋长国','United Arab Emirates'),(269,'country','0044','英国','United Kingdom'),(270,'country','00598','乌拉圭','Uruguay'),(271,'country','00998','乌兹别克斯坦','Uzbekistan'),(272,'country','0058','委内瑞拉','Venezuela'),(273,'country','0084','越南','Vietnam'),(274,'country','00338','南斯拉夫','Yugoslavia'),(275,'country','00263','津巴布韦','Zimbabwe'),(276,'country','00243','扎伊尔','Zaire'),(277,'country','00260','赞比亚','Zambia'),(278,'country','00297','阿鲁巴','Aruba'),(279,'country','00672','澳大利亚海外领地','Australianoverseasterritories'),(280,'country','00975','不丹','Bhutan'),(281,'country','00387','波斯尼亚和黑塞哥维那','BosniaandHerzegovina'),(282,'country','00238','佛得角','CapeVerde'),(283,'country','00269','科摩罗群岛','ComorosIslands'),(284,'country','00385','克罗地亚','Croatia'),(285,'country','00246','迭戈加西亚群岛','DiegoGarcia'),(286,'country','00670','东帝汶','EastTimor'),(287,'country','00240','赤道几内亚','EquatorialGuinea'),(288,'country','00291','厄立特里亚','Eritrea'),(289,'country','00500','福克兰群岛','FalklandIslands'),(290,'country','00298','法罗群岛','FaroeIslands'),(291,'country','00299','格陵兰岛','Greenland'),(292,'country','00590','瓜德罗普','Guadeloupe'),(293,'country','00245','几内亚比绍','Guinea-Bissau'),(294,'country','00686','基里巴斯','Kiribati'),(295,'country','00389','马其顿','Macedonia'),(296,'country','00692','马绍尔群岛','Marshall Islands'),(297,'country','00222','毛里塔尼亚','Mauritania'),(298,'country','00691','密克罗尼西亚','Micronesia'),(299,'country','00382','黑山','Montenegro'),(300,'country','00687','新喀里多尼亚','NewCaledonia'),(301,'country','00683','纽埃岛','Niue'),(302,'country','00680','帕劳','Palau'),(303,'country','00970','巴勒斯坦','Palestine'),(304,'country','00250','卢旺达','Rwanda'),(305,'country','00290','圣赫勒拿岛','St.Helena'),(306,'country','00508','圣皮埃尔和密克隆群岛','SaintPierreandMiquelon'),(307,'country','00381','塞尔维亚','Serbia'),(308,'country','00690','托克劳群岛','Tokelau'),(309,'country','00688','图瓦卢','Tuvalu'),(310,'country','00678','瓦努阿图','Vanuatu'),(311,'country','00379','梵蒂冈城','VaticanCity'),(312,'country','00681','瓦利斯和富图纳','WallisandFutuna'),(313,'country','001284','英属维尔京群岛','British Virgin Islands'),(314,'country','009714','迪拜酋长国','Emirate of Dubai');

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
