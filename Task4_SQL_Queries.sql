-- Query 1: Top Product Categories by Sales
SELECT 
    pct.product_category_name_english,
    SUM(oi.price) AS total_sales
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN product_category_translation pct ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY pct.product_category_name_english
ORDER BY total_sales DESC
LIMIT 5;

-- Query 2: Average Review Score by Seller State
SELECT 
    s.seller_state,
    AVG(r.review_score) AS avg_review_score
FROM sellers s
RIGHT JOIN order_items oi ON s.seller_id = oi.seller_id
LEFT JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY s.seller_state
ORDER BY avg_review_score DESC
LIMIT 5;

-- Query 3: Top Customers by Number of Orders
SELECT 
    c.customer_unique_id,
    c.customer_city,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_city
ORDER BY order_count DESC
LIMIT 5;

-- Query 4: Monthly Revenue Trend
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    SUM(op.payment_value) AS monthly_revenue
FROM orders o
INNER JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;

-- Query 5: Create View for High-Value Customers
CREATE OR REPLACE VIEW high_value_customers AS
SELECT 
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    SUM(op.payment_value) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_city, c.customer_state
HAVING total_spent > 1000;

SELECT * FROM high_value_customers LIMIT 5;

-- Query 6: Optimize Query with Indexes
-- Drop the indexes if they exist
DROP INDEX idx_order_purchase_timestamp ON orders;
DROP INDEX idx_order_id ON order_payments;

-- Create the indexes
CREATE INDEX idx_order_purchase_timestamp ON orders(order_purchase_timestamp);
CREATE INDEX idx_order_id ON order_payments(order_id);

-- Run the optimized query
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    SUM(op.payment_value) AS monthly_revenue
FROM orders o
INNER JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;