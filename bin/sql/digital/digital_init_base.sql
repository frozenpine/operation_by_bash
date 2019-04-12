/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 10.3.11-MariaDB : Database - digital
*********************************************************************
*/

USE `digital`;


/*Data for the table `t_dict` */

LOCK TABLES `t_dict` WRITE;
TRUNCATE t_dict;

insert  into `t_dict`(`id`,`dict_class`,`dict_value`,`dict_name_cn`,`dict_name_en`) values (1,'applyStatus','0','注册完成','Register'),(2,'applyStatus','1','邮箱验证已打开','Email Checked'),(3,'applyStatus','2','证件审核已提交','Identity Submit'),(4,'applyStatus','3','证件审核已驳回','Identity Refuse'),(5,'applyStatus','4','证件审核已通过','Idengtidy Adops'),(6,'applyStatus','5','两步验证已通过','Double Checked'),(7,'applyStatus','6','资金密码已设置','Account Password Set'),(8,'applyStatus','7','正常','Active'),(9,'applyStatus','8','冻结','Frozen'),(211,'driction','0','买','Buy'),(212,'driction','1','卖','Sell'),(213,'cycleType','1','周','Week'),(214,'cycleType','2','月','Month'),(215,'cycleType','3','永续','Sustainable'),(216,'productStatus','1','待审核','To Be Audited'),(217,'productStatus','2','未上市','Unlisted'),(218,'productStatus','3','上市','On The Marke'),(219,'productStatus','4','退市','Delisting'),(220,'productType','1','期货','Futures'),(221,'productType','2','期权','Option'),(222,'tradeMode','1','永续反向','Sustainable Reverse'),(223,'tradeMode','3','定期反向','Regular Reverse'),(224,'delivSeriesType','1','周','Week'),(225,'delivSeriesType','2','近月','Month'),(226,'delivSeriesType','3','季月','Quarter'),(227,'positionType','1','综合持仓','All Position'),(228,'positionType','2','单边持仓','Side Position'),(229,'feeMode','1','百分比',NULL),(230,'feeMode','2','绝对值',NULL),(231,'week','1','周一','Monday'),(232,'week','2','周二','Tuesday'),(233,'week','3','周三','Wednesday'),(234,'week','4','周四','Thursday'),(235,'week','5','周五','Friday'),(236,'week','6','周六','Saturated'),(237,'week','7','周日','Sunday'),(238,'order','1','正数','Asc'),(239,'order','2','倒数','Desc'),(240,'tradeMode','4','定期正向','Regular Forward'),(241,'tradeMode','2','永续正向','Sustainable Forward'),(242,'underlyingType','1','现货指数','Spot Index'),(243,'rakeBack','0','注册送币数量',NULL),(244,'rakeBack','1','邀请一级返币数量',NULL),(245,'rakeBack','2','邀请二级返币数量',NULL),(246,'rakeBack','3','邀请三级返币数量',NULL),(247,'rakeBack','4','邀请四级返币数量',NULL),(248,'tradeRakeBack','1','一级交易返币',NULL),(249,'tradeRakeBack','2','二级交易返币',NULL),(250,'tradeRakeBack','3','三级交易返币',NULL),(251,'tradeRakeBack','4','四级交易返币',NULL),(252,'rakeBackType','1','邀请返币',NULL),(253,'rakeBackType','2','交易返币',NULL),(254,'invitationLevel','1','一级','Level One'),(255,'invitationLevel','2','二级','Level Two'),(256,'invitationLevel','3','三级','Level Three'),(257,'invitationLevel','4','四级','Level Four'),(698,'country','93','阿富汗','Afghanistan'),(699,'country','355','阿尔巴尼亚','Albania'),(700,'country','213','阿尔及利亚','Algeria'),(701,'country','684','美属萨摩亚','American Samoa'),(702,'country','376','安道尔','Andorra'),(703,'country','244','安哥拉','Angola'),(704,'country','1264','安圭拉','Anguilla'),(705,'country','672','南极洲','Antarctica'),(706,'country','1268','安提瓜和巴布达','Antigua and Barbuda'),(707,'country','54','阿根廷','Argentina'),(708,'country','374','亚美尼亚','Armenia'),(709,'country','297','阿鲁巴','Aruba'),(710,'country','61','澳大利亚','Australia'),(711,'country','43','奥地利','Austria'),(712,'country','994','阿塞拜疆','Azerbaijan'),(713,'country','973','巴林','Bahrain'),(714,'country','880','孟加拉国','Bangladesh'),(715,'country','1246','巴巴多斯','Barbados'),(716,'country','375','白俄罗斯','Belarus'),(717,'country','32','比利时','Belgium'),(718,'country','501','伯利兹','Belize'),(719,'country','229','贝宁','Benin'),(720,'country','1441','百慕大','Bermuda'),(721,'country','975','不丹','Bhutan'),(722,'country','591','玻利维亚','Bolivia'),(723,'country','387','波黑','Bosnia and Herzegovina'),(724,'country','267','博茨瓦纳','Botswana'),(725,'country','55','巴西','Brazil'),(726,'country','1284','英属维尔京群岛','British Virgin Islands'),(727,'country','673','文莱','Brunei Darussalam'),(728,'country','359','保加利亚','Bulgaria'),(729,'country','226','布基纳法索','Burkina Faso'),(730,'country','95','缅甸','Burma'),(731,'country','257','布隆迪','Burundi'),(732,'country','855','柬埔寨','Cambodia'),(733,'country','237','喀麦隆','Cameroon'),(734,'country','1','加拿大','Canada'),(735,'country','238','佛得角','Cape Verde'),(736,'country','1345','开曼群岛','Cayman Islands'),(737,'country','236','中非','Central African Republic'),(738,'country','235','乍得','Chad'),(739,'country','56','智利','Chile'),(740,'country','86','中国','China'),(741,'country','61','圣诞岛','Christmas Island'),(742,'country','61','科科斯（基林）群岛','Cocos (Keeling) Islands'),(743,'country','57','哥伦比亚','Colombia'),(744,'country','269','科摩罗','Comoros'),(745,'country','243','刚果（金）','Democratic Republic of the Congo'),(746,'country','242','刚果（布）','Republic of the Congo'),(747,'country','682','库克群岛','Cook Islands'),(748,'country','506','哥斯达黎加','Costa Rica'),(749,'country','225','科特迪瓦','Cote d Ivoire'),(750,'country','385','克罗地亚','Croatia'),(751,'country','53','古巴','Cuba'),(752,'country','357','塞浦路斯','Cyprus'),(753,'country','420','捷克','Czech Republic'),(754,'country','45','丹麦','Denmark'),(755,'country','253','吉布提','Djibouti'),(756,'country','1767','多米尼克','Dominica'),(757,'country','1809','多米尼加','Dominican Republic'),(758,'country','593','厄瓜多尔','Ecuador'),(759,'country','20','埃及','Egypt'),(760,'country','503','萨尔瓦多','El Salvador'),(761,'country','240','赤道几内亚','Equatorial Guinea'),(762,'country','291','厄立特里亚','Eritrea'),(763,'country','372','爱沙尼亚','Estonia'),(764,'country','251','埃塞俄比亚','Ethiopia'),(765,'country','500','福克兰群岛（马尔维纳斯）','Falkland Islands (Islas Malvinas)'),(766,'country','298','法罗群岛','Faroe Islands'),(767,'country','679','斐济','Fiji'),(768,'country','358','芬兰','Finland'),(769,'country','33','法国','France'),(770,'country','594','法属圭亚那','French Guiana'),(771,'country','689','法属波利尼西亚','French Polynesia'),(772,'country','241','加蓬','Gabon'),(773,'country','995','格鲁吉亚','Georgia'),(774,'country','49','德国','Germany'),(775,'country','233','加纳','Ghana'),(776,'country','350','直布罗陀','Gibraltar'),(777,'country','30','希腊','Greece'),(778,'country','299','格陵兰','Greenland'),(779,'country','1473','格林纳达','Grenada'),(780,'country','590','瓜德罗普','Guadeloupe'),(781,'country','1671','关岛','Guam'),(782,'country','502','危地马拉','Guatemala'),(783,'country','1481','根西岛','Guernsey'),(784,'country','224','几内亚','Guinea'),(785,'country','245','几内亚比绍','Guinea-Bissau'),(786,'country','592','圭亚那','Guyana'),(787,'country','509','海地','Haiti'),(788,'country','379','梵蒂冈','Holy See (Vatican City)'),(789,'country','504','洪都拉斯','Honduras'),(790,'country','852','香港','Hong Kong (SAR)'),(791,'country','36','匈牙利','Hungary'),(792,'country','354','冰岛','Iceland'),(793,'country','91','印度','India'),(794,'country','62','印度尼西亚','Indonesia'),(795,'country','98','伊朗','Iran'),(796,'country','964','伊拉克','Iraq'),(797,'country','353','爱尔兰','Ireland'),(798,'country','972','以色列','Israel'),(799,'country','39','意大利','Italy'),(800,'country','1876','牙买加','Jamaica'),(801,'country','81','日本','Japan'),(802,'country','962','约旦','Jordan'),(803,'country','73','哈萨克斯坦','Kazakhstan'),(804,'country','254','肯尼亚','Kenya'),(805,'country','686','基里巴斯','Kiribati'),(806,'country','850','朝鲜','North Korea'),(807,'country','82','韩国','South Korea'),(808,'country','965','科威特','Kuwait'),(809,'country','996','吉尔吉斯斯坦','Kyrgyzstan'),(810,'country','856','老挝','Laos'),(811,'country','371','拉脱维亚','Latvia'),(812,'country','961','黎巴嫩','Lebanon'),(813,'country','266','莱索托','Lesotho'),(814,'country','231','利比里亚','Liberia'),(815,'country','218','利比亚','Libya'),(816,'country','423','列支敦士登','Liechtenstein'),(817,'country','370','立陶宛','Lithuania'),(818,'country','352','卢森堡','Luxembourg'),(819,'country','853','澳门','Macao'),(820,'country','389','前南马其顿','The Former Yugoslav Republic of Macedonia'),(821,'country','261','马达加斯加','Madagascar'),(822,'country','265','马拉维','Malawi'),(823,'country','60','马来西亚','Malaysia'),(824,'country','960','马尔代夫','Maldives'),(825,'country','223','马里','Mali'),(826,'country','356','马耳他','Malta'),(827,'country','692','马绍尔群岛','Marshall Islands'),(828,'country','596','马提尼克','Martinique'),(829,'country','222','毛里塔尼亚','Mauritania'),(830,'country','230','毛里求斯','Mauritius'),(831,'country','269','马约特','Mayotte'),(832,'country','52','墨西哥','Mexico'),(833,'country','691','密克罗尼西亚','Federated States of Micronesia'),(834,'country','373','摩尔多瓦','Moldova'),(835,'country','377','摩纳哥','Monaco'),(836,'country','976','蒙古','Mongolia'),(837,'country','1664','蒙特塞拉特','Montserrat'),(838,'country','212','摩洛哥','Morocco'),(839,'country','258','莫桑比克','Mozambique'),(840,'country','264','纳米尼亚','Namibia'),(841,'country','674','瑙鲁','Nauru'),(842,'country','977','尼泊尔','Nepal'),(843,'country','31','荷兰','Netherlands'),(844,'country','599','荷属安的列斯','Netherlands Antilles'),(845,'country','687','新喀里多尼亚','New Caledonia'),(846,'country','64','新西兰','New Zealand'),(847,'country','505','尼加拉瓜','Nicaragua'),(848,'country','227','尼日尔','Niger'),(849,'country','234','尼日利亚','Nigeria'),(850,'country','683','纽埃','Niue'),(851,'country','6723','诺福克岛','Norfolk Island'),(852,'country','1','北马里亚纳','Northern Mariana Islands'),(853,'country','47','挪威','Norway'),(854,'country','968','阿曼','Oman'),(855,'country','92','巴基斯坦','Pakistan'),(856,'country','680','帕劳','Palau'),(857,'country','507','巴拿马','Panama'),(858,'country','675','巴布亚新几内亚','Papua New Guinea'),(859,'country','595','巴拉圭','Paraguay'),(860,'country','51','秘鲁','Peru'),(861,'country','63','菲律宾','Philippines'),(862,'country','48','波兰','Poland'),(863,'country','351','葡萄牙','Portugal'),(864,'country','1809','波多黎各','Puerto Rico'),(865,'country','974','卡塔尔','Qatar'),(866,'country','262','留尼汪','Reunion'),(867,'country','40','罗马尼亚','Romania'),(868,'country','7','俄罗斯','Russia'),(869,'country','250','卢旺达','Rwanda'),(870,'country','290','圣赫勒拿','Saint Helena'),(871,'country','1869','圣基茨和尼维斯','Saint Kitts and Nevis'),(872,'country','1758','圣卢西亚','Saint Lucia'),(873,'country','508','圣皮埃尔和密克隆','Saint Pierre and Miquelon'),(874,'country','1784','圣文森特和格林纳丁斯','Saint Vincent and the Grenadines'),(875,'country','685','萨摩亚','Samoa'),(876,'country','378','圣马力诺','San Marino'),(877,'country','239','圣多美和普林西比','Sao Tome and Principe'),(878,'country','966','沙特阿拉伯','Saudi Arabia'),(879,'country','221','塞内加尔','Senegal'),(880,'country','381','塞尔维亚和黑山','Serbia and Montenegro'),(881,'country','248','塞舌尔','Seychelles'),(882,'country','232','塞拉利','Sierra Leone'),(883,'country','65','新加坡','Singapore'),(884,'country','421','斯洛伐克','Slovakia'),(885,'country','386','斯洛文尼亚','Slovenia'),(886,'country','677','所罗门群岛','Solomon Islands'),(887,'country','252','索马里','Somalia'),(888,'country','27','南非','South Africa'),(889,'country','34','西班牙','Spain'),(890,'country','94','斯里兰卡','Sri Lanka'),(891,'country','249','苏丹','Sudan'),(892,'country','597','苏里南','Suriname'),(893,'country','47','斯瓦尔巴岛和扬马延岛','Svalbard'),(894,'country','268','斯威士兰','Swaziland'),(895,'country','46','瑞典','Sweden'),(896,'country','41','瑞士','Switzerland'),(897,'country','963','叙利亚','Syria'),(898,'country','886','台湾','Taiwan'),(899,'country','992','塔吉克斯坦','Tajikistan'),(900,'country','255','坦桑尼亚','Tanzania'),(901,'country','66','泰国','Thailand'),(902,'country','1242','巴哈马','The Bahamas'),(903,'country','220','冈比亚','The Gambia'),(904,'country','228','多哥','Togo'),(905,'country','690','托克劳','Tokelau'),(906,'country','676','汤加','Tonga'),(907,'country','1868','特立尼达和多巴哥','Trinidad and Tobago'),(908,'country','216','突尼斯','Tunisia'),(909,'country','90','土耳其','Turkey'),(910,'country','993','土库曼斯坦','Turkmenistan'),(911,'country','1649','特克斯和凯科斯群岛','Turks and Caicos Islands'),(912,'country','688','图瓦卢','Tuvalu'),(913,'country','256','乌干达','Uganda'),(914,'country','380','乌克兰','Ukraine'),(915,'country','971','阿拉伯联合酋长国','United Arab Emirates'),(916,'country','44','英国','United Kingdom'),(917,'country','1','美国','United States'),(918,'country','598','乌拉圭','Uruguay'),(919,'country','998','乌兹别克斯坦','Uzbekistan'),(920,'country','678','瓦努阿图','Vanuatu'),(921,'country','58','委内瑞拉','Venezuela'),(922,'country','84','越南','Vietnam'),(923,'country','1340','美属维尔京群岛','Virgin Islands'),(924,'country','681','瓦利斯和富图纳','Wallis and Futuna'),(925,'country','967','也门','Yemen'),(926,'country','260','赞比亚','Zambia'),(927,'country','263','津巴布韦','Zimbabwe'),(928,'arithmetic','0','绝对值','Absolute Value'),(929,'arithmetic','1','百分比','Percentage'),(930,'forbidType','0','禁止出金','No Withdraw'),(931,'forbidType','1','允许转出','Withdraw'),(932,'trader_forbid_type','0','禁止开仓','No Open'),(933,'trader_forbid_type','1','禁止交易','No Trade'),(934,'compulsion_status','0','关闭','Close'),(935,'compulsion_status','1','开启','Open'),(936,'exchangeStatus','1','交易中','On Trade'),(937,'exchangeStatus','2','只可撤单','Only Cancel Order'),(938,'exchangeStatus','3','停止交易','No Trade');

