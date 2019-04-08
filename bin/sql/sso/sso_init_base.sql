USE `sso`;

/*Data for the table `sso_perm` */

LOCK TABLES `sso_perm` WRITE;

insert  into `sso_perm`(`id`,`user_id`,`perm`) values (1,1,'user:select'),(2,1,'/sso/demo/hello5'),(5,1,'com.quantdo.demo.user.service.UserService::1.0.0::get'),(6,1,'com.quantdo.digital.user.service.IdentificationTypeService::1.0.0::findAll'),(7,1,'com.quantdo.digital.user.service.TradeUserService::1.0.0::findTradeUserByCondition'),(8,1,'com.quantdo.digital.user.service.DictService::1.0.0::findAll'),(9,1,'com.quantdo.digital.user.service.TradeUserService::1.0.0::updateApplyStatusAdopt'),(10,1,'com.quantdo.digital.user.service.TradeUserService::1.0.0::updateApplyStatusRefuse'),(11,1,'com.quantdo.digital.user.service.TradeUserService::1.0.0::updateApplyStatusActive'),(12,1,'com.quantdo.digital.user.service.TradeUserService::1.0.0::updateUserLevelByUserId'),(13,1,'com.quantdo.digital.user.service.BlackListService::1.0.0::*'),(14,1,'com.quantdo.digital.user.service.LevelTypeService::1.0.0::*'),(15,1,'com.quantdo.digital.user.service.ApiKeyService::1.0.0::*'),(16,1,'com.quantdo.digital.product.service.CurrencyService::1.0.0::*'),(17,1,'com.quantdo.digital.product.service.UnderlyingService::1.0.0::*'),(18,1,'com.quantdo.digital.product.service.InstrumentService::1.0.0::*'),(19,1,'com.quantdo.digital.product.service.TradeFeeSetService::1.0.0::*'),(20,1,'com.quantdo.digital.product.service.RiskLimitService::1.0.0::*'),(21,1,'com.quantdo.digital.product.service.WithdrawService::1.0.0::*'),(22,1,'com.quantdo.digital.invitation.service.InvitationSetService::1.0.0::*'),(23,1,'com.quantdo.digital.invitation.service.InvitationTradeSetService::1.0.0::*'),(24,1,'com.quantdo.digital.product.service.ProductService::1.0.0::*'),(25,1,'com.quantdo.digital.invitation.service.InvitationDetailService::1.0.0::*'),(26,1,'com.quantdo.digital.invitation.service.InvitationRakeBackActionService::1.0.0::*'),(27,1,'com.quantdo.digital.invitation.service.TransactionHistoryService::1.0.0::*');

UNLOCK TABLES;

/*Data for the table `sso_resource` */

LOCK TABLES `sso_resource` WRITE;

insert  into `sso_resource`(`id`,`res`,`restype`) values (1,'/sso/demo/hello5','rest');

UNLOCK TABLES;

/*Data for the table `sso_resource_acl` */

LOCK TABLES `sso_resource_acl` WRITE;

insert  into `sso_resource_acl`(`id`,`res`,`acl`) values (1,'/sso/demo/hello5','rest'),(2,'/digital/tradeUser/findTradeUserByCondition','rest');

UNLOCK TABLES;

/*Data for the table `sso_role` */

LOCK TABLES `sso_role` WRITE;

insert  into `sso_role`(`id`,`user_id`,`role`) values (1,1,'admin'),(2,1,'manager');

UNLOCK TABLES;

/*Data for the table `sso_user` */

LOCK TABLES `sso_user` WRITE;

insert  into `sso_user`(`id`,`loginname`,`username`,`password`,`pwd_salt`,`pwd_algorithm`) values (1,'admin','管理员','6d8089335b1d6a9e157f682adfba778656fc87eb677aa3b8c0db90c79f6d7362','F12839WhsnnEV$#23b','SHA-256');

UNLOCK TABLES;

/*Data for the table `t_org_admin` */

LOCK TABLES `t_org_admin` WRITE;

