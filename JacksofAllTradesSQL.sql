-- This code selects the average discount of sales relating to each subcategory (slide 16)

SELECT 
	p.sub_category,
	AVG(i.discount) AS average_discount
FROM
	offuture.product AS p
INNER JOIN 
	offuture.order_item AS i
ON
	p.product_id = i.product_id
INNER JOIN offuture.order AS o
	ON i.order_id = o.order_id
GROUP BY 
	sub_category 
ORDER BY 
	AVG(discount) DESC;

-- This code selects the least profitable countries, showing their average discount (as well as profit measures) rounded to 2DP (slide 11)

SELECT 
	a.country,
	ROUND(AVG(i.discount), 2) AS average_discount,
	ROUND(SUM(i.profit),2) AS total_profit,
	ROUND(AVG(i.profit),2) AS average_profit
FROM
	offuture.product AS p
INNER JOIN offuture.order_item AS i
	ON p.product_id = i.product_id
INNER JOIN offuture.order AS o
	ON i.order_id = o.order_id
INNER JOIN offuture.address AS a
	ON a.address_id = o.address_id
GROUP BY 
	a.country
ORDER BY 
	total_profit ASC
LIMIT 
	5;

-- This code selects the 5 most profitable countries, showing their average discounts (as well as profit measures) rounded to 2 DP (slide 11)

SELECT 
	a.country,
	ROUND(AVG(i.discount), 2) AS average_discount,
	ROUND(SUM(i.profit),2) AS total_profit,
	ROUND(AVG(i.profit),2) AS average_profit
FROM 
	offuture.product AS p
INNER JOIN offuture.order_item AS i
	ON p.product_id = i.product_id
INNER JOIN offuture.order AS o
	ON i.order_id = o.order_id
INNER JOIN offuture.address AS a
	ON a.address_id = o.address_id
GROUP BY 
	a.country
ORDER BY 
	total_profit DESC
LIMIT 
	5;

-- Most profitable day of sales and total profit that day (slide 19)

SELECT
	o.order_date,
	SUM(i.profit) AS total_profit
FROM
	offuture.order_item AS i
INNER JOIN offuture.order AS o
	ON o.order_id = i.order_id
GROUP BY
	o.order_date
ORDER BY 
	SUM(i.profit) DESC
LIMIT 1;

-- Number of orders on the above day (slide 19)

SELECT
	o.order_date,
	COUNT(DISTINCT i.order_id)
FROM
	offuture.order_item AS i
INNER JOIN offuture.order AS o
	ON o.order_id = i.order_id
WHERE
	CAST(o.order_date AS VARCHAR) LIKE '%11-18'
GROUP BY
	o.order_date
ORDER BY 
	SUM(i.profit) DESC
LIMIT 1;

-- The most popular product purchased on Christmas Day and how many units were ordered (slide 20)

SELECT
	p.product_name,
	SUM(i.quantity) AS number_of_units_in_order
FROM 
	offuture.ORDER AS o
INNER JOIN offuture.order_item AS i
	ON o.order_id = i.order_id
INNER JOIN offuture.product AS p
	ON i.product_id = p.product_id
WHERE
	CAST(o.order_date AS VARCHAR) LIKE '%12-25'
GROUP BY
	p.product_name
ORDER BY
	SUM(i.quantity) DESC
LIMIT 1;

-- Customers who placed the most repeat orders (slide 21)

SELECT 
    c.customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM 
	offuture.ORDER AS o
LEFT JOIN offuture.customer AS c
	ON o.customer_id = c.customer_id_short
	OR o.customer_id = c.customer_id_long
GROUP BY 
	c.customer_name
HAVING 
	COUNT(DISTINCT order_id) > 1
ORDER BY 
	COUNT(DISTINCT order_id) DESC
LIMIT 3;

-- Single-purchase customers (slide 22)

SELECT 
    customer_id,
    COUNT(order_id) AS total_orders
FROM 
	offuture.order
GROUP BY 
	customer_id
HAVING 
	COUNT(order_id) = 1;

-- Number of orders using 85% discount and the subcategory of products within those (slide 23 and 24)

SELECT
	COUNT(DISTINCT i.order_id) AS orders_with_85_discount,
	p.sub_category
FROM 
	offuture.order_item AS i
INNER JOIN offuture.product AS p
	ON i.product_id = p.product_id
WHERE
	i.discount = '0.85'
GROUP BY
	p.sub_category;