UNLOCK TABLES;

/*Data for the table `t_identification_type` */

LOCK TABLES `t_identification_type` WRITE;
TRUNCATE t_identification_type;
insert  into `t_identification_type`(`id`,`identification_type`,`identification_name`,`operate_time`,`operator_id`) values (1,'1','身份证',20181211,'admin'),(2,'2','军官证',NULL,NULL),(3,'4','huzhao',NULL,NULL);

UNLOCK TABLES;


/*Data for the table `t_invitation_set` */

LOCK TABLES `t_invitation_set` WRITE;
TRUNCATE t_invitation_set;
insert  into `t_invitation_set`(`id`,`invitation_type`,`arithmetic`,`invitation_value`,`operate_time`,`operator_id`,`currency`) values (1,'0','0','0.2333000000',1545896347124,'ADMIN','XBT'),(2,'1','0','0.0000000000',1545896347124,'ADMIN','XBT'),(3,'2','0','0.0008000000',1545896347124,'ADMIN','XBT'),(4,'3','0','0.0002000000',1545896347124,'ADMIN','XBT'),(5,'4','0','0.0001000000',1545896347124,'ADMIN','BTC');

UNLOCK TABLES;


/*Data for the table `t_key_rigth_relation` */

LOCK TABLES `t_key_rigth_relation` WRITE;
TRUNCATE t_key_rigth_relation;
insert  into `t_key_rigth_relation`(`id`,`key_right`,`request_path`,`request_type`,`operate_time`,`operator_id`) values (2,'0','/api/v1/order','PUT',1546827823414,'admin'),(3,'0','/api/v1/order','POST',1546827823414,'admin'),(4,'0','/api/v1/order','GET',1546827823414,'admin'),(5,'0','/api/v1/order','DELETE',1546827823414,'admin');

