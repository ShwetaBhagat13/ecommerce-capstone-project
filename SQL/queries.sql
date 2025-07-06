use manifest_ecommerce;

-- Top 10 Best-Selling Products 
SELECT p.product_name,
    SUM(o.quantity) AS total_units_sold
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_units_sold DESC
LIMIT 10;

-- Revenue by Category
SELECT c.category_name,
    ROUND(SUM(p.price * o.quantity * (1 - o.discount / 100)), 2) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- Revenue by Region
SELECT cust.region,
    ROUND(SUM(p.price * o.quantity * (1 - o.discount / 100)), 2) AS total_revenue
FROM orders o
JOIN customers cust ON o.customer_id = cust.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY cust.region
ORDER BY total_revenue DESC;

-- Revenue by Gender
SELECT cust.gender,
    ROUND(SUM(p.price * o.quantity * (1 - o.discount / 100)), 2) AS total_revenue
FROM orders o
JOIN customers cust ON o.customer_id = cust.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY cust.gender;

-- Monthly Order Trends
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- Top Regions by Number of Orders
SELECT cust.region,
    COUNT(*) AS total_orders
FROM orders o
JOIN customers cust ON o.customer_id = cust.customer_id
GROUP BY cust.region
ORDER BY total_orders DESC;

-- Most Returned Categories
SELECT cat.category_name,
    COUNT(r.return_id) AS total_returns
FROM returns r
JOIN orders o ON r.order_id = o.order_id
JOIN products p ON o.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY total_returns DESC;

-- Return Rate by Category
SELECT cat.category_name,
    COUNT(r.return_id) AS total_returns,
    COUNT(o.order_id) AS total_orders,
    ROUND(COUNT(r.return_id) / COUNT(o.order_id) * 100, 2) AS return_rate_percent
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
JOIN orders o ON o.product_id = p.product_id
LEFT JOIN returns r ON r.order_id = o.order_id
GROUP BY cat.category_name
ORDER BY return_rate_percent DESC;

-- Total Discount Given by Category
SELECT c.category_name,
    ROUND(SUM((p.price * o.quantity) * (o.discount / 100)), 2) AS total_discount_value
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_discount_value DESC;

-- RFM — Customer Recency, Frequency, Monetary Value
SELECT c.customer_id,
    MAX(order_date) AS last_order_date,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(p.price * o.quantity * (1 - o.discount / 100)), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;