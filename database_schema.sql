-- ============================================================
-- Database Schema for Inventory Management System
-- ============================================================

CREATE DATABASE IF NOT EXISTS inventory_db;
USE inventory_db;

-- 1. Admin Table
CREATE TABLE IF NOT EXISTS `admin` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Default Admin Account
INSERT INTO `admin` (`username`, `password`)
VALUES ('chaithanya', 'chaithu1215')
ON DUPLICATE KEY UPDATE `username`=`username`;

-- 2. Suppliers Table
CREATE TABLE IF NOT EXISTS `suppliers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) DEFAULT NULL,
  `phone` VARCHAR(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample Suppliers
INSERT INTO `suppliers` (`id`, `name`, `email`, `phone`) VALUES
(1, 'Tech Supplies Co.', 'sales@techsupplies.com', '9876543210'),
(2, 'Global Components', 'contact@globalcomp.com', '9876543211')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- 3. Products Table
CREATE TABLE IF NOT EXISTS `products` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `category` VARCHAR(50) DEFAULT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `quantity` INT NOT NULL DEFAULT '0',
  `supplier_id` INT DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample Products
INSERT INTO `products` (`id`, `name`, `category`, `price`, `quantity`, `supplier_id`) VALUES
(1, 'Keyboard', 'Electronics', 500.00, 23, 1),
(2, 'Mouse', 'Electronics', 300.00, 15, 2),
(3, 'Monitor', 'Electronics', 8000.00, 5, 1),
(7, 'Laptop', 'Electronics', 55000.00, 10, 1)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- 4. Stock History Table
CREATE TABLE IF NOT EXISTS `stock_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `type` ENUM('IN','OUT') NOT NULL,
  `quantity` INT NOT NULL,
  `transaction_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `stock_history_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