UNLOCK TABLES;



/*Data for the table `t_risk_index` */

LOCK TABLES `t_risk_index` WRITE;
TRUNCATE t_risk_index;
insert  into `t_risk_index`(`id`,`warn_type`,`risk_flag`,`peek_value`,`operate_time`,`warn_level`,`accounts`,`interval_time`) values (1,'2','3','0.100',1545896347124,'1','shb920603@163.com',5),(2,'2','2','0.250',1545896347124,'1','suhb@quantdo.com.cn',5),(3,'2','1','0.250',1545896347124,'1','suhb@quantdo.com.cn',5);

UNLOCK TABLES;


/*Data for the table `t_system_config` */

LOCK TABLES `t_system_config` WRITE;
TRUNCATE t_system_config;
insert  into `t_system_config`(`id`,`config_key`,`config_value`) values (1,'invitationLevel','4');

UNLOCK TABLES;



/*Data for the table `t_currency` */

LOCK TABLES `t_currency` WRITE;
TRUNCATE t_currency;

insert into `t_currency` (`currency`, `currency_name`, `digits`, `min_withdraw_tick`, `min_withdraw_amount`, `recommend_withdraw_fee`, `min_withdraw_fee`, `block_chain_address`, `oper_id`, `oper_time`, `recheck_oper_id`, `recheck_oper_time`) values('XBT','XBTbit','1','1.0000000000','1.0000000000','1.0000000000','1.0000000000','1',NULL,'1551751787106',NULL,NULL);

