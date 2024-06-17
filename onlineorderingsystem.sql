/*
 Navicat Premium Dump SQL

 Source Server         : 2101
 Source Server Type    : MySQL
 Source Server Version : 80037 (8.0.37)
 Source Host           : localhost:3306
 Source Schema         : onlineorderingsystem

 Target Server Type    : MySQL
 Target Server Version : 80037 (8.0.37)
 File Encoding         : 65001

 Date: 17/06/2024 09:16:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 105 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (103, 2, 2, 1);
INSERT INTO `cart` VALUES (104, 2, 3, 1);

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (1, '鱼香肉丝', 15.00);
INSERT INTO `products` VALUES (2, '红烧茄子', 12.00);
INSERT INTO `products` VALUES (3, '烧豆腐', 10.00);
INSERT INTO `products` VALUES (4, '白米饭', 2.00);
INSERT INTO `products` VALUES (5, '小龙虾', 15.00);
INSERT INTO `products` VALUES (6, '剁椒鱼头', 25.00);
INSERT INTO `products` VALUES (7, '鱼香茄子', 10.00);
INSERT INTO `products` VALUES (8, '柠檬鸭', 35.00);
INSERT INTO `products` VALUES (9, '水煮肉片', 24.00);
INSERT INTO `products` VALUES (10, '烧汁鱿鱼', 18.00);
INSERT INTO `products` VALUES (11, '椒盐排骨', 36.00);
INSERT INTO `products` VALUES (12, '虾仁西兰花', 14.00);
INSERT INTO `products` VALUES (13, '水煮牛肉', 48.00);
INSERT INTO `products` VALUES (14, '清炒莴苣丝', 16.00);
INSERT INTO `products` VALUES (15, '酸辣土豆丝', 15.00);
INSERT INTO `products` VALUES (16, '炸小酥肉', 25.00);
INSERT INTO `products` VALUES (17, '辣椒炒肉', 39.00);
INSERT INTO `products` VALUES (18, '酒糟汤圆', 18.00);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_admin` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `username_2`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', 'admin', 1);
INSERT INTO `users` VALUES (2, 'user1', 'user1', 0);
INSERT INTO `users` VALUES (35, '张三', '123456', 1);

SET FOREIGN_KEY_CHECKS = 1;
