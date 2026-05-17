-- aifstock 后台公共底座初始化 SQL
-- 仅保留当前项目需要的公共能力表结构：管理员、菜单、菜单按钮权限、角色资源权限、角色菜单、角色按钮权限。
-- 已移除旧门户端、旅游业务、内容管理、监控统计等业务表与全部历史数据。

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `aifstock`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `aifstock`;

DROP TABLE IF EXISTS `t_role_menu_permission`;
DROP TABLE IF EXISTS `t_role_menu`;
DROP TABLE IF EXISTS `t_menu_permission`;
DROP TABLE IF EXISTS `t_role_access`;
DROP TABLE IF EXISTS `t_menu`;
DROP TABLE IF EXISTS `t_admin`;

CREATE TABLE `t_admin` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(50) NOT NULL COMMENT '管理员账号（唯一）',
  `password` varchar(100) NOT NULL COMMENT 'BCrypt 加密密码',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `introduction` varchar(255) DEFAULT NULL COMMENT '个人介绍',
  `role_code` varchar(100) NOT NULL DEFAULT 'ADMIN' COMMENT '角色编码集合，逗号分隔',
  `is_super` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否超级管理员：1是 0否',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：1启用 0禁用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除：0否 1是',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_admin_username` (`username`),
  KEY `idx_admin_role_code` (`role_code`),
  KEY `idx_admin_status_deleted` (`status`, `is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台管理员表';

CREATE TABLE `t_menu` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '父级菜单ID，0表示根节点',
  `name` varchar(100) DEFAULT NULL COMMENT '路由名称',
  `path` varchar(255) NOT NULL COMMENT '前端路由路径',
  `redirect` varchar(255) DEFAULT NULL COMMENT '重定向路径',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `title` varchar(200) NOT NULL COMMENT '菜单标题（meta.title）',
  `icon` varchar(100) DEFAULT NULL COMMENT '菜单图标',
  `is_hide` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否在菜单中隐藏',
  `is_hide_tab` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否在标签页中隐藏',
  `show_badge` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否展示徽章',
  `show_text_badge` varchar(100) DEFAULT NULL COMMENT '徽章文本',
  `keep_alive` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否缓存页面',
  `fixed_tab` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否固定标签页',
  `active_path` varchar(255) DEFAULT NULL COMMENT '激活的路径',
  `link` varchar(255) DEFAULT NULL COMMENT '外链',
  `is_iframe` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为 iframe 页面',
  `is_full_page` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为全屏页面',
  `is_first_level` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否一级菜单',
  `parent_path` varchar(255) DEFAULT NULL COMMENT '父级路径缓存（meta.parentPath）',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '排序号，越大越靠前',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：1启用 0禁用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除：0否 1是',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_menu_parent` (`parent_id`),
  KEY `idx_menu_path` (`path`),
  KEY `idx_menu_status_deleted_order` (`status`, `is_deleted`, `order_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台菜单表';

CREATE TABLE `t_role_access` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_code` varchar(100) NOT NULL COMMENT '角色编码',
  `resource_key` varchar(100) NOT NULL COMMENT '资源键，例如 ADMIN_ACCOUNT/MENU/FILE',
  `action` varchar(100) NOT NULL COMMENT '动作键，例如 CREATE/READ/UPLOAD',
  `allow` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否允许：1允许 0拒绝',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_resource_action` (`role_code`, `resource_key`, `action`),
  KEY `idx_role_access_role` (`role_code`),
  KEY `idx_role_access_resource_action` (`resource_key`, `action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色-资源-动作权限表';

CREATE TABLE `t_menu_permission` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `menu_id` bigint unsigned NOT NULL COMMENT '关联菜单ID',
  `title` varchar(100) NOT NULL COMMENT '权限显示名称',
  `auth_mark` varchar(100) NOT NULL COMMENT '权限标识',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序值',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_menu_permission_mark` (`menu_id`, `auth_mark`),
  KEY `idx_menu_permission_menu` (`menu_id`),
  KEY `idx_menu_permission_auth_mark` (`auth_mark`),
  CONSTRAINT `fk_menu_permission_menu`
    FOREIGN KEY (`menu_id`) REFERENCES `t_menu` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单按钮/操作权限表';

CREATE TABLE `t_role_menu` (
  `role_code` varchar(100) NOT NULL COMMENT '角色编码',
  `menu_id` bigint unsigned NOT NULL COMMENT '菜单ID',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`role_code`, `menu_id`),
  KEY `idx_role_menu_role` (`role_code`),
  KEY `idx_role_menu_menu` (`menu_id`),
  CONSTRAINT `fk_role_menu_menu`
    FOREIGN KEY (`menu_id`) REFERENCES `t_menu` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色-菜单授权表';

CREATE TABLE `t_role_menu_permission` (
  `role_code` varchar(100) NOT NULL COMMENT '角色编码',
  `permission_id` bigint unsigned NOT NULL COMMENT '按钮/操作权限ID',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`role_code`, `permission_id`),
  KEY `idx_role_permission_role` (`role_code`),
  KEY `idx_role_permission_id` (`permission_id`),
  CONSTRAINT `fk_role_permission_permission`
    FOREIGN KEY (`permission_id`) REFERENCES `t_menu_permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色-按钮权限授权表';

SET FOREIGN_KEY_CHECKS = 1;
