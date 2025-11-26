USE inventory_order_db;

SET default_storage_engine = INNODB;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS inventory_logs;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20)
) ENGINE = InnoDB;


CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    reorder_level INT NOT NULL DEFAULT 5 CHECK (reorder_level >= 0)
) ENGINE = InnoDB;


CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
        ON DELETE RESTRICT  
) ENGINE = InnoDB;


CREATE TABLE order_details (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) 
        ON DELETE CASCADE,   
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
        ON DELETE RESTRICT   
)ENGINE = InnoDB;


CREATE TABLE inventory_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    change_type VARCHAR(10) NOT NULL CHECK (change_type IN ('ORDER', 'REPLENISH')),
    quantity_change INT NOT NULL,
    order_id INT NULL,  
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
        ON DELETE CASCADE,   
    FOREIGN KEY (order_id) REFERENCES orders(order_id) 
        ON DELETE SET NULL   
) ENGINE = InnoDB;

