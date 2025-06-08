CREATE DATABASE olist_ecommerce_db;
USE olist_ecommerce_db;

-- Table: olist_customers_dataset
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(50),
    customer_state VARCHAR(10)
);

-- Table: olist_geolocation_dataset
CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(10, 8),
    geolocation_lng DECIMAL(11, 8),
    geolocation_city VARCHAR(50),
    geolocation_state VARCHAR(10)
);

-- Table: olist_orders_dataset
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME NOT NULL, -- Always present in the dataset
    order_approved_at DATETIME,                -- Can be NULL
    order_delivered_carrier_date DATETIME,     -- Can be NULL
    order_delivered_customer_date DATETIME,    -- Can be NULL
    order_estimated_delivery_date DATETIME NOT NULL, -- Always present
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Table: olist_order_items_dataset
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,  -- Can be NULL
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Table: olist_products_dataset
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,          -- Can be NULL
    product_description_length INT,   -- Can be NULL
    product_photos_qty INT,           -- Can be NULL
    product_weight_g INT,             -- Can be NULL
    product_length_cm INT,            -- Can be NULL
    product_height_cm INT,            -- Can be NULL
    product_width_cm INT              -- Can be NULL
);

-- Table: product_category_name_translation
CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100),
    PRIMARY KEY (product_category_name)
);

-- Table: olist_sellers_dataset
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(50),
    seller_state VARCHAR(10)
);

-- Table: olist_order_payments_dataset
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Table: olist_order_reviews_dataset
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,               -- Can be NULL
    review_comment_title VARCHAR(100),  -- Can be NULL
    review_comment_message TEXT,    -- Can be NULL
    review_creation_date DATETIME,  -- Can be NULL
    review_answer_timestamp DATETIME, -- Can be NULL
    PRIMARY KEY (review_id, order_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, @order_purchase_timestamp, @order_approved_at, @order_delivered_carrier_date, @order_delivered_customer_date, @order_estimated_delivery_date)
SET 
    order_purchase_timestamp = STR_TO_DATE(NULLIF(@order_purchase_timestamp, ''), '%Y-%m-%d %H:%i:%s'),
    order_approved_at = STR_TO_DATE(NULLIF(@order_approved_at, ''), '%Y-%m-%d %H:%i:%s'),
    order_delivered_carrier_date = STR_TO_DATE(NULLIF(@order_delivered_carrier_date, ''), '%Y-%m-%d %H:%i:%s'),
    order_delivered_customer_date = STR_TO_DATE(NULLIF(@order_delivered_customer_date, ''), '%Y-%m-%d %H:%i:%s'),
    order_estimated_delivery_date = STR_TO_DATE(NULLIF(@order_estimated_delivery_date, ''), '%Y-%m-%d %H:%i:%s');
    
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_item_id, product_id, seller_id, @shipping_limit_date, price, freight_value)
SET 
    shipping_limit_date = STR_TO_DATE(NULLIF(@shipping_limit_date, ''), '%Y-%m-%d %H:%i:%s');
    
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset_cleaned1.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, order_id, @review_score, review_comment_title, review_comment_message, @review_creation_date, @review_answer_timestamp)
SET 
    review_score = NULLIF(@review_score, ''),
    review_creation_date = CASE 
        WHEN NULLIF(@review_creation_date, '') IS NULL THEN NULL
        WHEN @review_creation_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$' 
             AND STR_TO_DATE(@review_creation_date, '%Y-%m-%d %H:%i:%s') IS NOT NULL 
        THEN STR_TO_DATE(@review_creation_date, '%Y-%m-%d %H:%i:%s')
        ELSE NULL
    END,
    review_answer_timestamp = CASE 
        WHEN NULLIF(@review_answer_timestamp, '') IS NULL THEN NULL
        WHEN @review_answer_timestamp REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$' 
             AND STR_TO_DATE(@review_answer_timestamp, '%Y-%m-%d %H:%i:%s') IS NOT NULL 
        THEN STR_TO_DATE(@review_answer_timestamp, '%Y-%m-%d %H:%i:%s')
        ELSE NULL
    END;
    
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, payment_sequential, payment_type, @payment_installments, @payment_value)
SET 
    payment_installments = NULLIF(@payment_installments, ''),
    payment_value = NULLIF(@payment_value, '');
    
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_category_name, @product_name_length, @product_description_length, @product_photos_qty, @product_weight_g, @product_length_cm, @product_height_cm, @product_width_cm)
SET 
    product_name_length = NULLIF(@product_name_length, ''),
    product_description_length = NULLIF(@product_description_length, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
INTO TABLE product_category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_category_name, product_category_name_english);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(seller_id, seller_zip_code_prefix, seller_city, seller_state);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(geolocation_zip_code_prefix, @geolocation_lat, @geolocation_lng, geolocation_city, geolocation_state)
SET 
    geolocation_lat = NULLIF(@geolocation_lat, ''),
    geolocation_lng = NULLIF(@geolocation_lng, '');
    
SELECT COUNT(*) FROM customers;         
SELECT COUNT(*) FROM orders;             
SELECT COUNT(*) FROM order_items;        
SELECT COUNT(*) FROM order_payments;     
SELECT COUNT(*) FROM order_reviews;      
SELECT COUNT(*) FROM products;           
SELECT COUNT(*) FROM product_category_translation; 
SELECT COUNT(*) FROM sellers;            
SELECT COUNT(*) FROM geolocation;        