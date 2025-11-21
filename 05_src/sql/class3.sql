/* MODULE 3 */
/* COUNT */


/* 1. Count the number of products */
 

 
/* 2. How many products per product_qty_type */



/* 3. How many products per product_qty_type and per their product_size */

-- 

/* COUNT DISTINCT 
    4. How many unique products were bought */



   /* Replace all the IDs (customer, vendor, and product) with the names instead*/ 
SELECT DISTINCT 
--vendor_id, 
vendor_name,
--product_id, 
product_name,
--customer_id
customer_first_name,
customer_last_name

FROM customer_purchases as cp
INNER JOIN vendor as v
	ON v.vendor_id = cp.vendor_id
INNER JOIN product as p
	ON p.product_id = cp.product_id
INNER JOIN customer as c
	ON c.customer_id = cp.customer_id;



/* 2. Select product_category_name, everything from the product table, and then LEFT JOIN the customer_purchases table
... how does this LEFT JOIN affect the number of rows? 

Why do we have more rows now?*/
SELECT 
product_category_name
,p.*
,cp.product_id as [cp.product_id]

FROM product_category as pc
INNER JOIN product as p
	ON p.product_category_id = pc.product_category_id
LEFT JOIN customer_purchases as cp -- inner join is 4221, but left join adds 15 rows (4236 rows) for unsold products
	ON cp.product_id = p.product_id
	
ORDER BY cp.product_id


/* MODULE 3 */
/* COUNT */


/* 1. Count the number of products */
 SELECT COUNT(product_id) as num_of_prods
 FROM product;

 
/* 2. How many products per/by product_qty_type */
SELECT product_qty_type
,COUNT(product_id) as num_of_prods
FROM product
GROUP BY product_qty_type;


/* 3. How many products per product_qty_type and per their product_size */
SELECT product_size
,product_qty_type
,COUNT(product_id) as num_of_prods

FROM product
GROUP BY product_size, product_qty_type;


/* COUNT DISTINCT 
    4. How many unique products were bought */
    
 SELECT count(DISTINCT product_id) as bought_products
 FROM customer_purchases;
 
 

/* MODULE 3 */
/* SUM & AVG */


/* 1. How much did customers spend each day */
SELECT
market_date
,customer_id
,SUM(quantity*cost_to_customer_per_qty) as total_cost

FROM customer_purchases
GROUP BY market_date, customer_id;
 

/* 2. How much does each customer spend on average */
SELECT 
customer_first_name
,customer_last_name
,ROUND(AVG(quantity*cost_to_customer_per_qty),2) as total_cost

FROM customer_purchases as cp
INNER JOIN customer as c
	ON c.customer_id = cp.customer_id

GROUP BY c.customer_id -- this represents the single row that customer_first and customer_last_name are using



*/--------------------------------------------------------
*/---Write SQL/

*/---SELECT
*/--- 1Write a query that returns everything in the customer table.
SELECT *
FROM customer;


*/--- 2Write a query that displays all of the columns and 10 rows from the customer table, sorted by customer_last_name, then customer_first_ name.

SELECT *
FROM customer
ORDER BY customer_last_name, customer_first_name
LIMIT 10;



*/--WHERE
*/--1.Write a query that returns all customer purchases of product IDs 4 and 9.

SELECT *
FROM customer_purchases
WHERE product_id IN (4, 9);


*/--2. Write a query that returns all customer purchases and a new calculated column 'price' (quantity * cost_to_customer_per_qty), filtered by customer IDs between 8 and 10 (inclusive) using either:
*/--two conditions using AND
SELECT *,
       (quantity * cost_to_customer_per_qty) AS price
FROM customer_purchases
WHERE customer_id >= 8
  AND customer_id <= 10;


*/--one condition using BETWEEN

SELECT *,
       (quantity * cost_to_customer_per_qty) AS price
FROM customer_purchases
WHERE customer_id BETWEEN 8 AND 10;

-
*/--CASE
*/--1. Products can be sold by the individual unit or by bulk measures like lbs. or oz. Using the product table, write a query that outputs the product_id and product_name columns and add a column called prod_qty_type_condensed that displays the word “unit” if the product_qty_type is “unit,” and otherwise displays the word “bulk.”

