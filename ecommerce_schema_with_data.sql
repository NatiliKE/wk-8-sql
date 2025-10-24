-- ecommerce_schema_with_data.sql
-- E-COMMERCE STORE: Complete Database Schema with sample data
-- Save as ecommerce_schema_with_data.sql and run in MySQL Workbench
-- MySQL InnoDB engine, utf8mb4 character set

-- =====================================================
-- 1) Create database and switch to it
-- =====================================================
CREATE DATABASE IF NOT EXISTS ecommerce_store
    CHARACTER SET = 'utf8mb4'
    COLLATE = 'utf8mb4_unicode_ci';
USE ecommerce_store;

-- =====================================================
-- 2) Core tables
-- =====================================================

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(30),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    label VARCHAR(50) DEFAULT 'home',
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    parent_id INT DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(30),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(64) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    supplier_id INT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE product_categories (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    last_updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    shipping_address_id INT,
    order_status VARCHAR(50) NOT NULL DEFAULT 'pending',
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
    shipping DECIMAL(10,2) NOT NULL DEFAULT 0,
    tax DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(12,2) NOT NULL DEFAULT 0,
    placed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (shipping_address_id) REFERENCES addresses(address_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    quantity INT NOT NULL CHECK (quantity > 0),
    line_total DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(12,2) NOT NULL CHECK (amount >= 0),
    currency VARCHAR(10) NOT NULL DEFAULT 'USD',
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    processed_at DATETIME DEFAULT NULL,
    transaction_reference VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255),
    body TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- 3) Indexes
-- =====================================================
CREATE INDEX idx_products_name ON products(name(100));
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_categories_name ON categories(name);

-- =====================================================
-- 4) Sample data (demo rows)
-- =====================================================

INSERT INTO customers (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john.doe@example.com', '0711000000'),
('Jane', 'Smith', 'jane.smith@example.com', '0711000001'),
('Emily', 'Clark', 'emily.clark@example.com', '0711000002');

INSERT INTO addresses (customer_id, label, street, city, state, postal_code, country, is_default) VALUES
(1, 'home', '123 Main St', 'Nairobi', 'Nairobi County', '00100', 'Kenya', TRUE),
(2, 'home', '456 Market Rd', 'Mombasa', 'Mombasa County', '80100', 'Kenya', TRUE),
(3, 'home', '789 Central Ave', 'Kisumu', 'Kisumu County', '40100', 'Kenya', TRUE);

INSERT INTO suppliers (name, contact_email, contact_phone) VALUES
('Acme Electronics', 'sales@acmeelectronics.com', '0712000000'),
('Global Gadgets', 'contact@globalgadgets.com', '0712000001');

INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic devices'),
('Computers', 'Computers and accessories'),
('Phones', 'Mobile phones');

INSERT INTO products (sku, name, description, price, supplier_id) VALUES
('SKU-1001', 'Laptop Pro 15', 'High-performance laptop', 1499.99, 1),
('SKU-2001', 'Wireless Mouse', 'Ergonomic wireless mouse', 29.99, 1),
('SKU-3001', 'Smartphone X', 'Latest smartphone', 999.99, 2),
('SKU-4001', 'USB-C Charger', 'Fast charger 45W', 19.99, 2);

INSERT INTO product_categories (product_id, category_id) VALUES
(1, 1), (1, 2),
(2, 2),
(3, 1), (3, 3),
(4, 1);

INSERT INTO inventory (product_id, quantity) VALUES
(1, 10), (2, 200), (3, 50), (4, 500);

-- Create an order with items (order 1: John)
INSERT INTO orders (customer_id, shipping_address_id, order_status, subtotal, shipping, tax, total)
VALUES (1, 1, 'pending', 1529.98, 20.00, 152.99, 1702.97);

INSERT INTO order_items (order_id, product_id, unit_price, quantity, line_total) VALUES
(1, 1, 1499.99, 1, 1499.99),
(1, 2, 29.99, 1, 29.99);

INSERT INTO payments (order_id, payment_method, amount, currency, status, processed_at, transaction_reference)
VALUES (1, 'card', 1702.97, 'USD', 'completed', NOW(), 'TXN123456');

-- Order 2: Jane
INSERT INTO orders (customer_id, shipping_address_id, order_status, subtotal, shipping, tax, total)
VALUES (2, 2, 'paid', 1019.98, 10.00, 102.00, 1131.98);

INSERT INTO order_items (order_id, product_id, unit_price, quantity, line_total) VALUES
(2, 3, 999.99, 1, 999.99),
(2, 4, 19.99, 1, 19.99);

INSERT INTO payments (order_id, payment_method, amount, currency, status, processed_at, transaction_reference)
VALUES (2, 'paypal', 1131.98, 'USD', 'completed', NOW(), 'TXN654321');

-- Reviews
INSERT INTO reviews (product_id, customer_id, rating, title, body) VALUES
(1, 1, 5, 'Fantastic!', 'This laptop exceeded my expectations.'),
(2, 1, 4, 'Good mouse', 'Works well and comfortable.'),
(3, 2, 5, 'Amazing phone', 'Battery lasts all day.');

-- =====================================================
-- 5) Quick verification queries (run these to see demo data)
-- =====================================================
-- SELECT COUNT(*) FROM customers;
-- SELECT * FROM customers;
-- SELECT * FROM products;
-- SELECT * FROM orders;
-- SELECT * FROM order_items;
-- SELECT * FROM payments;
-- SELECT * FROM reviews;

-- End of file
