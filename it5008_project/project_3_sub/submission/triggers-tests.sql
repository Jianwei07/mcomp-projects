-- ============================================
-- SETUP: Test Data
-- ============================================

-- Cuisines
INSERT INTO Cuisine (name) VALUES ('Vietnamese'), ('Thai'), ('Western');

-- Items
INSERT INTO Item (name, price, cuisine) VALUES
('Bun Cha', 4.00, 'Vietnamese'),
('Pho', 5.00, 'Vietnamese'),
('Pad Thai', 6.00, 'Thai'),
('Spring Roll', 3.00, 'Vietnamese'),
('Fried Rice', 4.00, 'Thai');

-- Staff
INSERT INTO Staff (id, name) VALUES
('STAFF-01', 'John Nguyen'),
('STAFF-02', 'Mary Chen'),
('STAFF-03', 'David Wong');

-- Cook assignments
INSERT INTO Cook (staff, cuisine) VALUES
('STAFF-01', 'Vietnamese'),
('STAFF-01', 'Thai'),
('STAFF-02', 'Vietnamese'),
('STAFF-03', 'Western');

-- Members
INSERT INTO Member (phone, firstname, lastname, reg_date, reg_time) VALUES
(91234567, 'Alice', 'Tan', '2024-02-15', '09:00:00'),
(98765432, 'Bob', 'Lee', '2024-03-01', '10:00:00'),
(87654321, 'Carol', 'Ng', '2024-03-01', '14:00:00');

-- ============================================
-- CONSTRAINT 1: Order must have at least one item
-- ============================================
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

-- 1. Deletion will fail due to trigger
DELETE FROM Prepare
WHERE order_id = '20251020123'
; 
-- 2. Update will fail due to check constraint
UPDATE Prepare
SET qty = 0
WHERE order_id = '20251020123'
and item = 'Rendang'
and staff = 'STAFF-01'
; 
-- 3. Deletion will be executed and total_price will be re-computed with trg_update_total_price trigger on Prepare
-- total_price is updated from 12 to 8
DELETE FROM Prepare
WHERE order_id = '20251020123'
and item = 'Rendang'
and staff = 'STAFF-01'
; 
-- 4. Records will be deleted from Food_Order and Prepare tables due to ON DELETE CASCADE
DELETE FROM Food_Order
WHERE id = '20251020123'
; 


-- ============================================
-- CONSTRAINT 2: Staff must be qualified to cook the item's cuisine
-- ============================================

-- 1. Valid insert (should pass)
INSERT INTO Prepare VALUES ('20240520001', 'Rendang', 'STAFF-01', 1);
SELECT * FROM Prepare WHERE order_id='20240520001';

-- 2. Invalid insert (should fail: STAFF-02 not qualified for Indonesian)
INSERT INTO Prepare VALUES ('20240520002', 'Rendang', 'STAFF-02', 1);

-- 3. Valid update to another qualified staff (STAFF-03)
UPDATE Prepare SET staff='STAFF-03'
WHERE order_id='20240520001' AND item='Rendang';
SELECT * FROM Prepare WHERE order_id='20240520001';

-- 4. Valid delete from Cook (not preparing that cuisine)
DELETE FROM Cook WHERE staff='STAFF-12' AND cuisine='German';
SELECT * FROM Cook WHERE staff='STAFF-12' AND cuisine='German';

-- 5. Invalid delete from Cook (staff still preparing Indonesian)
DELETE FROM Cook WHERE staff='STAFF-03' AND cuisine='Indonesian';

-- 6. Invalid item cuisine update (staff can’t cook new cuisine)
UPDATE Item SET cuisine='German' WHERE name='Rendang';

-- 7. Valid cuisine update after adding qualification
INSERT INTO Cook VALUES ('STAFF-06', 'Indian');
UPDATE Item SET cuisine='Indian' WHERE name='Palak Paneer';
SELECT name, cuisine FROM Item WHERE name='Palak Paneer';

