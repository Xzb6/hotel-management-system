/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : localhost:3306
 Source Schema         : hotely5d

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 19/05/2025 14:08:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `gender` int NULL DEFAULT NULL COMMENT '性别',
  `head` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '管理员头像路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '管理员' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '1', '张峰', 1, '0818bd133bb24b78ab6617d44f634976.jpg');
INSERT INTO `admin` VALUES (2, 'admin', '1', '张峰', 1, 'a351ee32834b40c6bfde2d169b5ed82b.jpg');

-- ----------------------------
-- Table structure for appointment
-- ----------------------------
DROP TABLE IF EXISTS `appointment`;
CREATE TABLE `appointment`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` int NULL DEFAULT NULL COMMENT '用户',
  `room_id` int NULL DEFAULT NULL COMMENT '房间',
  `start_time` date NULL DEFAULT NULL COMMENT '入住时间',
  `days` int NULL DEFAULT NULL COMMENT '居住天数',
  `status` int NULL DEFAULT NULL COMMENT '状态',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '已付金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '预订' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of appointment
-- ----------------------------
INSERT INTO `appointment` VALUES (19, 4, 1, '2023-11-09', 1, 2, NULL, 300.00);
INSERT INTO `appointment` VALUES (22, 4, 5, '2024-09-27', 2, 1, NULL, 600.00);
INSERT INTO `appointment` VALUES (23, 3, 5, '2025-05-18', 1, 1, NULL, 600.00);
INSERT INTO `appointment` VALUES (24, 3, 4, '2025-05-18', 1, 1, NULL, 350.00);
INSERT INTO `appointment` VALUES (25, 3, 2, '2025-05-19', 1, 2, NULL, 350.00);
INSERT INTO `appointment` VALUES (27, 3, 7, '2025-05-15', 2, 2, NULL, 300.00);
INSERT INTO `appointment` VALUES (28, 4, 8, '2025-05-16', 3, 2, NULL, 350.00);
INSERT INTO `appointment` VALUES (29, 7, 9, '2025-05-17', 1, 3, '客户取消预订', 600.00);
INSERT INTO `appointment` VALUES (30, 3, 10, '2025-05-18', 2, 1, NULL, 450.00);
INSERT INTO `appointment` VALUES (31, 4, 11, '2025-05-17', 4, 2, NULL, 680.00);
INSERT INTO `appointment` VALUES (32, 7, 12, '2025-05-16', 2, 1, NULL, 120.00);
INSERT INTO `appointment` VALUES (34, 4, 6, '2025-05-13', 2, 2, NULL, 120.00);
INSERT INTO `appointment` VALUES (39, 3, 6, '2025-05-20', 2, 1, NULL, 120.00);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `category_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '房间类型',
  `photo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '房间图片',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `live_num` int NULL DEFAULT NULL COMMENT '可住人数',
  `bed_num` int NULL DEFAULT NULL COMMENT '床位数',
  `area` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '面积',
  `introduce` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '介绍',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '房型' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (2, '豪华单人房', '1.jpg', 300.00, 1, 1, '30', '豪华单人房');
INSERT INTO `category` VALUES (3, '经济双人房', '2.jpg', 350.00, 1, 2, '20', '经济双人房');
INSERT INTO `category` VALUES (4, '总统套房', '3.jpg', 600.00, 2, 2, '20', '总统套房');
INSERT INTO `category` VALUES (5, '经济单人房', '4.jpg', 120.00, 1, 1, '30', '经济单人房');
INSERT INTO `category` VALUES (6, '豪华双人房', 'cbfe93e3e3c2427aa2b7d130352c0467.png', 450.00, 2, 2, '35', '豪华双人房，设施齐全，视野开阔');
INSERT INTO `category` VALUES (7, '豪华双人房', '6ba9b33bf67d420fa883794930c7047b.png', 450.00, 2, 2, '35', '豪华双人房，设施齐全，视野开阔');

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `gender` int NULL DEFAULT NULL COMMENT '性别',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机',
  `idcard` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证',
  `head` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像',
  `create_time` datetime NULL DEFAULT NULL COMMENT '注册时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of member
-- ----------------------------
INSERT INTO `member` VALUES (3, 'fxr', '1', '方晓冉', 2, '18112345678', '430223197809127890', '95e703b604534fd2983183fbed3c6ad0.jpg', '2023-10-20 17:25:08');
INSERT INTO `member` VALUES (4, 'zxf', '1', '周先锋', 1, '17612345678', '430223197809121234', 'b15.jpg', '2023-10-20 17:26:09');

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` int NULL DEFAULT NULL COMMENT '用户',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '留言',
  `reply` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '回复',
  `create_time` datetime NULL DEFAULT NULL COMMENT '留言时间',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '回复时间',
  `status` int NULL DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '留言' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of message
