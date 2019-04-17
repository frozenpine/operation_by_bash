USE `sso`;

/*Data for the table `t_group` */

LOCK TABLES `t_group` WRITE;

UNLOCK TABLES;

/*Data for the table `t_group_user` */

LOCK TABLES `t_group_user` WRITE;

UNLOCK TABLES;

/*Data for the table `t_log` */

LOCK TABLES `t_log` WRITE;

UNLOCK TABLES;

/*Data for the table `t_online_user` */

LOCK TABLES `t_online_user` WRITE;

UNLOCK TABLES;

/*Data for the table `t_org_admin` */

LOCK TABLES `t_org_admin` WRITE;

insert  into `t_org_admin`(`org_unit_id`,`user_id`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (2,2,'systemadmin','2019-04-16 09:35:07','systemadmin','2019-04-16 09:35:07');

UNLOCK TABLES;

/*Data for the table `t_org_unit` */

LOCK TABLES `t_org_unit` WRITE;

insert  into `t_org_unit`(`id`,`code`,`parent_code`,`name`,`address`,`telephone`,`email`,`type_id`,`is_active`,`description`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (1,'001','','上海量投网络技术有限公司','33333',NULL,NULL,1,1,NULL,'1',NULL,'1',NULL),(2,'001001','001','武汉研发中心',NULL,NULL,NULL,2,1,NULL,'1',NULL,'1',NULL),(3,'001001001','001001','新技术平台组',NULL,NULL,NULL,3,1,NULL,'1',NULL,'1',NULL),(4,'001001001001','001001001','系统架构',NULL,NULL,NULL,4,1,NULL,'1',NULL,'1',NULL),(5,'001001001002','001001001','系统研发',NULL,NULL,NULL,4,1,NULL,'1',NULL,'1',NULL),(6,'001001001003','001001001','系统测试',NULL,NULL,NULL,4,1,NULL,'1',NULL,'1',NULL);

UNLOCK TABLES;

/*Data for the table `t_org_unit_resource` */

LOCK TABLES `t_org_unit_resource` WRITE;

UNLOCK TABLES;

/*Data for the table `t_org_unit_type` */

LOCK TABLES `t_org_unit_type` WRITE;

insert  into `t_org_unit_type`(`id`,`code`,`name`) values (1,'001','集团公司'),(2,'002','子公司'),(3,'003','部门'),(4,'004','岗位');

UNLOCK TABLES;

/*Data for the table `t_org_user` */

LOCK TABLES `t_org_user` WRITE;

UNLOCK TABLES;

/*Data for the table `t_resource` */

LOCK TABLES `t_resource` WRITE;

insert  into `t_resource`(`id`,`resource_content`,`resource_name`,`public_access`,`resource_type`,`system_id`) values (1,'menu:systemsso','权限管理',0,0,1),(2,'menu:usermanagement','用户管理',0,0,1),(3,'menu:systemmanagement','应用管理',0,0,1),(4,'menu:rolemanagement','角色管理',0,0,1),(5,'menu:permissionmanagement','权限管理',0,0,1),(6,'menu:groupmanagement','群组管理',0,0,1),(7,'menu:organizationmanagement','组织管理',0,0,1),(8,'menu:menumanagement','菜单管理',0,0,1),(9,'menu:servicemanagement','服务管理',0,0,1),(1001,'button:member_query','查询',0,1,1),(1002,'button:member_update','修改',0,1,1),(1003,'button:member_add','新增',0,1,1),(1004,'button:member_upload','导入',0,1,1),(1005,'button:member_forbit','禁用',0,1,1),(1006,'button:system_query','查询',0,1,1),(1007,'button:system_add','新增',0,1,1),(1008,'button:system_delete','删除',0,1,1),(1009,'button:role_query','查询',0,1,1),(1010,'button:role_add','新增',0,1,1),(1011,'button:role_update','修改',0,1,1),(1012,'button:role_relate_user','关联用户',0,0,1),(1013,'button:role_delete','删除角色',0,0,1),(1014,'button:permission_query','查询',0,1,1),(1015,'button:permission_authorize_menu','菜单按钮授权',0,1,1),(1016,'button:permission_authorize_service','服务授权',0,1,1),(1017,'button:group_query','查询',0,1,1),(1018,'button:group_add','新增',0,1,1),(1019,'button:group_delete','删除',0,1,1),(1020,'button:group_update','修改',0,1,1),(1021,'button:org_query','查询',0,1,1),(1022,'button:org_add','新增',0,1,1),(1023,'button:org_add_user','添加用户',0,1,1),(1024,'button:org_setting_admin','设置管理员',0,1,1),(1025,'button:org_menu','右键菜单',0,1,1),(1026,'button:service_query','查询',0,1,1),(1027,'button:service_add','新增',0,1,1),(1028,'button:service_update','修改',0,1,1),(1029,'button:service_delete','删除',0,1,1),(7001,'menu:customer','客户管理',0,0,7),(7002,'menu:information','客户信息管理',0,0,7),(7003,'menu:blacklist','开户黑名单管理',0,0,7),(7004,'menu:idtype','客户证件类型管理',0,0,7),(7005,'menu:cusClass','客户分类管理',0,0,7),(7006,'menu:cusClassSet','设置分类客户',0,0,7),(7007,'menu:userApi','客户API查询',0,0,7),(7008,'menu:operation','业务管理',0,0,7),(7009,'menu:riskExchangeLimit','交易所管理',0,0,7),(7010,'menu:currency','币种管理',0,0,7),(7011,'menu:underlying','标的物管理',0,0,7),(7012,'menu:product','品种管理',0,0,7),(7013,'menu:new','创建新品种',0,0,7),(7014,'menu:setting','设置品种参数',0,0,7),(7015,'menu:instrumentManage','合约管理',0,0,7),(7016,'menu:tradeFeeSet','交易手续费管理',0,0,7),(7017,'menu:delivFeeSet','交割手续费管理',0,0,7),(7018,'menu:riskLimit','风险限额管理',0,0,7),(7019,'menu:withdraw','客户提现管理',0,0,7),(7020,'menu:rakeBack','返佣管理',0,0,7),(7021,'menu:invitationSet','邀请返佣参数设置',0,0,7),(7022,'menu:invitationTradeSet','交易返佣参数设置',0,0,7),(7023,'menu:invitationDetail','邀请关系查询',0,0,7),(7024,'menu:invitationRakeBackAction','返币记录查询',0,0,7),(7025,'menu:registerRakeBack','注册送币记录查询',0,0,7),(7026,'menu:risk','风险管理',0,0,7),(7027,'menu:riskWithdrawLimit','全局出金设置',0,0,7),(7028,'menu:riskTradeRigthLimit','交易权限设置',0,0,7),(7029,'menu:riskWithdrawRigthSet','出金权限管理',0,0,7),(7030,'menu:riskParameterSet','风险参数设置',0,0,7),(7031,'menu:riskMandatoryReductionSet','强平参数设置',0,0,7),(7032,'menu:garbageUser','垃圾用户管理',0,0,7),(7033,'menu:riskPosition','风险监控',0,0,7),(7034,'menu:warnResult','报警记录查询',0,0,7),(7035,'menu:forcedPosition','强平记录查询',0,0,7),(7036,'menu:autoReducePositionRisk','自动减仓风险度查询',0,0,7),(7037,'menu:autoReducePosition','自动减仓查询',0,0,7),(7038,'menu:riskAccountCapital','保险基金查询',0,0,7),(7039,'menu:system','系统管理',0,0,7),(7040,'menu:operationLog','操作日志管理',0,0,7),(7041,'button:information_query','查询',0,1,7),(7042,'button:information_check','审核',0,1,7),(7043,'button:information_freeze','冻结',0,1,7),(7044,'button:information_unfreeze','解冻',0,1,7),(7045,'button:information_unfreeze_array','批量解冻',0,1,7),(7046,'button:information_pass_array','批量通过',0,1,7),(7047,'button:information_refuse_array','批量拒绝',0,1,7),(7048,'button:information_init_system_user','初始化系统用户',0,1,7),(7049,'button:blacklist_update','修改',0,1,7),(7050,'button:blacklist_update','删除',0,1,7),(7051,'button:blacklist_query','查询',0,1,7),(7052,'button:blacklist_add','新增',0,1,7),(7053,'button:blacklist_delete_array','批量删除',0,1,7),(7054,'button:cusClass_query','查询',0,1,7),(7055,'button:cusClass_add','新增',0,1,7),(7056,'button:cusClass_update','修改',0,1,7),(7057,'button:cusClass_delete','删除',0,1,7),(7058,'button:cusClassSet_query','查询',0,1,7),(7059,'button:cusClassSet_add','新增',0,1,7),(7060,'button:cusClassSet_update','修改',0,1,7),(7061,'button:cusClassSet_delete','删除',0,1,7),(7062,'button:userApi_query','查询',0,1,7),(7063,'button:riskExchangeLimit_update','切换交易所状态',0,1,7),(7064,'button:currency_query','查询',0,1,7),(7065,'button:currency_update','修改',0,1,7),(7066,'button:underlying_query','查询',0,1,7),(7067,'button:underlying_update','修改',0,1,7),(7068,'button:underlying_index_price','设置指数价格',0,1,7),(7069,'button:tradeFeeSet_add','新增',0,1,7),(7070,'button:tradeFeeSet_update','修改',0,1,7),(7071,'button:tradeFeeSet_query','查询',0,1,7),(7072,'button:tradeFeeSet_delete','删除',0,1,7),(7073,'button:delivFeeSet_add','新增',0,1,7),(7074,'button:delivFeeSet_update','修改',0,1,7),(7075,'button:delivFeeSet_query','查询',0,1,7),(7076,'button:delivFeeSet_delete','删除',0,1,7),(7077,'button:riskLimit_add','新增',0,1,7),(7078,'button:riskLimit_update','修改',0,1,7),(7079,'button:riskLimit_query','查询',0,1,7),(7080,'button:riskLimit_delete','删除',0,1,7),(7081,'button:withdraw_query','查询',0,1,7),(7082,'button:withdraw_pass_array','批量通过',0,1,7),(7083,'button:withdraw_refuse_array','批量拒绝',0,1,7),(7084,'button:withdraw_pass','通过',0,1,7),(7085,'button:withdraw_refuse','拒绝',0,1,7),(7086,'button:invitationSet_update','修改',0,1,7),(7087,'button:invitationTradeSet_add','新增',0,1,7),(7088,'button_invitationTradeSet_update','修改',0,1,7),(7089,'button:invitationTradeSet_query','查询',0,1,7),(7090,'button:invitationTradeSet_delete','删除',0,1,7),(7091,'button:invitationDetail_query','查询',0,1,7),(7092,'button:invitationRakeBackAction_query','查询',0,1,7),(7093,'button:registerRakeBack_query','查询',0,1,7),(7094,'button:riskWithdrawLimit_update','修改',0,1,7),(7095,'button:riskTradeRigthLimit_add','新增',0,1,7),(7096,'button:riskTradeRigthLimit_update','修改',0,1,7),(7097,'button:riskTradeRigthLimit_query','查询',0,1,7),(7098,'button:riskTradeRigthLimit_delete','删除',0,1,7),(7099,'button:riskWithdrawRigthSet_add','新增',0,1,7),(7100,'button:riskWithdrawRigthSet_update','修改',0,1,7),(7101,'button:riskWithdrawRigthSet_query','查询',0,1,7),(7102,'button:riskWithdrawRigthSet_delete','删除',0,1,7),(7103,'button:riskParameterSet_update','修改',0,1,7),(7104,'button:riskMandatoryReductionSet_update','修改',0,1,7),(7105,'button:riskMandatoryReductionSet_query','查询',0,1,7),(7106,'button:garbageUser_pass_array','批量解除标记',0,1,7),(7107,'button:garbageUser_pass','解除标记',0,1,7),(7108,'button:garbageUser_query','查询',0,1,7),(7109,'button:riskPosition_query','查询',0,1,7),(7110,'button:warnResult_query','查询',0,1,7),(7111,'button:forcedPosition_query','查询',0,1,7),(7112,'button:autoReducePositionRisk_query','查询',0,1,7),(7113,'button:autoReducePosition_query','查询',0,1,7),(7114,'button:riskAccountCapital_export','导出',0,1,7),(7115,'button:operationLog_query','查询',0,1,7);

UNLOCK TABLES;

/*Data for the table `t_resource_relation` */

LOCK TABLES `t_resource_relation` WRITE;

insert  into `t_resource_relation`(`parent_resource_id`,`resource_id`) values (1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(3,1006),(3,1007),(3,1008),(4,1009),(4,1010),(4,1011),(4,1012),(4,1013),(5,1014),(5,1015),(5,1016),(6,1017),(6,1018),(6,1019),(6,1020),(7,1021),(7,1022),(7,1023),(7,1024),(7,1025),(9,1026),(9,1027),(9,1028),(9,1029),(7001,7002),(7001,7003),(7001,7004),(7001,7005),(7001,7006),(7001,7007),(7002,7041),(7002,7042),(7002,7043),(7002,7044),(7002,7045),(7002,7046),(7002,7047),(7002,7048),(7003,7049),(7003,7050),(7003,7051),(7003,7052),(7003,7053),(7005,7054),(7005,7055),(7005,7056),(7005,7057),(7006,7058),(7006,7059),(7006,7060),(7006,7061),(7007,7062),(7008,7009),(7008,7010),(7008,7011),(7008,7012),(7008,7015),(7008,7016),(7008,7017),(7008,7018),(7008,7019),(7009,7063),(7010,7064),(7010,7065),(7011,7066),(7011,7067),(7011,7068),(7012,7013),(7012,7014),(7016,7069),(7016,7070),(7016,7071),(7016,7072),(7017,7073),(7017,7074),(7017,7075),(7017,7076),(7018,7077),(7018,7078),(7018,7079),(7018,7080),(7019,7081),(7019,7082),(7019,7083),(7019,7084),(7019,7085),(7020,7021),(7020,7022),(7020,7023),(7020,7024),(7020,7025),(7021,7086),(7022,7087),(7022,7088),(7022,7089),(7022,7090),(7023,7091),(7024,7092),(7025,7093),(7026,7027),(7026,7028),(7026,7029),(7026,7030),(7026,7031),(7026,7032),(7026,7033),(7026,7034),(7026,7035),(7026,7036),(7026,7037),(7026,7038),(7027,7094),(7028,7095),(7028,7096),(7028,7097),(7028,7098),(7029,7099),(7029,7100),(7029,7101),(7029,7102),(7030,7103),(7031,7104),(7031,7105),(7032,7106),(7032,7107),(7032,7108),(7033,7109),(7034,7110),(7035,7111),(7036,7112),(7037,7113),(7038,7114),(7039,7040),(7040,7115);

UNLOCK TABLES;

/*Data for the table `t_role` */

LOCK TABLES `t_role` WRITE;

insert  into `t_role`(`id`,`name`,`description`,`system_id`,`is_active`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (1,'超级管理员','权限系统超级管理员',1,1,'1',NULL,'1',NULL),(2,'数字货币管理员',NULL,7,1,'1','2019-04-01 17:41:54','1','2019-04-01 17:41:54');

UNLOCK TABLES;

/*Data for the table `t_role_group` */

LOCK TABLES `t_role_group` WRITE;

UNLOCK TABLES;

/*Data for the table `t_role_org` */

LOCK TABLES `t_role_org` WRITE;

UNLOCK TABLES;

/*Data for the table `t_role_resource` */

LOCK TABLES `t_role_resource` WRITE;

insert  into `t_role_resource`(`role_id`,`resource_id`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (2,7001,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7002,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7003,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7004,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7005,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7006,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7007,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7008,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7009,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7010,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7011,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7012,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7015,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7016,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7017,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7018,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7019,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7020,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7021,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7022,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7023,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7024,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7025,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7026,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7027,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7028,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7029,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7030,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7031,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7032,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7033,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7034,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7035,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7036,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7037,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7038,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7039,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7040,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7041,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7042,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7043,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7044,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7045,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7046,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7047,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7048,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7049,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7050,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7051,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7052,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7053,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7054,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7055,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7056,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7057,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7058,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7059,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7060,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7061,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7062,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7063,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7064,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7065,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7066,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7067,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7068,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7069,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7070,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7071,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7072,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7073,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7074,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7075,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7076,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7077,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7078,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7079,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7080,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7081,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7082,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7083,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7084,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7085,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7086,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7087,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7088,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7089,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7090,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7091,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7092,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7093,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7094,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7095,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7096,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7097,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7098,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7099,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7100,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7101,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7102,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7103,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7104,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7105,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7106,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7107,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7108,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7109,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7110,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7111,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7112,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7113,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7114,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50'),(2,7115,'systemadmin','2019-04-13 10:57:50','systemadmin','2019-04-13 10:57:50');

UNLOCK TABLES;

/*Data for the table `t_role_user` */

LOCK TABLES `t_role_user` WRITE;

insert  into `t_role_user`(`user_id`,`role_id`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (1,1,'1',NULL,'1',NULL),(2,2,'systemadmin','2019-04-01 17:42:04','systemadmin','2019-04-01 17:42:04');

UNLOCK TABLES;

/*Data for the table `t_system` */

LOCK TABLES `t_system` WRITE;

insert  into `t_system`(`id`,`name`,`description`) values (1,'SystemManager','权限管理系统'),(7,'Digital','数字货币');

UNLOCK TABLES;

/*Data for the table `t_system_param_set` */

LOCK TABLES `t_system_param_set` WRITE;

insert  into `t_system_param_set`(`id`,`param_code`,`param_name`,`param_value`,`remark`) values (1,'PASSWORD_EXPIRED_DAYS','用户密码过期天数','90','设置为0则不校验'),(2,'HIS_PASSWORD_RECORDS','用户历史密码保留记录数','5','设置为0则不保留');

UNLOCK TABLES;

/*Data for the table `t_user` */

LOCK TABLES `t_user` WRITE;

insert  into `t_user`(`id`,`login_name`,`user_name`,`pwd_algorithm`,`pwd_salt`,`password`,`change_pwd_date`,`pwd_error_times`,`is_active`,`description`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (1,'systemadmin','超级管理员','SHA-256','F12839WhsnnEV$#23b','6d8089335b1d6a9e157f682adfba778656fc87eb677aa3b8c0db90c79f6d7362','20190329',0,1,NULL,'1','2019-03-11 14:22:53','1','2019-03-29 22:05:45'),(2,'admin','数字货币管理员','SHA-256','F12839WhsnnEV$#23b','6d8089335b1d6a9e157f682adfba778656fc87eb677aa3b8c0db90c79f6d7362',NULL,NULL,1,NULL,'1','2019-04-01 17:41:24','1','2019-04-01 17:41:24');

UNLOCK TABLES;

/*Data for the table `t_user_hist_password` */

LOCK TABLES `t_user_hist_password` WRITE;

insert  into `t_user_hist_password`(`id`,`user_id`,`password`,`create_user`,`create_time`,`oper_user`,`oper_time`) values (1,1,'6d8089335b1d6a9e157f682adfba778656fc87eb677aa3b8c0db90c79f6d7362','1','2019-03-29 22:02:26','1','2019-03-29 22:02:26'),(2,1,'1bb2caf62f7540ff0f38d17ff269bee1ed874c353855b12c150ecb6e300881ef','1','2019-03-29 22:05:44','1','2019-03-29 22:05:44');

UNLOCK TABLES;

/*Data for the table `t_userinfo` */

LOCK TABLES `t_userinfo` WRITE;

insert  into `t_userinfo`(`id`,`user_id`,`employeeid`,`age`,`image_id`,`mail`,`mobile`,`qq`,`sex`,`telephone`) values (1,2,'001',NULL,NULL,'1232@qq.com',NULL,NULL,'1',NULL);

UNLOCK TABLES;