-- EC1: Staff-01 (Indonesian) now prepares Palak Paneer (Indian)
UPDATE Prepare
SET item = 'Palak Paneer'
WHERE order_id='20240520001' AND staff='STAFF-01';
-- should fail, since STAFF-01 not qualified for Indian

-- STAFF-04 can cook both Indonesian and German - Should fail can't delete
DELETE FROM Cook WHERE staff='STAFF-04' AND cuisine='Indonesian';


-- ============================================
-- CONSTRAINT 3: Order datetime >= Member registration
-- ============================================

-- TEST 3.1: Order before member registration (SHOULD FAIL)
BEGIN; -- Start a transaction

-- Create an order on Jan 1st, 2024 (BEFORE the Jan 3rd registration)
INSERT INTO Food_Order VALUES ('20240101001', '2024-01-01', '10:00:00', 'cash', NULL, NULL, 0);

-- Link it to member '93627414'
INSERT INTO Ordered_By (order_id, member) VALUES ('20240101001', '93627414');

-- Try to commit the transaction
COMMIT;

-- Error Message: ERROR:  Invalid order - Order on 2024-01-01 10:00:00 is before member registration on 2024-01-03 12:19:23
-- CONTEXT:  PL/pgSQL function order_member() line 17 at RAISE SQL state: P0001

-- TEST 3.2: Order after member registration (SHOULD SUCCEED)
BEGIN;

-- This order is on the SAME DAY (Jan 3) as registration,
-- but at a LATER TIME (14:00:00) than registration (12:19:23)
INSERT INTO Food_Order VALUES ('20240103002', '2024-01-03', '14:00:00', 'card', '2222-3333-4444-5555', 'mastercard', 0);

-- Link the order to member '93627414'
INSERT INTO Ordered_By (order_id, member) VALUES ('20240103002', '93627414');

-- Add an item to the order
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240103002', 'Bun Cha', 'STAFF-03', 1);

-- This COMMIT will execute the deferred trigger and should SUCCEED.
COMMIT;

-- TEST 3.3: Order on same day but earlier time (SHOULD FAIL)
BEGIN;

-- This order is on the SAME DAY (Jan 3) as registration,
-- but at an EARLIER TIME (10:00:00) than registration (12:19:23)
INSERT INTO Food_Order VALUES ('20240103001', '2024-01-03', '10:00:00', 'card', '1111-2222-3333-4444', 'visa', 0);

-- Link the order to member '93627414'
INSERT INTO Ordered_By (order_id, member) VALUES ('20240103001', '93627414');

-- Add an item to the order
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240103001', 'Rendang', 'STAFF-01', 1);

-- This COMMIT will execute the deferred trigger and should FAIL.
COMMIT;

-- Error Message: ERROR:  Invalid order - Order on 2024-01-03 10:00:00 is before member registration on 2024-01-03 12:19:23
-- CONTEXT:  PL/pgSQL function order_member() line 17 at RAISE SQL state: P0001

-- ============================================
-- CONSTRAINT 4: Total price calculation with discount
-- ============================================

-- TEST 4.1: Member with 4 Indonesian dishes → discount applies
-- Items: 4 × Rendang ($4) = 16 → 16 − 2 = 14
INSERT INTO Food_Order VALUES ('20250320001', '2025-03-01', '12:19:23', 'card', '5108-7574-2920-6803', 'mastercard', 0);
INSERT INTO Ordered_By VALUES ('20250320001', 93627414);
INSERT INTO Prepare VALUES ('20250320001', 'Rendang', 'STAFF-01', 4);
SELECT id, total_price FROM Food_Order WHERE id = '20250320001';


-- TEST 4.2: Non-member with 4 Indonesian dishes → no discount
-- Items: 4 × Rendang ($4) = 16
INSERT INTO Food_Order VALUES ('20250320002', '2025-03-01', '13:46:33', 'card', '3466-5960-1418-4580', 'visa', 0);
INSERT INTO Prepare VALUES ('20250320002', 'Rendang', 'STAFF-04', 4);
SELECT id, total_price FROM Food_Order WHERE id = '20250320002';


