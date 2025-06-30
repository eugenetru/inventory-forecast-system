-- Шаг 3: Прогнозные метрики.
-- 1. Возьмём предыдущие вычисления, подставим вместо NULL значения - 0.
-- 2. Посчитаем общее кол-во каждого продукта на всех складах.
-- 3. Вернём данные по каждому продукту с прогнозными метриками:
	-- 1)На сколько дней хватит текущего остатка товара,
	-- 2)Прогнозируемая дата исчерпания запасов
	-- 3)При каком остатке необходимо совершить новый заказ - Точка заказа,
	-- 4)Рекомендуемый объём запаса на 90 дней
-- 4. Используем LEFT JOIN, чтобы учесть все товары - с продажами и без.

-- Прогнозные метрики.
	-- 1. Возьмём предыдущие вычисления, подставим вместо NULL значения - 0.
WITH
	daily_sales AS (
    SELECT
        product_id_s,
        DATE(sale_date) AS sale_day,
        SUM(quantity) AS daily_quantity
    FROM sales
    GROUP BY product_id_s, sale_day
),
sales_velocity AS (
    SELECT
        p.id AS product_id,
        COALESCE(SUM(ds.daily_quantity) FILTER (WHERE ds.sale_day >= CURRENT_DATE - INTERVAL '30 days') / 30.0, 0) AS sales_velocity_30d,
        COALESCE(SUM(ds.daily_quantity) FILTER (WHERE ds.sale_day >= CURRENT_DATE - INTERVAL '60 days') / 60.0, 0) AS sales_velocity_60d,
        COALESCE(SUM(ds.daily_quantity) FILTER (WHERE ds.sale_day >= CURRENT_DATE - INTERVAL '90 days') / 90.0, 0) AS sales_velocity_90d
    FROM products AS p
    LEFT JOIN daily_sales AS ds ON id = ds.product_id_s
    GROUP BY id
),

	-- 2. Посчитаем общее кол-во каждого продукта на всех складах.
inventory_summary AS (
    SELECT
        product_id_pi AS product_id,
        SUM(quantity) AS total_inventory_quantity
    FROM product_inventory
    GROUP BY product_id_pi
)

	-- 3. Вернём данные по каждому продукту с прогнозными метриками:
	--- (за основу берем данные по продажам за последние 30 дней)
SELECT
    p.id AS product_id,
    p.sku,
    p.name AS product_name,
    COALESCE(inv.total_inventory_quantity, 0) AS current_inventory,
    sv.sales_velocity_30d,
	
    	-- 1) На сколько дней хватит текущего остатка товара.
    	--- NULL, если скорость продаж равна 0 (запасы "бесконечны")
    CASE
        WHEN sv.sales_velocity_30d > 0
        THEN ROUND(COALESCE(inv.total_inventory_quantity, 0) / sv.sales_velocity_30d, 2)
        ELSE null
    END AS days_of_supply,
	
    	-- 2) Прогнозируемая дата исчерпания запасов.
    	--- NULL, если скорость продаж 0 или нет текущих запасов.
		---- (остаток/среднееВдень), умножаем на интервал 1 день, чтобы потом прибавить кол-во дней к текущей дате.
    CASE
        WHEN sv.sales_velocity_30d > 0 AND COALESCE(inv.total_inventory_quantity, 0) > 0
        THEN (CURRENT_DATE + (COALESCE(inv.total_inventory_quantity, 0) / sv.sales_velocity_30d) * INTERVAL '1 day')::DATE
        ELSE NULL
    END AS estimated_out_of_stock_date,
	
    	-- 3) Точка заказа: при каком остатке необходимо совершить новый заказ (45-дневный запас).
    	--- CEIL для округления в большую сторону до целого числа товаров.
    CEIL(sv.sales_velocity_30d * 45) AS reorder_point,
	
    	-- 4) Рекомендуемый объём заказа на 90 дней, если текущий остаток ниже точки заказа.
    CASE
        WHEN COALESCE(inv.total_inventory_quantity, 0) < CEIL(sv.sales_velocity_30d * 45)
        THEN CEIL(sv.sales_velocity_30d * 90)
        ELSE 0
    END AS recommended_order_quantity

	-- 4. Используем LEFT JOIN, чтобы учесть все товары - с продажами и без.
FROM products AS p
LEFT JOIN sales_velocity AS sv ON id = sv.product_id
LEFT JOIN inventory_summary AS inv ON id = inv.product_id
ORDER BY id;