-- ----------------------------
INSERT INTO `message` VALUES (1, 3, '很好的住宿体验！', '谢谢光临！', '2023-10-23 09:52:07', '2025-05-18 22:12:23', 2);
INSERT INTO `message` VALUES (2, 4, '性价比很高', '欢迎下次光临！', '2023-10-21 09:56:15', '2023-10-23 09:56:20', 2);
INSERT INTO `message` VALUES (4, 4, '希望能提供更多的早餐选择', '已收到您的建议，我们会改进的', '2025-05-16 08:45:22', '2025-05-16 10:15:33', 2);
INSERT INTO `message` VALUES (5, 3, '很好的住宿体验！', '谢谢光临！', '2025-05-17 22:10:05', '2025-05-19 11:46:17', 2);
INSERT INTO `message` VALUES (6, 3, '很好的住宿体验！', '谢谢光临！', '2025-05-19 11:42:58', '2025-05-19 12:18:30', 2);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '公告内容',
  `create_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, ' 公司本次股东大会的召集和召开程序符合《公司法》、《证券法》等相关法律、行政法规、《股东大会规则》和《公司章程》的规定；出席本次股东大会的人员和召集人的资格合法有效；本次股东大会的表决程序和表决结果合法有效。\n特此公告。', '2023-10-23 09:06:41', '2023 年第二次临时股东大会决议公告');
INSERT INTO `notice` VALUES (3, ' 时尚之旅酒店管理有限公司（以下简称“时尚之旅”或“标的股权”）为上海锦江国际酒店股份有限公司（以下简称“公司”）全资子公司，拥有 21 家酒店物业。公司所持时尚之旅 100%股权的评估价值为人民币 165,498.89 万元，公司将以不低于经国资备案的评估价值作为挂牌底价，最终交易价格根据公开挂牌结果确定。\n\n根据国有资产管理的有关规定，在正式挂牌转让前，公司将在上海联合产权交易所进行预挂牌。\n\n本次股权转让事项不构成《上市公司重大资产重组管理办法》规定的重大资产重组。', '2023-10-27 10:59:14', '关于挂牌转让时尚之旅酒店管理有限公司 100%股权的公告');
INSERT INTO `notice` VALUES (4, '一、 本公司董事会、监事会及董事、监事、高级管理人员保证半年度报告内容的真实性、准确性、完整\n    性，不存在虚假记载、误导性陈述或重大遗漏，并承担个别和连带的法律责任。\n\n二、 本公司第十届董事会第十八次会议于 2023 年 8 月 28 日审议通过了本半年度报告。公司全体董事\n    出席董事会会议。\n三、 本半年度报告未经审计。本公司按中国企业会计准则编制 2023 年半年度财务报表，经德勤华永会\n    计师事务所（特殊普通合伙）审阅，并出具了德师报(阅)字(23)第 R00044 号标准无保留意见的审\n    阅报告。\n四、 公司负责人董事长张晓强先生、首席执行官沈莉女士、主管会计工作负责人首席财务官艾耕云及\n    会计机构负责人吴琳女士声明：保证半年度报告中财务报告的真实、准确、完整。', '2023-10-27 14:24:14', '2023 年半年度报告');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` int NULL DEFAULT NULL COMMENT '用户',
  `room_id` int NULL DEFAULT NULL COMMENT '房间',
  `start_time` datetime NULL DEFAULT NULL COMMENT '入住时间',
  `days` int NULL DEFAULT NULL COMMENT '居住天数',
  `status` int NULL DEFAULT NULL COMMENT '状态(1-已预订 2-已入住 3-已退房)',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '实付金额',
  `check_out_time` datetime NULL DEFAULT NULL COMMENT '退房时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '入住' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (8, 3, 1, '2023-11-10 00:00:00', 1, 3, NULL, 300.00, NULL);
INSERT INTO `orders` VALUES (10, 3, 2, '2025-05-19 00:00:00', 1, 3, NULL, 350.00, NULL);
INSERT INTO `orders` VALUES (11, 4, 8, '2025-05-16 00:00:00', 3, 2, NULL, 350.00, NULL);
INSERT INTO `orders` VALUES (12, 7, 6, '2025-05-13 00:00:00', 2, 3, '客人提前退房', 120.00, '2025-05-14 10:30:00');
INSERT INTO `orders` VALUES (13, 3, 7, '2025-05-15 00:00:00', 2, 2, NULL, 300.00, NULL);
INSERT INTO `orders` VALUES (14, 4, 11, '2025-05-17 00:00:00', 4, 1, NULL, 680.00, NULL);
INSERT INTO `orders` VALUES (15, 3, 10, '2025-05-13 00:00:00', 1, 3, NULL, 450.00, '2025-05-14 09:15:00');
INSERT INTO `orders` VALUES (16, 7, 9, '2025-05-14 00:00:00', 2, 1, NULL, 600.00, NULL);
INSERT INTO `orders` VALUES (17, 4, 6, '2025-05-12 00:00:00', 1, 3, NULL, 120.00, '2025-05-13 11:45:00');
INSERT INTO `orders` VALUES (18, 3, 12, '2025-05-18 00:00:00', 3, 1, NULL, 120.00, NULL);

-- ----------------------------
-- Table structure for room
-- ----------------------------
DROP TABLE IF EXISTS `room`;
CREATE TABLE `room`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `room_num` int NULL DEFAULT NULL COMMENT '房间号',
  `category_id` int NULL DEFAULT NULL COMMENT '房型',
  `status` int NULL DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客房' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of room
-- ----------------------------
INSERT INTO `room` VALUES (1, 101, 2, 1);
INSERT INTO `room` VALUES (2, 102, 3, 1);
INSERT INTO `room` VALUES (3, 103, 4, 1);
INSERT INTO `room` VALUES (4, 201, 3, 1);
INSERT INTO `room` VALUES (5, 202, 4, 1);
INSERT INTO `room` VALUES (6, 203, 5, 1);
INSERT INTO `room` VALUES (7, 301, 2, 1);
INSERT INTO `room` VALUES (8, 302, 3, 1);
INSERT INTO `room` VALUES (9, 303, 4, 1);
INSERT INTO `room` VALUES (10, 401, 6, 1);
INSERT INTO `room` VALUES (11, 402, 7, 1);
INSERT INTO `room` VALUES (12, 501, 5, 1);

SET FOREIGN_KEY_CHECKS = 1;
