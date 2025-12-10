USE adventureworks;

SELECT * FROM adventureworks.fact_sales_orders_vw;

SELECT COUNT(*) AS NumRows
FROM adventureworks.fact_sales_orders_vw;

SELECT * FROM (
	SELECT * , ROW_NUMBER() OVER (ORDER BY SalesOrderID) AS order_key
    FROM adventureworks.fact_sales_orders_vw
) AS SalesOrders
WHERE order_key <= 40439;

SELECT 40439 * 2;

SELECT * FROM (
	SELECT * , ROW_NUMBER() OVER (ORDER BY SalesOrderID) AS order_key
    FROM adventureworks.fact_sales_orders_vw
) AS SalesOrders
WHERE order_key BETWEEN 40440 AND 80878;

SELECT * FROM (
	SELECT * , ROW_NUMBER() OVER (ORDER BY SalesOrderID) AS order_key
    FROM adventureworks.fact_sales_orders_vw
) AS SalesOrders
WHERE order_key >= 80879;