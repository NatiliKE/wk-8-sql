🛍️ E-Commerce Store Database Schema
📘 Overview

This project contains a relational database schema for an E-Commerce Store, designed using MySQL.
It models real-world online store operations — including customers, products, suppliers, orders, payments, and reviews — following best practices in database normalization.

The schema ensures:

Data integrity via foreign keys and constraints

1NF, 2NF, and 3NF normalization

Scalability for future extensions (e.g., warehouses, coupons, variants)

🧩 Key Features

✅ Well-structured tables with constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK)

🔗 Relationships:

One-to-Many (Customers → Addresses, Products → Reviews)

Many-to-Many (Products ↔ Categories, Orders ↔ Products)

📦 Inventory management with quantity tracking

💳 Payment and order tracking

⭐ Product reviews with rating validation (1–5)

🧱 Indexes to improve query performance

🧱 Database Schema Design
🧍 Customers & Addresses

customers — stores customer details

addresses — supports multiple addresses per customer

🏷️ Categories & Products

categories — hierarchical product categories

products — catalog of store items

product_categories — many-to-many mapping between products and categories

🚚 Orders & Payments

orders — tracks each customer order

order_items — join table between orders and products

payments — logs all payment attempts and statuses

🏭 Suppliers & Inventory

suppliers — product suppliers

inventory — manages stock quantities

⭐ Reviews

reviews — customer feedback with ratings (1–5 stars)

⚙️ How to Run
1️⃣ Requirements

MySQL 8.0+

MySQL Workbench (or any SQL client)

2️⃣ Setup

Open MySQL Workbench

Create a new query tab

Copy and paste or open the file:

ecommerce_schema.sql


Run the entire script (Ctrl + Shift + Enter)

3️⃣ Verify Installation
USE ecommerce_store;
SHOW TABLES;

🧪 Optional: Load Sample Data

Uncomment the Sample Data section in the SQL file (remove /* ... */)
Then re-run the script to insert demo rows.

You can test using:

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;

📊 Example Queries
-- List products with current stock
SELECT p.name AS Product, i.quantity AS Stock
FROM products p
JOIN inventory i ON p.product_id = i.product_id;

-- Show all orders and customer names
SELECT o.order_id, c.first_name, o.total, o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Display product reviews
SELECT p.name AS Product, c.first_name AS Reviewer, r.rating, r.title
FROM reviews r
JOIN products p ON r.product_id = p.product_id
JOIN customers c ON r.customer_id = c.customer_id;

🧾 File Structure
Frameworks_Assignment/
│
├── ecommerce_schema.sql   # Full database schema
└── README.md              # Documentation

🧠 Learning Outcomes

By completing this project, you will:

Understand relational database design

Apply normalization principles (1NF–3NF)

Use SQL constraints and relationships effectively

Gain hands-on experience in schema implementation

🧑‍💻 Author

Bryton Wafula
Frameworks Assignment — Database Design & Normalization
