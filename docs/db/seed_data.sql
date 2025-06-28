--- Вставляем тестовые данные в таблицу suppliers (поставщики):
INSERT INTO suppliers (name, contact_info)
VALUES
	('Alpha Supplies', 'contact@alpha.com'),
	('Beta Distributors', 'info@beta.net'),
	('Gamma Corp', 'support@gamma.org'),
	('Delta Logistics', 'logistics@delta.com');


--- Вставляем тестовые данные в таблицу warehouses (склады):
INSERT INTO warehouses (name, location)
VALUES
	('Main Warehouse', 'Central City'),
	('East Warehouse', 'East Industrial Park');


--- Вставляем тестовые данные в таблицу products (товары):
-- (supplier_id (значения от 1 до 4) должен ссылаться на id из таблицы suppliers)
INSERT INTO products (sku, name, supplier_id, weight_kg) 
VALUES
	('SKU-1001', 'Widget A', 1, 0.5),
	('SKU-1002', 'Gadget B', 1, 1.2),
	('SKU-1003', 'Thing C', 2, 0.8),
	('SKU-1004', 'Doodad D', 3, 2.5),
	('SKU-1005', 'Gizmo E', 4, 0.3),
	('SKU-1006', 'Product F', 2, 1.5);


--- Вставляем тестовые данные в таблицу sales (продажи):
-- (product_id_s (значения от 1 до 6) должен ссылаться на id из таблицы products)
INSERT INTO sales (product_id_s, sale_date, quantity, price)
VALUES
	(1, NOW() - INTERVAL '15 days', 10, 15.50),
	(1, NOW() - INTERVAL '10 days', 5, 15.50),
	(2, NOW() - INTERVAL '20 days', 3, 25.00),
	(3, NOW() - INTERVAL '5 days', 8, 12.75),
	(4, NOW() - INTERVAL '2 days', 2, 50.00),
	(1, NOW() - INTERVAL '1 day', 20, 15.50),
	(5, NOW(), 1, 100.00);


--- Вставляем тестовые данные в промежуточную таблицу product_inventory (остатки на складах):
-- (комбинация product_id_pi и warehouse_id уникальная)
INSERT INTO product_inventory (product_id_pi, warehouse_id, quantity, last_updated)
VALUES
	(1, 1, 150, NOW() - INTERVAL '1 hour'),
	(1, 2, 80, NOW() - INTERVAL '2 hours'),
	(2, 1, 250, NOW() - INTERVAL '3 hours'),
	(3, 1, 300, NOW() - INTERVAL '4 hours'),
	(4, 2, 50, NOW() - INTERVAL '5 hours'),
	(5, 1, 10, NOW() - INTERVAL '1 day');