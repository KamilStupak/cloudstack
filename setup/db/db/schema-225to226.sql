# Copyright (C) 2011 Citrix Systems, Inc.  All rights reserved
#     
# This software is licensed under the GNU General Public License v3 or later.
# 
# It is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
--;
-- Schema upgrade from 2.2.5 to 2.2.6;
--;

ALTER TABLE `cloud`.`storage_pool` MODIFY `host_address` varchar(255) NOT NULL;

ALTER TABLE `cloud`.`network_offerings` MODIFY `name` varchar(64) NOT NULL COMMENT 'name of the network offering';
ALTER TABLE `cloud`.`network_offerings` ADD COLUMN `unique_name` varchar(64) NOT NULL COMMENT 'unique name of the network offering';
UPDATE `cloud`.`network_offerings` SET unique_name=name;
ALTER TABLE `cloud`.`network_offerings` MODIFY `unique_name` varchar(64) NOT NULL UNIQUE COMMENT 'unique name of the network offering';

DROP TABLE IF EXISTS `cloud`.`certificate`;
CREATE TABLE IF NOT EXISTS `cloud`.`keystore` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(64) NOT NULL COMMENT 'unique name for the certifiation',
  `certificate` text NOT NULL COMMENT 'the actual certificate being stored in the db',
  `key` text NOT NULL COMMENT 'private key associated wih the certificate',
  `domain_suffix` varchar(256) NOT NULL COMMENT 'DNS domain suffix associated with the certificate',
  PRIMARY KEY (`id`),
  UNIQUE(name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `cloud`.`cmd_exec_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `host_id` bigint unsigned NOT NULL COMMENT 'host id of the system VM agent that command is sent to',
  `instance_id` bigint unsigned NOT NULL COMMENT 'instance id of the system VM that command is executed on',
  `command_name` varchar(255) NOT NULL COMMENT 'command name',
  `weight` integer NOT NULL DEFAULT 1 COMMENT 'command weight in consideration of the load factor added to host that is executing the command',
  `created` datetime NOT NULL COMMENT 'date created',
  PRIMARY KEY (`id`),
  INDEX `i_cmd_exec_log__host_id`(`host_id`),
  INDEX `i_cmd_exec_log__instance_id`(`instance_id`),
  CONSTRAINT `fk_cmd_exec_log_ref__inst_id` FOREIGN KEY (`instance_id`) REFERENCES `vm_instance`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

