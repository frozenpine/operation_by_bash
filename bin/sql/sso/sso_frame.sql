/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 5.7.25 : Database - security
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`sso` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `sso`;

/*Table structure for table `sso_perm` */

DROP TABLE IF EXISTS `sso_perm`;

CREATE TABLE `sso_perm` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `perm` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '权限(也即资源地址,如菜单地址)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='用户权限表';

/*Table structure for table `sso_resource` */

DROP TABLE IF EXISTS `sso_resource`;

CREATE TABLE `sso_resource` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `res` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '资源标识(如：菜单Url、Rest服务地址等)',
  `restype` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '资源类型(如:menu/rest/method/button)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='系统资源表';

/*Table structure for table `sso_resource_acl` */

DROP TABLE IF EXISTS `sso_resource_acl`;

CREATE TABLE `sso_resource_acl` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `res` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '资源标识(如：菜单Url、Rest服务地址等)',
  `acl` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'shiro资源访问控制列表,如:roles[100002],perms[ADD]等',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='系统资源表';

/*Table structure for table `sso_role` */

DROP TABLE IF EXISTS `sso_role`;

CREATE TABLE `sso_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `role` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `sso_user` */

DROP TABLE IF EXISTS `sso_user`;

CREATE TABLE `sso_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loginname` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pwd_salt` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pwd_algorithm` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '密码签名算法',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `t_group` */

DROP TABLE IF EXISTS `t_group`;

CREATE TABLE `t_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_group_user` */

DROP TABLE IF EXISTS `t_group_user`;

CREATE TABLE `t_group_user` (
  `group_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`group_id`,`user_id`),
  KEY `IDX_T_GROUP_USER_USERID` (`user_id`),
  KEY `IDX_T_GROUP_USER_GROUPID` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_log` */

DROP TABLE IF EXISTS `t_log`;

CREATE TABLE `t_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '逻辑id',
  `user_id` bigint(20) NOT NULL COMMENT '用户Id',
  `login_ip` varchar(30) DEFAULT NULL COMMENT '登录ip',
  `operate_model` tinyint(4) DEFAULT NULL COMMENT '操作模块1用户管理2组织管理3角色管理',
  `operate_type` tinyint(4) NOT NULL COMMENT '操作状态1成功0失败',
  `description` varchar(400) DEFAULT NULL COMMENT '操作内容',
  `oper_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8 COMMENT='业务日志表';

/*Table structure for table `t_online_user` */

DROP TABLE IF EXISTS `t_online_user`;

CREATE TABLE `t_online_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `login_ip` varchar(50) DEFAULT NULL,
  `login_time` varchar(50) DEFAULT NULL,
  `login_id` varchar(50) NOT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_T_ONLINE_USER_LOGINID_LOGINIP` (`login_id`,`login_ip`)
) ENGINE=InnoDB AUTO_INCREMENT=799 DEFAULT CHARSET=utf8 COMMENT='在线用户统计表';

/*Table structure for table `t_org_admin` */

DROP TABLE IF EXISTS `t_org_admin`;

CREATE TABLE `t_org_admin` (
  `org_unit_id` bigint(20) unsigned NOT NULL COMMENT '组织id',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `create_user` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT NULL,
  `oper_user` varchar(30) DEFAULT NULL COMMENT '操作员',
  `oper_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  UNIQUE KEY `IDX_T_ORG_ADMIN_USERID_ORGUNITID` (`user_id`,`org_unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组织管理员表';

/*Table structure for table `t_org_unit` */

DROP TABLE IF EXISTS `t_org_unit`;

CREATE TABLE `t_org_unit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '逻辑主键',
  `code` varchar(30) NOT NULL COMMENT '组织代码',
  `parent_code` varchar(30) NOT NULL COMMENT '父组织代码',
  `name` varchar(80) NOT NULL COMMENT '组织名称',
  `address` varchar(200) DEFAULT NULL COMMENT '地址',
  `telephone` varchar(20) DEFAULT NULL COMMENT '电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `type_id` bigint(20) NOT NULL COMMENT '组织结构类型ID',
  `is_active` tinyint(4) NOT NULL COMMENT '是否启用1是0否',
  `description` varchar(400) DEFAULT NULL COMMENT '描述',
  `create_user` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  `oper_user` varchar(30) DEFAULT NULL COMMENT '操作员',
  `oper_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UX_T_ORG_UNIT_CODE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='组织单位表';

/*Table structure for table `t_org_unit_resource` */

DROP TABLE IF EXISTS `t_org_unit_resource`;

CREATE TABLE `t_org_unit_resource` (
  `org_unit_id` bigint(20) unsigned NOT NULL COMMENT '组织id',
  `resource_id` bigint(20) NOT NULL COMMENT '资源id',
  PRIMARY KEY (`org_unit_id`,`resource_id`),
  KEY `IDX_T_ORG_UNIT_RESOURCE_ORGUNITID` (`org_unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组织可分配的资源';

/*Table structure for table `t_org_unit_type` */

DROP TABLE IF EXISTS `t_org_unit_type`;

CREATE TABLE `t_org_unit_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '逻辑主键',
  `code` varchar(30) NOT NULL COMMENT '类型代码',
  `name` varchar(80) NOT NULL COMMENT '类型名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='组织类型表字典';

/*Table structure for table `t_org_user` */

DROP TABLE IF EXISTS `t_org_user`;

CREATE TABLE `t_org_user` (
  `org_unit_id` bigint(20) unsigned NOT NULL COMMENT '组织Id',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户Id',
  `create_user` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  `oper_user` varchar(30) DEFAULT NULL COMMENT '操作员',
  `oper_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`org_unit_id`,`user_id`),
  KEY `IDX_T_ORG_USER_USERID` (`user_id`),
  KEY `IDX_T_ORG_USER_ORGUNITID` (`org_unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组织用户关系表';

/*Table structure for table `t_resource` */

DROP TABLE IF EXISTS `t_resource`;

CREATE TABLE `t_resource` (
  `id` bigint(20) NOT NULL,
  `resource_content` varchar(255) NOT NULL,
  `resource_name` varchar(255) NOT NULL,
  `public_access` tinyint(4) DEFAULT '0' COMMENT '是否可以公开匿名访问。(0-不公开,1-公开,默认为0不公开访问)',
  `resource_type` smallint(6) DEFAULT NULL COMMENT '资源类型(0-menu、1-button、2-rest、3-service)',
  `system_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_T_RESOURCE_SYSTEMID_RESTYPE` (`system_id`,`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统资源表';

/*Table structure for table `t_resource_relation` */

DROP TABLE IF EXISTS `t_resource_relation`;

CREATE TABLE `t_resource_relation` (
  `parent_resource_id` bigint(20) NOT NULL,
  `resource_id` bigint(20) NOT NULL COMMENT '资源类型(0-menu、1-button、2-service)',
  PRIMARY KEY (`parent_resource_id`,`resource_id`),
  KEY `IDX_T_RESOURCE_RELATION_PARENTRESID` (`parent_resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统资源表';

/*Table structure for table `t_role` */

DROP TABLE IF EXISTS `t_role`;

CREATE TABLE `t_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `name` varchar(80) NOT NULL COMMENT '角色名称',
  `description` varchar(40) DEFAULT NULL COMMENT '描述',
  `system_id` int(11) NOT NULL COMMENT '系统Id',
  `is_active` tinyint(4) NOT NULL COMMENT '1启用0禁用',
  `create_user` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `oper_user` varchar(30) DEFAULT NULL COMMENT '操作员',
  `oper_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `IDX_T_ROLE_SYSTEMID` (`system_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='角色表';

/*Table structure for table `t_role_group` */

DROP TABLE IF EXISTS `t_role_group`;

CREATE TABLE `t_role_group` (
  `role_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`role_id`,`group_id`),
  KEY `IDX_T_ROLE_GROUP_GROUPID` (`group_id`),
  KEY `IDX_T_ROLE_GROUP_ROLEID` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_role_org` */

DROP TABLE IF EXISTS `t_role_org`;

CREATE TABLE `t_role_org` (
  `role_id` bigint(20) NOT NULL,
  `org_unit_id` bigint(20) NOT NULL,
  PRIMARY KEY (`role_id`,`org_unit_id`),
  KEY `IDX_T_ROLE_ORG_ORGUNITID` (`org_unit_id`),
  KEY `IDX_T_ROLE_ORG_ROLEID` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_role_resource` */

DROP TABLE IF EXISTS `t_role_resource`;

CREATE TABLE `t_role_resource` (
  `role_id` bigint(20) NOT NULL COMMENT '角色id',
  `resource_id` bigint(20) NOT NULL COMMENT '资源id',
  `create_user` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `oper_user` varchar(30) DEFAULT NULL COMMENT '操作员',
  `oper_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`role_id`,`resource_id`),
  KEY `IDX_T_ROLE_PERMISSION_RESOURCEID` (`resource_id`),
  KEY `IDX_T_ROLE_PERMISSION_ROLEID` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_role_user` */

DROP TABLE IF EXISTS `t_role_user`;

CREATE TABLE `t_role_user` (
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户id',
  `role_id` bigint(20) NOT NULL COMMENT '角色id',
  `create_user` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `oper_user` varchar(30) DEFAULT NULL COMMENT '操作员',
  `oper_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `IDX_T_ROLE_USER_USERID` (`user_id`),
  KEY `IDX_T_ROLE_USER_ROLEID` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户角色';

/*Table structure for table `t_system` */

DROP TABLE IF EXISTS `t_system`;

CREATE TABLE `t_system` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '系统ID',
  `name` varchar(80) NOT NULL COMMENT '系统名称',
  `description` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='系统';

/*Table structure for table `t_system_param_set` */

DROP TABLE IF EXISTS `t_system_param_set`;

CREATE TABLE `t_system_param_set` (
  `id` bigint(20) NOT NULL COMMENT '逻辑主键ID',
  `param_code` varchar(50) NOT NULL COMMENT '参数代码',
  `param_name` varchar(100) NOT NULL COMMENT '参数名称',
  `param_value` varchar(200) NOT NULL COMMENT '参数值',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UX_T_SYSTEM_PARAM_SET_PARAMCODE` (`param_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统参数设置信息';

/*Table structure for table `t_user` */

DROP TABLE IF EXISTS `t_user`;

CREATE TABLE `t_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '逻辑主键',
  `login_name` varchar(30) NOT NULL COMMENT '用户登录账号',
  `user_name` varchar(80) NOT NULL COMMENT '用户姓名',
  `pwd_algorithm` varchar(30) NOT NULL COMMENT '密码加密方式',
  `pwd_salt` varchar(30) NOT NULL COMMENT '密码盐',
  `password` varchar(64) NOT NULL COMMENT '密码',
  `change_pwd_date` varchar(8) DEFAULT NULL COMMENT '密码更新日期',
  `pwd_error_times` tinyint(4) DEFAULT NULL COMMENT '密码输入错误次数',
  `is_active` tinyint(4) NOT NULL COMMENT '用户状态',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `create_user` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `oper_user` varchar(30) DEFAULT NULL COMMENT '操作员',
  `oper_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UX_T_USER_LOGINNAME` (`login_name`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='用户表';

/*Table structure for table `t_user_hist_password` */

DROP TABLE IF EXISTS `t_user_hist_password`;

CREATE TABLE `t_user_hist_password` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '逻辑主键ID',
  `user_id` bigint(20) NOT NULL COMMENT '户用ID',
  `password` varchar(100) NOT NULL COMMENT '用户密码',
  `create_user` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `oper_user` varchar(30) DEFAULT NULL COMMENT '操作员',
  `oper_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `IDX_T_HIS_USER_PASSWORD_USERID` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户历史密码记录表.';

/*Table structure for table `t_userinfo` */

DROP TABLE IF EXISTS `t_userinfo`;

CREATE TABLE `t_userinfo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `employeeid` varchar(30) DEFAULT NULL COMMENT '员工编号',
  `age` int(11) DEFAULT NULL,
  `image_id` varchar(100) DEFAULT NULL,
  `mail` varchar(100) DEFAULT NULL,
  `mobile` varchar(100) DEFAULT NULL,
  `qq` varchar(20) DEFAULT NULL,
  `sex` varchar(100) DEFAULT NULL,
  `telephone` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UX_T_USERINFO_USERID` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
