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

-- TEST 1.1: Try to delete last item from order (SHOULD FAIL)
INSERT INTO Food_Order VALUES ('20240320001', '20/3/2024', '10:15:51', 'card', '3742-8375-6443-8590', 'americanexpress', 0);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320001', 'Bun Cha', 'STAFF-01', 1);
-- Expected: This should FAIL because order would have 0 items
-- DELETE FROM Prepare WHERE order_id = '20240320001';

-- TEST 1.2: Delete one item when multiple exist (SHOULD SUCCEED)
INSERT INTO Food_Order VALUES ('20240320002', '20/3/2024', '10:30:00', 'cash', NULL, NULL, 0);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES 
('20240320002', 'Bun Cha', 'STAFF-01', 2),
('20240320002', 'Pho', 'STAFF-02', 1);
-- Expected: This should SUCCEED because order still has items
DELETE FROM Prepare WHERE order_id = '20240320002' AND item = 'Pho';
SELECT 'TEST 1.2: ' || CASE WHEN COUNT(*) = 1 THEN '✓ PASS' ELSE '✗ FAIL' END 
FROM Prepare WHERE order_id = '20240320002';

-- ============================================
-- CONSTRAINT 2: Staff must cook item's cuisine
-- ============================================

-- TEST 2.1: Staff cooking wrong cuisine (SHOULD FAIL)
INSERT INTO Food_Order VALUES ('20240320003', '20/3/2024', '11:00:00', 'card', '5108-7574-2920-6803', 'mastercard', 0);
-- Expected: This should FAIL - STAFF-03 cannot cook Vietnamese
-- INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320003', 'Bun Cha', 'STAFF-03', 1);

-- TEST 2.2: Staff cooking correct cuisine (SHOULD SUCCEED)
INSERT INTO Food_Order VALUES ('20240320004', '20/3/2024', '11:15:00', 'card', '3466-5960-1418-4580', 'americanexpress', 0);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320004', 'Bun Cha', 'STAFF-01', 2);
SELECT 'TEST 2.2: ' || CASE WHEN COUNT(*) = 1 THEN '✓ PASS' ELSE '✗ FAIL' END 
FROM Prepare WHERE order_id = '20240320004';

-- TEST 2.3: Update to wrong staff (SHOULD FAIL)
-- Expected: This should FAIL - STAFF-03 cannot cook Vietnamese
-- UPDATE Prepare SET staff = 'STAFF-03' WHERE order_id = '20240320004';

-- ============================================
-- CONSTRAINT 3: Order datetime >= Member registration
-- ============================================

-- TEST 3.1: Order before member registration (SHOULD FAIL)
INSERT INTO Food_Order VALUES ('20240320005', '14/2/2024', '08:00:00', 'card', '3379-4110-3466-1310', 'americanexpress', 0);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320005', 'Pho', 'STAFF-01', 1);
-- Expected: This should FAIL - order is before Alice's registration (2024-02-15 09:00)
-- INSERT INTO Ordered_By (order_id, member) VALUES ('20240320005', 91234567);

-- TEST 3.2: Order after member registration (SHOULD SUCCEED)
INSERT INTO Food_Order VALUES ('20240320006', '16/2/2024', '10:00:00', 'card', '3742-8382-6101-0570', 'americanexpress', 0);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320006', 'Pho', 'STAFF-02', 1);
INSERT INTO Ordered_By (order_id, member) VALUES ('20240320006', 91234567);
SELECT 'TEST 3.2: ' || CASE WHEN COUNT(*) = 1 THEN '✓ PASS' ELSE '✗ FAIL' END 
FROM Ordered_By WHERE order_id = '20240320006';

-- TEST 3.3: Order on same day but earlier time (SHOULD FAIL)
INSERT INTO Food_Order VALUES ('20240320007', '1/3/2024', '09:00:00', 'card', '5002-3594-5319-1014', 'mastercard', 0);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('20240320007', 'Pad Thai', 'STAFF-01', 1);
-- Expected: This should FAIL - order time 09:00 is before Bob's registration 10:00
-- INSERT INTO Ordered_By (order_id, member) VALUES ('20240320007', 98765432);

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