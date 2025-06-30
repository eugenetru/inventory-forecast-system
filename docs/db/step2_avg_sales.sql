-- Шаг 2: Получим средние продажи в день за последние 30/60/90 дней, для этого:
	-- Используем WITH и заключим в него первый запрос,
	-- Высчитаем средние продажи за 30/60/90 дней,
	-- Для этого выведем кол-во продаж и отфильтруем по кол-ву последних дней, после чего поделим на то же кол-во дней.
	-- Используем LEFT JOIN, чтобы учесть все товары - с продажами и без


WITH 
	daily_sales AS (
SELECT
        product_id_s,
        DATE(sale_date) AS sale_day,
        SUM(quantity) AS daily_quantity
    FROM sales
    GROUP BY product_id_s, sale_day
)
SELECT
    p.id AS product_id,
    p.sku,
    p.name,
    SUM(ds.daily_quantity) FILTER (WHERE ds.sale_day >= CURRENT_DATE - INTERVAL '30 days') / 30.0 AS sales_velocity_30d,
    SUM(ds.daily_quantity) FILTER (WHERE ds.sale_day >= CURRENT_DATE - INTERVAL '60 days') / 60.0 AS sales_velocity_60d,
    SUM(ds.daily_quantity) FILTER (WHERE ds.sale_day >= CURRENT_DATE - INTERVAL '90 days') / 90.0 AS sales_velocity_90d
FROM products AS p
LEFT JOIN daily_sales AS ds ON id = ds.product_id_s
GROUP BY id
ORDER BY id