-- Consultar los 10 clientes con más pedidos
SELECT customer_name, COUNT(*) AS total_order
FROM supermart
GROUP BY customer_name
ORDER BY total_order DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Ver las ventas totales por categoría en la región Oeste durante 2017
SELECT category, SUM(sales) AS total_sales
FROM supermart
WHERE YEAR(order_date) = 2017
  AND region = 'West'
GROUP BY category
ORDER BY total_sales DESC;


--¿Cuál fue el promedio de ventas de bebidas durante el cuarto trimestre de 2018?
SELECT AVG(sales) AS beverages_sales_average
FROM supermart
WHERE YEAR(order_date) = 2018
  AND MONTH(order_date) >= 10
  AND category = 'Beverages';


--Consultar el promedio y total de ganancias de snacks por mes durante 2016
SELECT 
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	AVG(profit) AS profit_avg,
	SUM(profit) AS total_profit
FROM supermart
WHERE YEAR(order_date) = 2016
GROUP BY YEAR(order_date), MONTH(order_date);

--Ver qué ciudades nunca realizaron pedidos de Masalas en mayo de 2017
SELECT DISTINCT city
FROM supermart
WHERE city NOT IN (
	SELECT DISTINCT city
	FROM supermart
	WHERE sub_category = 'Masalas'
	  AND YEAR(order_date) = 2017
	  AND MONTH(order_date) = 5
);

--¿Cuál es el porcentaje de pedidos de Noodles en comparación con todos los de la categoría Snacks durante 2017?
DECLARE @total_category FLOAT;
DECLARE @total_sub_category FLOAT;
DECLARE @percentage FLOAT;

SELECT @total_category = COUNT(*)
FROM supermart
WHERE category = 'Snacks'
  AND YEAR(order_date) = 2017;

SELECT @total_sub_category = COUNT(*)
FROM supermart
WHERE sub_category = 'Noodles'
  AND YEAR(order_date) = 2017;

SET @percentage = (@total_sub_category * 1.0 / @total_category) * 100;

SELECT @percentage AS [Noodles order percentage 2017 (%)];

--¿Cuándo ocurrió el mayor descuento en la categoría Bakery durante 2015?
SELECT order_date, discount
FROM supermart
WHERE discount = (
	SELECT MAX(discount)
	FROM supermart
	WHERE YEAR(order_date) = 2015
	  AND category = 'Bakery'
)
AND YEAR(order_date) = 2015
AND category = 'Bakery'
ORDER BY order_date;


--¿Cuántas personas únicas realizaron más de dos pedidos en el mismo día durante 2018?
SELECT COUNT(DISTINCT customer_name) AS total_unique_customer
FROM (
	SELECT customer_name, order_date, COUNT(*) AS total_order_per_day
	FROM supermart
	WHERE YEAR(order_date) = 2018
	GROUP BY customer_name, order_date
	HAVING COUNT(*) > 2
) AS order_more_than_2;
