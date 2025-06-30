--- Добавим еще данных в таблицы для тестирования.

INSERT INTO suppliers (name, contact_info)
VALUES
	('Alpha', 'contact@alpha.ru'),
	('Beta', 'info@beta.ru'),
	('Gamma', 'support@gamma.ru'),
	('Delta', 'logistics@delta.ru');

INSERT INTO warehouses (name, location)
VALUES
	('Main', 'Central'),
	('East', 'Park');

INSERT INTO products (sku, name, supplier_id, weight_kg) 
VALUES
	('SKU-2001', 'Widget Z', 5, 0.5),
	('SKU-2002', 'Gadget X', 5, 1.2),
	('SKU-2003', 'Thing V', 6, 0.8),
	('SKU-2004', 'Doodad B', 7, 2.5),
	('SKU-2005', 'Gizmo N', 7, 0.3),
	('SKU-2006', 'Product M', 5, 1.5);

INSERT INTO sales (product_id_s, sale_date, quantity, price)
VALUES
	(7, NOW() - INTERVAL '45 days', 50, 15.50),
	(7, NOW() - INTERVAL '40 days', 25, 15.50),
	(8, NOW() - INTERVAL '50 days', 38, 25.00),
	(9, NOW() - INTERVAL '75 days', 80, 12.75),
	(10, NOW() - INTERVAL '62 days', 23, 50.00),
	(7, NOW() - INTERVAL '100 day', 69, 15.50),
	(11, NOW() - INTERVAL '150 day', 72, 100.00);

INSERT INTO product_inventory (product_id_pi, warehouse_id, quantity, last_updated)
VALUES
	(7, 3, 150, NOW() - INTERVAL '1 hour'),
	(7, 4, 80, NOW() - INTERVAL '2 hours'),
	(8, 3, 250, NOW() - INTERVAL '3 hours'),
	(9, 3, 20, NOW() - INTERVAL '4 hours'),
	(10, 4, 50, NOW() - INTERVAL '5 hours'),
	(11, 3, 10, NOW() - INTERVAL '1 day');