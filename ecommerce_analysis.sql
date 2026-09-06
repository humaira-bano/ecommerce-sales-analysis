USE ecommerce_analysis;
CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE
);CREATE TABLE order_items (
    order_item_id INT,
    order_id INT,
    product_id INT,
    quantity INT
);INSERT INTO customers (customer_id, customer_name, city)
VALUES
(1, 'Rahul Sharma', 'Delhi'),
(2, 'Priya Singh', 'Mumbai'),
(3, 'Aman Khan', 'Bangalore'),
(4, 'Sara Ali', 'Hyderabad'),
(5, 'Neha Gupta', 'Pune');INSERT INTO products (product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Headphones', 'Electronics', 2500.00),
(103, 'Running Shoes', 'Fashion', 3500.00),
(104, 'Backpack', 'Fashion', 1800.00),
(105, 'Smart Watch', 'Electronics', 4500.00);INSERT INTO orders (order_id, customer_id, order_date)
VALUES
(1001, 1, '2026-01-05'),
(1002, 2, '2026-01-08'),
(1003, 3, '2026-01-12'),
(1004, 1, '2026-01-15'),
(1005, 4, '2026-01-20'),
(1006, 5, '2026-01-25'),
(1007, 2, '2026-02-02'),
(1008, 3, '2026-02-10');INSERT INTO order_items (order_item_id, order_id, product_id, quantity)
VALUES
(1, 1001, 101, 1),
(2, 1001, 102, 2),
(3, 1002, 103, 1),
(4, 1003, 105, 1),
(5, 1004, 102, 1),
(6, 1005, 104, 2),
(7, 1006, 101, 1),
(8, 1007, 105, 1),
(9, 1008, 103, 2);SELECT COUNT(*) AS total_customers
FROM customers;SELECT COUNT(*) AS total_orders
FROM orders;SELECT
    SUM(p.price * oi.quantity) AS total_sales
FROM order_items AS oi
JOIN products AS p
ON oi.product_id = p.product_id;SELECT
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM order_items AS oi
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;SELECT
    p.category,
    SUM(p.price * oi.quantity) AS total_sales
FROM order_items AS oi
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;SELECT
    c.customer_name,
    SUM(p.price * oi.quantity) AS total_spent
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;SELECT
    MONTH(o.order_date) AS month,
    SUM(p.price * oi.quantity) AS total_sales
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY MONTH(o.order_date)
ORDER BY month;SELECT
    SUM(p.price * oi.quantity) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON oi.product_id = p.product_id;SELECT
    c.customer_name,
    SUM(p.price * oi.quantity) AS total_spent
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;SELECT
    p.product_name,
    SUM(p.price * oi.quantity) AS revenue
FROM products AS p
JOIN order_items AS oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;SELECT
    c.city,
    SUM(p.price * oi.quantity) AS total_sales
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY c.city
ORDER BY total_sales DESC;SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;SELECT
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM order_items AS oi
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 3;WITH customer_sales AS (
    SELECT
        c.customer_name,
        SUM(p.price * oi.quantity) AS total_spent
    FROM customers AS c
    JOIN orders AS o
    ON c.customer_id = o.customer_id
    JOIN order_items AS oi
    ON o.order_id = oi.order_id
    JOIN products AS p
    ON oi.product_id = p.product_id
    GROUP BY c.customer_name
)
SELECT
    customer_name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS customer_rank
FROM customer_sales;WITH customer_sales AS (
    SELECT
        c.customer_name,
        SUM(p.price * oi.quantity) AS total_spent
    FROM customers AS c
    JOIN orders AS o
    ON c.customer_id = o.customer_id
    JOIN order_items AS oi
    ON o.order_id = oi.order_id
    JOIN products AS p
    ON oi.product_id = p.product_id
    GROUP BY c.customer_name
)
SELECT
    customer_name,
    total_spent,
    CASE
        WHEN total_spent >= 50000 THEN 'High'
        WHEN total_spent >= 10000 THEN 'Medium'
        ELSE 'Low'
    END AS spending_category
FROM customer_sales;SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.price * oi.quantity) AS total_spent
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY c.customer_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_spent DESC;SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(p.price * oi.quantity) AS total_revenue
FROM products AS p
JOIN order_items AS oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;SELECT
    product_name,
    price
FROM products
ORDER BY price DESC
LIMIT 1;SELECT
    o.order_id,
    SUM(p.price * oi.quantity) AS order_value
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY o.order_id
ORDER BY order_value DESC;SELECT
    c.customer_name,
    COUNT(DISTINCT oi.product_id) AS different_products_bought
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY different_products_bought DESC;