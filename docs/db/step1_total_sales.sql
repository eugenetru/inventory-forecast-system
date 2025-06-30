-- Шаг 1: Рассчитаем общее кол-во продаж каждого продукта за всё время по всем имеющимся датам:
    
SELECT
        product_id_s,
        DATE(sale_date) AS sale_day,
        SUM(quantity) AS daily_quantity
    FROM sales
    GROUP BY product_id_s, sale_day