UNLOCK TABLES;

/*Data for the table `t_underlying` */

LOCK TABLES `t_underlying` WRITE;

insert  into `t_underlying`(`id`,`underlying_id`,`underlying_name`,`underlying_type`,`oper_id`,`oper_time`,`recheck_oper_id`,`recheck_oper_time`) values (1,'XBT-USD','比特币','1','ADMIN',1545807237,'ADMIN',1545807237);

UNLOCK TABLES;

/*Data for the table `t_underlying_detail` */

LOCK TABLES `t_underlying_detail` WRITE;

insert  into `t_underlying_detail`(`id`,`underlying_id`,`exch_id`,`product_id`,`weight`) values (1,'XBT-USD','KRAKEN','XXBTZUSD','0.5000'),(2,'LTC-USD','KRAKEN','XLTCZUSD','0.3320'),(3,'ETH-USD','KRAKEN','XETHZUSD','0.3333'),(4,'XBT-USD','COINBASE','BTC-USD','0.2000'),(5,'LTC-USD','COINBASE','LTC-USD','0.3300'),(6,'ETH-USD','COINBASE','ETH-USD','0.3333'),(7,'XBT-USD','BITSTAMP','btcusd','0.4000'),(8,'LTC-USD','BITSTAMP','ltcusd','0.3300'),(10,'ETH-USD','BITSTAMP','ethusd','0.3333'),(11,'ETH-USD','BITMEX','.BETH','0.3333'),(13,'XBT-USD','BITMEX','.BXBT','0.3333'),(16,'LTC-USD','BITMEX','.BLTCXBT','0.3333');

UNLOCK TABLES;

/*   交易所状态  */
TRUNCATE t_risk_exchange_limit;
INSERT INTO `t_risk_exchange_limit` (`exchange_status`, `operate_time`, `operator_id`) VALUES('1','1545896347124','admin');