insert  into `t_org_admin`(`org_unit_id`,`user_id`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (2,26,'1','2019-03-28 11:01:00','1','2019-03-28 11:01:00');

UNLOCK TABLES;

/*Data for the table `t_org_unit` */

LOCK TABLES `t_org_unit` WRITE;

insert  into `t_org_unit`(`id`,`code`,`parent_code`,`name`,`address`,`telephone`,`email`,`type_id`,`is_active`,`description`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (1,'001','','上海量投网络技术有限公司','33333',NULL,NULL,1,1,NULL,'1',NULL,'1',NULL),(2,'001001','001','武汉研发中心',NULL,NULL,NULL,2,1,NULL,'1',NULL,'1',NULL),(5,'001001001002','001001001','系统研发',NULL,NULL,NULL,4,1,NULL,'1',NULL,'1',NULL);

UNLOCK TABLES;

/*Data for the table `t_org_unit_type` */

LOCK TABLES `t_org_unit_type` WRITE;

insert  into `t_org_unit_type`(`id`,`code`,`name`) values (1,'001','集团公司'),(2,'002','子公司'),(3,'003','部门'),(4,'004','岗位');

UNLOCK TABLES;

/*Data for the table `t_resource` */

LOCK TABLES `t_resource` WRITE;

insert  into `t_resource`(`id`,`resource_content`,`resource_name`,`public_access`,`resource_type`,`system_id`) values (7001,'menu:customer','客户管理',0,0,7),(7002,'menu:information','客户信息管理',0,0,7),(7003,'menu:blacklist','开户黑名单管理',0,0,7),(7004,'menu:idtype','客户证件类型管理',0,0,7),(7005,'menu:cusClass','客户分类管理',0,0,7),(7006,'menu:cusClassSet','设置分类客户',0,0,7),(7007,'menu:userApi','客户API查询',0,0,7),(7008,'menu:operation','业务管理',0,0,7),(7009,'menu:riskExchangeLimit','交易所管理',0,0,7),(7010,'menu:currency','币种管理',0,0,7),(7011,'menu:underlying','标的物管理',0,0,7),(7012,'menu:product','品种管理',0,0,7),(7013,'menu:new','创建新品种',0,0,7),(7014,'menu:setting','设置品种参数',0,0,7),(7015,'menu:instrumentManage','合约管理',0,0,7),(7016,'menu:tradeFeeSet','交易手续费管理',0,0,7),(7017,'menu:delivFeeSet','交割手续费管理',0,0,7),(7018,'menu:riskLimit','风险限额管理',0,0,7),(7019,'menu:withdraw','客户提现管理',0,0,7),(7020,'menu:rakeBack','返佣管理',0,0,7),(7021,'menu:invitationSet','邀请返佣参数设置',0,0,7),(7022,'menu:invitationTradeSet','交易返佣参数设置',0,0,7),(7023,'menu:invitationDetail','邀请关系查询',0,0,7),(7024,'menu:invitationRakeBackAction','返币记录查询',0,0,7),(7025,'menu:registerRakeBack','注册送币记录查询',0,0,7),(7026,'menu:risk','风险管理',0,0,7),(7027,'menu:riskWithdrawLimit','全局出金设置',0,0,7),(7028,'menu:riskTradeRigthLimit','交易权限设置',0,0,7),(7029,'menu:riskWithdrawRigthSet','出金权限管理',0,0,7),(7030,'menu:riskParameterSet','风险参数设置',0,0,7),(7031,'menu:riskMandatoryReductionSet','强平参数设置',0,0,7),(7032,'menu:garbageUser','垃圾用户管理',0,0,7),(7033,'menu:riskPosition','风险监控',0,0,7),(7034,'menu:warnResult','报警记录查询',0,0,7),(7035,'menu:forcedPosition','强平记录查询',0,0,7),(7036,'menu:autoReducePositionRisk','自动减仓风险度查询',0,0,7),(7037,'menu:autoReducePosition','自动减仓查询',0,0,7),(7038,'menu:riskAccountCapital','保险基金查询',0,0,7),(7039,'menu:system','系统管理',0,0,7),(7040,'menu:operationLog','操作日志管理',0,0,7);

UNLOCK TABLES;

/*Data for the table `t_resource_relation` */

LOCK TABLES `t_resource_relation` WRITE;

insert  into `t_resource_relation`(`parent_resource_id`,`resource_id`) values (7001,7002),(7001,7003),(7001,7004),(7001,7005),(7001,7006),(7001,7007),(7008,7009),(7008,7010),(7008,7011),(7008,7012),(7008,7015),(7008,7016),(7008,7017),(7008,7018),(7008,7019),(7012,7013),(7012,7014),(7020,7021),(7020,7022),(7020,7023),(7020,7024),(7020,7025),(7026,7027),(7026,7028),(7026,7029),(7026,7030),(7026,7031),(7026,7032),(7026,7033),(7026,7034),(7026,7035),(7026,7036),(7026,7037),(7026,7038),(7039,7040);

UNLOCK TABLES;

/*Data for the table `t_role` */

LOCK TABLES `t_role` WRITE;

insert  into `t_role`(`id`,`name`,`description`,`system_id`,`is_active`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (21,'客户管理人员','11',7,1,'1','2019-03-27 16:19:44','1','2019-03-27 16:19:44');

UNLOCK TABLES;

/*Data for the table `t_role_org` */

LOCK TABLES `t_role_org` WRITE;

insert  into `t_role_org`(`role_id`,`org_unit_id`) values (5,2);

UNLOCK TABLES;

/*Data for the table `t_role_resource` */

LOCK TABLES `t_role_resource` WRITE;

insert  into `t_role_resource`(`role_id`,`resource_id`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (1,1,NULL,'2019-03-29 14:08:12','',NULL),(1,2,NULL,'2019-03-29 14:08:12','',NULL),(1,3,NULL,'2019-03-29 14:08:12','',NULL),(1,4,NULL,'2019-03-29 14:08:12','',NULL),(1,5,NULL,'2019-03-29 14:08:12','',NULL),(1,6,NULL,'2019-03-29 14:08:12','',NULL),(1,7,NULL,'2019-03-29 14:08:12','',NULL),(1,8,NULL,'2019-03-29 14:08:12','',NULL),(1,9,NULL,'2019-03-29 14:08:12','',NULL),(1,10,NULL,'2019-03-29 14:08:12','',NULL),(1,11,NULL,'2019-03-29 14:08:12','',NULL),(1,12,NULL,'2019-03-29 14:08:12','',NULL),(1,13,NULL,'2019-03-29 14:08:12','',NULL),(1,14,NULL,'2019-03-29 14:08:12','',NULL),(1,15,NULL,'2019-03-29 14:08:12','',NULL),(1,16,NULL,'2019-03-29 14:08:12','',NULL),(1,17,NULL,'2019-03-29 14:08:12','',NULL),(1,18,NULL,'2019-03-29 14:08:12','',NULL),(1,19,NULL,'2019-03-29 14:08:12','',NULL),(1,20,NULL,'2019-03-29 14:08:12','',NULL),(1,21,NULL,'2019-03-29 14:08:12','',NULL),(1,22,NULL,'2019-03-29 14:08:12','',NULL),(1,23,NULL,'2019-03-29 14:08:12','',NULL),(21,7001,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7002,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7003,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7004,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7005,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7006,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7007,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7008,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7009,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7010,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7011,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7012,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7015,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7016,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7017,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7018,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7019,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7020,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7021,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7022,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7023,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7024,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7025,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7026,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7027,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7028,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7029,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7030,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7031,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7032,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7033,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7034,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7035,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7036,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7037,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7038,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7039,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12'),(21,7040,'1','2019-03-29 14:08:12','1','2019-03-29 14:08:12');

UNLOCK TABLES;

/*Data for the table `t_role_user` */

LOCK TABLES `t_role_user` WRITE;

insert  into `t_role_user`(`user_id`,`role_id`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (26,21,'1','2019-03-27 16:20:36','1','2019-03-27 16:20:36');

UNLOCK TABLES;

/*Data for the table `t_system` */

LOCK TABLES `t_system` WRITE;

insert  into `t_system`(`id`,`name`,`description`) values (7,'数字货币系统','数字货币系统');

UNLOCK TABLES;

/*Data for the table `t_system_param_set` */

LOCK TABLES `t_system_param_set` WRITE;

insert  into `t_system_param_set`(`id`,`param_code`,`param_name`,`param_value`,`remark`) values (1,'PASSWORD_EXPIRED_DAYS','用户密码过期天数','90','设置为0则不校验'),(2,'HIS_PASSWORD_RECORDS','用户历史密码保留记录数','5','设置为0则不保留');

UNLOCK TABLES;

/*Data for the table `t_user` */

LOCK TABLES `t_user` WRITE;

insert  into `t_user`(`id`,`login_name`,`user_name`,`pwd_algorithm`,`pwd_salt`,`password`,`change_pwd_date`,`pwd_error_times`,`is_active`,`description`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (1,'systemadmin','超级管理员','SHA-256','F12839WhsnnEV$#23b','6d8089335b1d6a9e157f682adfba778656fc87eb677aa3b8c0db90c79f6d7362',NULL,0,1,NULL,'1','2019-03-11 14:22:53','5','2019-03-11 14:23:12'),(26,'admin','数字货币系统管理员','SHA-256','F12839WhsnnEV$#23b','6d8089335b1d6a9e157f682adfba778656fc87eb677aa3b8c0db90c79f6d7362',NULL,NULL,1,NULL,'1','2019-03-27 16:20:15','1','2019-03-27 16:20:15');

UNLOCK TABLES;
