-- ============================================================
-- CONSTRAINT 1: Each order must have at least one item
-- ============================================================
INSERT INTO Food_Order VALUES ('20251020123', '2025-10-20', '20:56:01', 'cash', NULL, NULL, '12'); 
INSERT INTO Prepare VALUES ('20251020123', 'Rendang', 'STAFF-01', '1');
INSERT INTO Prepare VALUES ('20251020123', 'Ayam Balado', 'STAFF-03', '2');

SELECT *
FROM Food_Order
WHERE id = '20251020123'
;
SELECT *
FROM Prepare
WHERE order_id = '20251020123'
ORDER BY item
;
-- Records will be deleted from Food_Order and Prepare tables due to ON DELETE CASCADE
DELETE FROM Food_Order
WHERE id = '20251020123'
; 
-- Deletion will fail due to trigger
DELETE FROM Prepare
WHERE order_id = '20251020123'
; 
-- Update will fail due to check constraint
UPDATE Prepare
SET qty = 0
WHERE order_id = '20251020123'
and item = 'Rendang'
and staff = 'STAFF-01'
; 
-- Deletion will be executed and total_price will be re-computed with trg_update_total_price trigger on Prepare
-- total_price is updated from 12 to 8
DELETE FROM Prepare
WHERE order_id = '20251020123'
and item = 'Rendang'
and staff = 'STAFF-01'
; 
SELECT *
FROM Food_Order
WHERE id = '20251020123'
;


-- ============================================================
-- CONSTRAINT 2: Staff must be qualified to cook the item’s cuisine
-- ============================================================
-- Test 1 - Works
INSERT INTO Food_Order VALUES ('20251108456', '2025-11-08', '12:30:01', 'cash', NULL, NULL, '7.0'); 
INSERT INTO Prepare VALUES ('20251108456', 'Rinderrouladen', 'STAFF-01', '2');

select *
from Prepare
where order_id = '20251108456'
;
select *
from Food_Order
where id = '20251108456'
;

DELETE FROM cook
WHERE staff = 'STAFF-01'
AND cuisine = 'German'
; -- Cuisine should not be able to be deleted from cook
UPDATE cook
SET cuisine = 'Chinese'
WHERE staff = 'STAFF-01'
AND cuisine = 'German'
; -- Cuisine should not be able to be updated which removes German

UPDATE item
SET cuisine = 'Chinese'
WHERE name = 'Rinderrouladen'
; -- Cuisine of each item should not be able to be updated

-- Test 2 - Don't work (STAFF-03 doesn't know German cuisine)
INSERT INTO Food_Order VALUES ('20251108789', '2025-11-08', '13:30:01', 'cash', NULL, NULL, '7.0'); 
INSERT INTO Prepare VALUES ('20251108789', 'Rinderrouladen', 'STAFF-03', '2');


-- ============================================================
-- CONSTRAINT 3: Order datetime >= Member registration
-- ============================================================
-- TEST 3.1: Order before member registration (SHOULD FAIL)
BEGIN; -- Start a transaction
-- Create an order on Jan 1st, 2024 (BEFORE the Jan 3rd registration)
INSERT INTO Food_Order VALUES ('20240101001', '2024-01-01', '10:00:00', 'cash', NULL, NULL, 0);
-- Link it to member '93627414'
INSERT INTO Ordered_By (order_id, member) VALUES ('20240101001', '93627414');
-- Try to commit the transaction
COMMIT;
-- Error Message: ERROR:  Invalid order - Order on 2024-01-01 10:00:00 is before member registration on 2024-03-01 12:19:23
-- CONTEXT:  PL/pgSQL function order_member() line 17 at RAISE SQL state: P0001


-- TEST 3.2: Order after member registration (SHOULD SUCCEED)
BEGIN;
-- This order is on the SAME DAY (1 Mar) as registration,
-- but at a LATER TIME (14:00:00) than registration (12:19:23)
INSERT INTO Food_Order VALUES ('20240103002', '2024-03-01', '14:00:00', 'card', '2222-3333-4444-5555', 'mastercard', 0);
-- Link the order to member '93627414'
INSERT INTO Ordered_By (order_id, member) VALUES ('20240103002', '93627414');
-- Add an item to the order
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240103002', 'Bun Cha', 'STAFF-03', 1);
-- This COMMIT will execute the deferred trigger and should SUCCEED.
COMMIT;


-- TEST 3.3: Order on same day but earlier time (SHOULD FAIL)
BEGIN;
-- This order is on the SAME DAY (1 Mar) as registration,
-- but at an EARLIER TIME (10:00:00) than registration (12:19:23)
INSERT INTO Food_Order VALUES ('20240103001', '2024-03-01', '10:00:00', 'card', '1111-2222-3333-4444', 'visa', 0);
-- Link the order to member '93627414'
INSERT INTO Ordered_By (order_id, member) VALUES ('20240103001', '93627414');
-- Add an item to the order
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240103001', 'Rendang', 'STAFF-01', 1);
-- This COMMIT will execute the deferred trigger and should FAIL.
COMMIT;
-- Error Message: ERROR:  Invalid order - Order on 2024-03-01 10:00:00 is before member registration on 2024-03-01 12:19:23
-- CONTEXT:  PL/pgSQL function order_member() line 17 at RAISE SQL state: P0001


-- ============================================================
-- CONSTRAINT 4: total_price must equal sum(items) - discount
-- ============================================================
-- Test using '93627414' as example member

-- Test 1 - Member with >=4 items → Should get $2 discount
-- Insert order by a member with qty >= 4 with correct price
-- Can input 0 as total_price because this will be auto re-computed by the trg_update_total_price trigger
-- Correct total_price of 17 is computed (2x3.5 + 3x4 - 2 = 17)
INSERT INTO Food_Order VALUES ('20251111123', '2025-11-11', '19:36:21', 'cash', NULL, NULL, 0); 
INSERT INTO Prepare VALUES ('20251111123', 'Rinderrouladen', 'STAFF-01', '2'); 
INSERT INTO Prepare VALUES ('20251111123', 'Ayam Balado', 'STAFF-01', '3'); 
INSERT INTO Ordered_By VALUES ('20251111123', '93627414');

SELECT *
FROM food_order
where id = '20251111123'
;
SELECT *
FROM Prepare
where order_id = '20251111123'
;

-- Test 2a - Member with < 4 items → No discount
-- UPDATE will fire the trg_update_total_price trigger on Prepare to re-compute the total_price (now without discount since qty = 3)
-- Correct total_price of 11 is computed (2x3.5 + 4 = 11)
UPDATE Prepare
SET qty = 1
WHERE order_id = '20251111123'
AND item = 'Ayam Balado'
AND staff = 'STAFF-01'
;
SELECT *
FROM food_order
where id = '20251111123'
;

-- Test 2b - Member with < 4 items → No discount
-- DELETE will fire the trg_update_total_price trigger on Prepare to re-compute the total_price 
-- Correct total_price of 7 is computed (2x3.5 = 7)
DELETE FROM Prepare
WHERE order_id = '20251111123'
AND item = 'Ayam Balado'
AND staff = 'STAFF-01'
;
SELECT *
FROM food_order
where id = '20251111123'
;

-- TEST 3: Non-member with 4 items → No discount
-- Price: 4*4 = 16 (no discount)
-- Correct total_price of 12 is computed (4x3 = 12)
INSERT INTO Food_Order VALUES ('20240320009', '2024-03-01', '13:46:33', 'card', '3466-5960-1418-4580', 'americanexpress', 0);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320009', 'Bun Cha', 'STAFF-03', 4);

SELECT *
FROM food_order
where id = '20240320009'
;
