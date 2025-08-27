-- Validate Imported Tables

-- Check the record counts of tables
SELECT COUNT(*) FROM olist_orders_dataset;
SELECT COUNT(*) FROM olist_order_items_dataset;
SELECT COUNT(*) FROM olist_products_dataset;
SELECT COUNT(*) FROM olist_customers_dataset;

-- Examine the first few rows of the tables
SELECT * FROM olist_orders_dataset LIMIT 5;
SELECT * FROM olist_order_items_dataset LIMIT 5;
SELECT * FROM olist_products_dataset LIMIT 5;
SELECT * FROM olist_customers_dataset LIMIT 5;


-- Question 1: Calculate Olist’s total monthly income.

SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS revenue_month,  
    SUM(oi.price + oi.freight_value) AS monthly_revenue                            
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY revenue_month
ORDER BY revenue_month;


-- Question 2: Find the top 10 best-selling product categories.

SELECT 
    p.product_category_name,  
    COUNT(oi.order_item_id) AS total_orders,  
    SUM(oi.price * oi.order_item_id) AS total_revenue  

FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o 
    ON oi.order_id = o.order_id
JOIN olist_products_dataset p 
    ON oi.product_id = p.product_id

WHERE o.order_status = 'delivered'  

GROUP BY p.product_category_name
ORDER BY total_orders DESC
LIMIT 10;


-- Question 3: Segment customers by spend

SELECT
    c.customer_unique_id,
    c.customer_state,
    SUM(oi.price + oi.freight_value) AS total_spent,
    CASE 
        WHEN SUM(oi.price + oi.freight_value) > 1000 THEN 'Premium'
        WHEN SUM(oi.price + oi.freight_value) BETWEEN 500 AND 1000 THEN 'Regular'
        ELSE 'Low'
    END AS customer_segment
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state
ORDER BY total_spent DESC;


-- Question 4: Calculate the average order value (AOV) for each product category.

SELECT 
    p.product_category_name,
    ROUND(AVG((oi.price + oi.freight_value)::numeric), 2) AS avg_order_value
FROM 
    olist_order_items_dataset oi
JOIN 
    olist_orders_dataset o ON o.order_id = oi.order_id
JOIN 
    olist_products_dataset p ON p.product_id = oi.product_id
WHERE 
    o.order_status = 'delivered'
GROUP BY 
    p.product_category_name
ORDER BY 
    avg_order_value DESC;


-- Question 5: Calculate the number of repeat customers and their contribution (%) to total sales.
   
   WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS num_orders,
        SUM(oi.price + oi.freight_value) AS total_spent
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

repeat_customers AS (
    SELECT * FROM customer_orders
    WHERE num_orders >= 2
)

SELECT
    (SELECT COUNT(*) FROM repeat_customers) AS repeat_customer_count,
    (SELECT COUNT(*) FROM customer_orders) AS total_customer_count,
    ROUND(
        (100.0 * SUM(rc.total_spent)::numeric / NULLIF(SUM(co.total_spent), 0)::numeric), 
        2
    ) AS repeat_revenue_percentage
FROM repeat_customers rc
CROSS JOIN customer_orders co;

-- Question 6 – Top 10 highest-income states

SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS num_customers,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS total_revenue
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;


-- Question 7 – Average Delivery Time by Category (Days)

SELECT
    p.product_category_name,
    ROUND(
        AVG(
            DATE_PART(
                'day',
                (o.order_delivered_customer_date::timestamp - o.order_purchase_timestamp::timestamp)
            )
        )::numeric, 2
    ) AS avg_delivery_days
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
  AND o.order_delivered_customer_date != ''
  AND o.order_purchase_timestamp != ''
GROUP BY p.product_category_name
ORDER BY avg_delivery_days DESC;


-- Question 8 – Product category with the highest return rate

SELECT 
    p.product_category_name,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN o.order_status IN ('canceled', 'unavailable') THEN 1 END) AS returned_orders,
    ROUND(
        100.0 * COUNT(CASE WHEN o.order_status IN ('canceled', 'unavailable') THEN 1 END) / COUNT(*), 
        2
    ) AS return_rate_percent
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY return_rate_percent DESC
LIMIT 10;


-- Question 9 – Top 10 sellers and their categories

SELECT
    oi.seller_id,
    p.product_category_name,
    ROUND(CAST(SUM(oi.price + oi.freight_value) AS numeric), 2) AS total_sales
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id, p.product_category_name
ORDER BY total_sales DESC
LIMIT 10;


-- Question 10 – Comparing the number of orders and revenues on weekdays and weekends

SELECT
    CASE 
        WHEN EXTRACT(DOW FROM CAST(o.order_purchase_timestamp AS timestamp)) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(CAST(SUM(oi.price + oi.freight_value) AS NUMERIC), 2) AS total_revenue

FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered'

GROUP BY day_type
ORDER BY day_type;


-- Extra
-- Question 11. Analyze delivery time satisfaction: Which states have the highest rate of late orders?

SELECT 
    c.customer_state,
    COUNT(*) FILTER (
        WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
    ) * 100.0 / COUNT(*) AS late_delivery_rate
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY late_delivery_rate DESC;

-- Question 12 – Product Categories with High Cancellation Rates (Risky Categories)

SELECT
    p.product_category_name,
    COUNT(*) FILTER (WHERE o.order_status = 'canceled') * 100.0 / COUNT(*) AS cancel_rate
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING COUNT(*) >= 50  -- örneklem yeterliliği için
ORDER BY cancel_rate DESC
LIMIT 10;

-- Question 13 – Slowest Delivering Vendors (SLA Performance)

SELECT
    oi.seller_id,
    ROUND(AVG(
        DATE_PART(
            'day',
            o.order_delivered_customer_date::timestamp - o.order_purchase_timestamp::timestamp
        )
    )::numeric, 2) AS avg_delivery_days
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
  AND o.order_delivered_customer_date <> ''
  AND o.order_purchase_timestamp <> ''
GROUP BY oi.seller_id
ORDER BY avg_delivery_days DESC
LIMIT 10;

--  Question 14 – Average Product Evaluation Scores (Customer Perception)

SELECT
    p.product_category_name,
    ROUND(AVG(r.review_score)::numeric, 2) AS avg_review_score,
    COUNT(*) AS total_reviews
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_order_reviews_dataset r ON oi.order_id = r.order_id
GROUP BY p.product_category_name
HAVING COUNT(*) >= 30
ORDER BY avg_review_score DESC;

--  Question 15 – Relationship Between Delivery Time and Satisfaction (Causal Analysis)

SELECT
  CASE
    WHEN DATE_PART('day', o.order_delivered_customer_date::timestamp - o.order_purchase_timestamp::timestamp) <= 2 THEN '0-2 days'
    WHEN DATE_PART('day', o.order_delivered_customer_date::timestamp - o.order_purchase_timestamp::timestamp) <= 5 THEN '3-5 days'
    ELSE '6+ days'
  END AS delivery_time_group,
  ROUND(AVG(r.review_score)::numeric, 2) AS avg_review_score,
  COUNT(*) AS review_count
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
  AND o.order_delivered_customer_date <> ''
  AND o.order_purchase_timestamp <> ''
GROUP BY delivery_time_group
ORDER BY delivery_time_group;












