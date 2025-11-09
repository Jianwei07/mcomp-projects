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

-- Test 1: Create an order on Jan 1st, 2024 (BEFORE the Jan 3rd registration)
INSERT INTO Food_Order VALUES ('20240101001', '2024-01-01', '10:00:00', 'cash', NULL, NULL, 0);

-- Test 2: Link it to member '93627414'
INSERT INTO Ordered_By (order_id, member) VALUES ('20240101001', '93627414');

-- Test 3: Try to commit the transaction
-- This COMMIT line is what will fail and roll back the transaction
COMMIT;

-- Error Message: ERROR:  Invalid order - Order on 2024-01-01 10:00:00 is before member registration on 2024-01-03 12:19:23
-- CONTEXT:  PL/pgSQL function order_member() line 17 at RAISE SQL state: P0001

-- TEST 3.2: Order after member registration (SHOULD SUCCEED)
INSERT INTO Food_Order VALUES ('20240320006', '16/2/2024', '10:00:00', 'card', '3742-8382-6101-0570', 'americanexpress', 0);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320006', 'Pho', 'STAFF-02', 1);
INSERT INTO Ordered_By (order_id, member) VALUES ('20240320006', 91234567);
SELECT 'TEST 3.2: ' || CASE WHEN COUNT(*) = 1 THEN '✓ PASS' ELSE '✗ FAIL' END 
FROM Ordered_By WHERE order_id = '20240320006';

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

-- TEST 4.1: Member with 4 items → Should get $2 discount
-- Price: 4*4 = 16, with discount = 14
INSERT INTO Food_Order VALUES ('20240320008', '1/3/2024', '12:19:23', 'card', '5108-7574-2920-6803', 'mastercard', 0);
INSERT INTO Ordered_By (order_id, member) VALUES ('20240320008', 98765432);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320008', 'Bun Cha', 'STAFF-01', 4);
SELECT 'TEST 4.1: ' || id || ' = ' || total_price || ' ' ||
       CASE WHEN total_price = 14 THEN '✓ PASS' ELSE '✗ FAIL (expected 14)' END 
FROM Food_Order WHERE id = '20240320008';

-- TEST 4.2: Non-member with 4 items → No discount
-- Price: 4*4 = 16 (no discount)
INSERT INTO Food_Order VALUES ('20240320009', '1/3/2024', '13:46:33', 'card', '3466-5960-1418-4580', 'americanexpress', 0);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320009', 'Bun Cha', 'STAFF-02', 4);
SELECT 'TEST 4.2: ' || id || ' = ' || total_price || ' ' ||
       CASE WHEN total_price = 16 THEN '✓ PASS' ELSE '✗ FAIL (expected 16)' END 
FROM Food_Order WHERE id = '20240320009';

-- TEST 4.3: Member with 3 items → No discount (< 4 items)
-- Price: 3*4 = 12 (no discount)
INSERT INTO Food_Order VALUES ('20240320010', '1/3/2024', '13:48:15', 'card', '3379-4110-3466-1310', 'americanexpress', 0);
INSERT INTO Ordered_By (order_id, member) VALUES ('20240320010', 98765432);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320010', 'Bun Cha', 'STAFF-01', 3);
SELECT 'TEST 4.3: ' || id || ' = ' || total_price || ' ' ||
       CASE WHEN total_price = 12 THEN '✓ PASS' ELSE '✗ FAIL (expected 12)' END 
FROM Food_Order WHERE id = '20240320010';

-- TEST 4.4: Member with mixed items (4+ total) → Discount applies
-- Price: 4 + 5 + 6 + 3 = 18, with discount = 16
INSERT INTO Food_Order VALUES ('20240320011', '1/3/2024', '15:39:48', 'card', '3742-8382-6101-0570', 'americanexpress', 0);
INSERT INTO Ordered_By (order_id, member) VALUES ('20240320011', 87654321);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES 
('20240320011', 'Bun Cha', 'STAFF-01', 1),
('20240320011', 'Pho', 'STAFF-02', 1),
('20240320011', 'Pad Thai', 'STAFF-01', 1),
('20240320011', 'Spring Roll', 'STAFF-02', 1);
SELECT 'TEST 4.4: ' || id || ' = ' || total_price || ' ' ||
       CASE WHEN total_price = 16 THEN '✓ PASS' ELSE '✗ FAIL (expected 16)' END 
FROM Food_Order WHERE id = '20240320011';

-- TEST 4.5: Add item to make eligible for discount
-- Initial: 3 items = 12 (no discount)
-- After adding 1 more: 4 items = 14 (with discount)
INSERT INTO Food_Order VALUES ('20240320012', '1/3/2024', '16:19:03', 'card', '5002-3594-5319-1014', 'mastercard', 0);
INSERT INTO Ordered_By (order_id, member) VALUES ('20240320012', 91234567);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320012', 'Bun Cha', 'STAFF-01', 3);
SELECT 'TEST 4.5a: ' || id || ' = ' || total_price || ' ' ||
       CASE WHEN total_price = 12 THEN '✓ PASS' ELSE '✗ FAIL (expected 12)' END 
FROM Food_Order WHERE id = '20240320012';

-- Now add one more item
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320012', 'Spring Roll', 'STAFF-02', 1);
SELECT 'TEST 4.5b: ' || id || ' = ' || total_price || ' ' ||
       CASE WHEN total_price = 13 THEN '✓ PASS' ELSE '✗ FAIL (expected 13)' END 
FROM Food_Order WHERE id = '20240320012';

-- ============================================
-- SUMMARY
-- ============================================
SELECT '========================================' as summary;
SELECT 'All tests completed. Check results above.' as summary;
SELECT 'Failed constraints should have raised exceptions.' as summary;