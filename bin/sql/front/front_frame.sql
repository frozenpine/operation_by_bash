/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`front` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `front`;

CREATE
    /*[ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
    [DEFINER = { user | CURRENT_USER }]
    [SQL SECURITY { DEFINER | INVOKER }]*/
    VIEW `front`.`v_api_key`
    AS
(SELECT user_id AS client_id, secret_key AS secret, is_active AS active, key_right, key_id FROM digital.t_api_key);

CREATE
    /*[ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
    [DEFINER = { user | CURRENT_USER }]
    [SQL SECURITY { DEFINER | INVOKER }]*/
    VIEW `front`.`v_api_key_permission`
    AS
(SELECT  concat(`t_key_rigth_relation`.`request_type`,`t_key_rigth_relation`.`request_path`) AS `permission`,  `t_key_rigth_relation`.`key_right` AS `key_right` FROM `digital`.`t_key_rigth_relation`);