SELECT
    product_id,
    product_name,
    CASE
        WHEN product_qty_type = 'unit' THEN 'unit'
        ELSE 'bulk'
    END AS prod_qty_type_condensed
FROM product;


*/---2. We want to flag all of the different types of pepper products that are sold at the market. Add a column to the previous query called pepper_flag that outputs a 1 if the product_name contains the word “pepper” (regardless of capitalization), and otherwise outputs 0.

SELECT
    product_id,
    product_name,
    CASE
        WHEN product_qty_type = 'unit' THEN 'unit'
        ELSE 'bulk'
    END AS prod_qty_type_condensed,
    CASE
        WHEN LOWER(product_name) LIKE '%pepper%' THEN 1
        ELSE 0
    END AS pepper_flag
FROM product;



*/---JOIN
/--1 Write a query that INNER JOINs the vendor table to the vendor_booth_assignments table on the vendor_id field they both have in common, and sorts the result by vendor_name, then market_date;
/* wrong
SELECT
    vendor.vendor_id,
    vendor.vendor_name,
    vendor_booth_assignments.market_date,
    vendor_booth_assignments.booth_id
FROM vendor
INNER JOIN vendor_booth_assignments
    ON vendor.vendor_id = vendor_booth_assignments.vendor_id
ORDER BY
    vendor.vendor_name,
    vendor_booth_assignments.market_date;

*/-----Section 3:
*/--AGGREGATE
*/--1 Write a query that determines how many times each vendor has rented a booth at the farmer’s market by counting the vendor booth assignments per vendor_id.
SELECT
    vendor_id,
    COUNT(*) AS booth_rental_count
FROM vendor_booth_assignments
GROUP BY vendor_id;

*/--2The Farmer’s Market Customer Appreciation Committee wants to give a bumper sticker to everyone who has ever spent more than $2000 at the market. Write a query that generates a list of customers for them to give stickers to, sorted by last name, then first name.
*/--HINT: This query requires you to join two tables, use an aggregate function, and use the HAVING keyword.
SELECT
    c.customer_id,
    c.customer_first_name,
    c.customer_last_name,
    SUM(cp.quantity * cp.cost_to_customer_per_qty) AS total_spent
FROM customer AS c
INNER JOIN customer_purchases AS cp
    ON c.customer_id = cp.customer_id
GROUP BY
    c.customer_id,
    c.customer_first_name,
    c.customer_last_name
HAVING
    SUM(cp.quantity * cp.cost_to_customer_per_qty) > 2000
ORDER BY
    c.customer_last_name,
    c.customer_first_name;
	
	
*/--Temp Table
*/--1Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal
*/--HINT: This is two total queries -- first create the table from the original, then insert the new 10th vendor. When inserting the new vendor, you need to appropriately align the columns to be inserted (there are five columns to be inserted, I've given you the details, but not the syntax)

*/--To insert the new row use VALUES, specifying the value you want for each column:
*/--VALUES(col1,col2,col3,col4,col5)
*/ worng
SELECT *
   INTO temp.new_vendor
FROM vendor;
vendor_id,
vendor_name,
vendor_type,
owner_name,
vendor_description
INSERT INTO temp.new_vendor
VALUES
(10, 'Thomass Superfood Store', 'Fresh Focused', 'Thomas Rosenthal', 'Thom Rosenhal'); 


*/--Date
*/--Get the customer_id, month, and year (in separate columns) of every purchase in the customer_purchases table.
*/--HINT: you might need to search for strfrtime modifers sqlite on the web to know what the modifers for month and year are!

SELECT
    customer_id,
    strftime('%m', purchase_date) AS purchase_month,
    strftime('%Y', purchase_date) AS purchase_year
FROM customer_purchases;





*/----
SELECT
    customer_id,
    SUM(quantity * cost_to_customer_per_qty) AS total_spent
FROM customer_purchases
WHERE strftime('%Y', purchase_date) = '2022'
  AND strftime('%m', purchase_date) = '04'
GROUP BY customer_id;