-- TEST 4.3: Member with only 3 dishes → no discount
-- Items: 3 × Gudeg ($3) = 9
INSERT INTO Food_Order VALUES ('20250320003', '2025-03-01', '13:48:15', 'card', '3379-4110-3466-1310', 'visa', 0);
INSERT INTO Ordered_By VALUES ('20250320003', 85205752);  -- member Kiah
INSERT INTO Prepare VALUES ('20250320003', 'Gudeg', 'STAFF-05', 3);
SELECT id, total_price FROM Food_Order WHERE id = '20250320003';


-- TEST 4.4: Member with mixed cuisines totaling 4+ items → discount applies
-- Items: Rendang (2×4) + Sauerbraten (2×4) = 16 → 14 after discount
INSERT INTO Food_Order VALUES ('20250320004', '2025-03-01', '15:39:48', 'card', '3742-8382-6101-0570', 'mastercard', 0);
INSERT INTO Ordered_By VALUES ('20250320004', 89007281);  -- member Bernard
INSERT INTO Prepare VALUES
('20250320004', 'Rendang', 'STAFF-06', 2),
('20250320004', 'Sauerbraten', 'STAFF-06', 2);
SELECT id, total_price FROM Food_Order WHERE id = '20250320004';


-- TEST 4.5: Add item to make eligible for discount
-- Step 1: 3 dishes → no discount (3 × Rinderrouladen = 10.5)
INSERT INTO Food_Order VALUES ('20250320005', '2025-03-01', '16:19:03', 'card', '5002-3594-5319-1014', 'mastercard', 0);
INSERT INTO Ordered_By VALUES ('20250320005', 81059611);  -- member Laurette
INSERT INTO Prepare VALUES ('20250320005', 'Rinderrouladen', 'STAFF-02', 3);
SELECT id, total_price FROM Food_Order WHERE id = '20250320005';

-- Step 2: Add 1 Ayam Balado ($4) → total 14.5 → discount −2 = 12.5
INSERT INTO Prepare VALUES ('20250320005', 'Ayam Balado', 'STAFF-01', 1);
SELECT id, total_price FROM Food_Order WHERE id = '20250320005';


-- TEST 4.6: Decrease quantity → discount removed
-- Step 1: 4 items → discount applies (4 × Palak Paneer = 16 → 14)
INSERT INTO Food_Order VALUES ('20250320006', '2025-03-01', '17:00:00', 'card', '9999-8888-7777-6666', 'visa', 0);
INSERT INTO Ordered_By VALUES ('20250320006', 93342383);  -- member Corby
INSERT INTO Prepare VALUES ('20250320006', 'Palak Paneer', 'STAFF-03', 4);
SELECT id, total_price FROM Food_Order WHERE id = '20250320006';

-- Step 2: Reduce to 3 → no discount (3 × 4 = 12)
UPDATE Prepare SET qty = 3 WHERE order_id = '20250320006' AND item = 'Palak Paneer';
SELECT id, total_price FROM Food_Order WHERE id = '20250320006';


-- TEST 4.7: Delete item → total price recalculated
-- Step 1: 4 total items → discount applies ((2×Bun Cha=$6)+(2×Thunder Tea Rice=$5)=11−2=9)
INSERT INTO Food_Order VALUES ('20250320007', '2025-03-01', '17:10:00', 'card', '4444-5555-6666-7777', 'visa', 0);
INSERT INTO Ordered_By VALUES ('20250320007', 96537349);  -- member Grissel
INSERT INTO Prepare VALUES
('20250320007', 'Bun Cha', 'STAFF-03', 2),
('20250320007', 'Thunder Tea Rice', 'STAFF-02', 2);
SELECT id, total_price FROM Food_Order WHERE id = '20250320007';

-- Step 2: Delete 1 item → below 4 → no discount (2 × 3 = 6)
DELETE FROM Prepare WHERE order_id = '20250320007' AND item = 'Thunder Tea Rice';
SELECT id, total_price FROM Food_Order WHERE id = '20250320007';