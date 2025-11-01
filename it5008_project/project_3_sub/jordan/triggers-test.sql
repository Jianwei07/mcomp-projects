-- Disable constraints temporarily for setup
SET CONSTRAINTS ALL DEFERRED;

-- === A. ESSENTIAL PARENT DATA SETUP ===

-- 1. Cuisine (Added the cuisines found in your bulk data)
INSERT INTO Cuisine (name) VALUES 
('Indonesian'), ('German'), ('Italian'), ('Japanese'), ('Singaporean'), ('Indian'), ('Vietnamese')
ON CONFLICT (name) DO NOTHING;

-- 2. Staff & Cook (Minimal setup based on IDs found in your data)
INSERT INTO Staff (id, name) VALUES 
('S101', 'Chef Alex'), ('S102', 'Cook Bella'), ('S103', 'Prep Chris'), ('S104', 'Cook Delta')
ON CONFLICT (id) DO NOTHING;

-- Assign capabilities (S103 remains unassigned for C2 failure test)
INSERT INTO Cook (staff, cuisine) VALUES 
('S101', 'Italian'),
('S102', 'Japanese'), 
('S104', 'Indonesian'),
('S104', 'German')
ON CONFLICT (staff, cuisine) DO NOTHING;

-- 3. Item (Prices and cuisines needed for C2 and C4)
INSERT INTO Item (name, price, cuisine) VALUES 
('Rendang', 10.00, 'Indonesian'),
('Rinderrouladen', 15.00, 'German'),
('Margherita Pizza', 18.00, 'Italian'),
('Thunder Tea Rice', 5.00, 'Singaporean') -- Used to test C2 staff failure
ON CONFLICT (name) DO NOTHING;

-- 4. Member (Specific times for Constraint 3 failure/success)
INSERT INTO Member (phone, firstname, lastname, reg_date, reg_time) VALUES
(93627414, 'Late', 'Reg', '2024-03-02', '11:00:00'), -- Reg time used to fail Order 20240301002
(88800000, 'Test', 'Discount', '2024-03-01', '10:00:00'), -- Early registrant for discount success
(99900000, 'Clean', 'Order', '2024-11-01', '10:00:00') -- Safe member for C1 tests
ON CONFLICT (phone) DO NOTHING;


-- === B. CONTROL ORDER SETUP ===
-- Orders T_C4_PASS and T_C1_DEL are clean, new orders used for testing triggers.
INSERT INTO Food_Order (id, date, time, payment_method, card, card_type, total_price) VALUES
('T_C4_PASS', '2024-11-01', '12:00:00', 'card', '1111', 'Visa', 0.00), -- Discount test order
('T_C1_DEL', '2024-11-01', '13:00:00', 'cash', NULL, NULL, 0.00);    -- Constraint 1 test order

INSERT INTO Ordered_By (order_id, member) VALUES 
('T_C4_PASS', 88800000), 
('T_C1_DEL', 99900000); 

COMMIT; 
SET CONSTRAINTS ALL IMMEDIATE;

-- =================================================================
-- TEST 1: Each order should have at least one item (Constraint 1)
-- =================================================================

-- Context: Order T_C1_DEL must be populated with items first.

-- 1. Setup: Insert two items into T_C1_DEL.
-- This setup assumes these items and staff S104 exist and are valid for the cuisine check (C2).
INSERT INTO Prepare (order_id, item, staff, qty) VALUES 
('T_C1_DEL', 'Rinderrouladen', 'S104', 1); -- Item 1
INSERT INTO Prepare (order_id, item, staff, qty) VALUES 
('T_C1_DEL', 'Rendang', 'S104', 1); -- Item 2

-- Test 1.1: Delete one item. Should succeed.
SELECT 'Test 1.1: Delete one item (Success)' AS Test;
-- Expected Outcome: SUCCESS
DELETE FROM Prepare WHERE order_id = 'T_C1_DEL' AND item = 'Rendang';


-- Test 1.2: Try to delete the LAST remaining item.
SELECT 'Test 1.2: Reject deleting last entry' AS Test;
-- Expected Outcome: REJECTED (Constraint 1 Violation)
BEGIN;
    -- This operation will leave the Food_Order record with zero related Prepare records, violating C1.
    DELETE FROM Prepare WHERE order_id = 'T_C1_DEL' AND item = 'Rinderrouladen';
    -- Since this is a simple DELETE operation on Prepare, the check should fire immediately 
    -- (or before commit if deferred).
COMMIT;
-- The entire transaction fails due to the trigger EXCEPTION.

-- Cleanup: ROLLBACK clears the aborted state for the next test.
ROLLBACK;



SELECT '--- Test 2.2: Reject UPDATE to an unqualified staff (SELF-CONTAINED) ---' AS Test;

-- Start a single transaction block for the test and cleanup
BEGIN;

    -- === 1. GUARANTEE ALL PARENT DATA EXISTS FOR THIS TEST ===
    
    -- Member Data (The failing dependency: 99992222)
    INSERT INTO Member (phone, firstname, lastname, reg_date, reg_time)
    VALUES (99992222, 'Sue', 'Late', '2024-04-05', '15:00:00')
    ON CONFLICT (phone) DO NOTHING;
    
    -- Staff Data (The cooks needed)
    INSERT INTO Staff (id, name) VALUES ('S101', 'Chef Alex'), ('S104', 'Cook Delta'), ('S102', 'Cook Bella')
    ON CONFLICT (id) DO NOTHING;

    -- Cuisine Data
    INSERT INTO Cuisine (name) VALUES ('Italian'), ('Indonesian'), ('Japanese')
    ON CONFLICT (name) DO NOTHING;

    -- Cook Capabilities (Required for the check)
    INSERT INTO Cook (staff, cuisine) VALUES 
    ('S101', 'Italian'),       -- Alex (Italian)
    ('S104', 'Indonesian'),    -- Delta (Indonesian)
    ('S102', 'Japanese')       -- Bella (Japanese)
    ON CONFLICT (staff, cuisine) DO NOTHING;
    
    -- Item Data (The items needed)
    INSERT INTO Item (name, price, cuisine) VALUES 
    ('Rendang', 10.00, 'Indonesian'),
    ('Margherita Pizza', 18.00, 'Italian')
    ON CONFLICT (name) DO NOTHING;

    -- === 2. CLEANUP & ORDER INSERT (The core of the test) ===
    
    -- Clean up and re-insert the specific test order
    DELETE FROM Prepare WHERE order_id = 'T_C4_02';
    DELETE FROM Ordered_By WHERE order_id = 'T_C4_02';
    DELETE FROM Food_Order WHERE id = 'T_C4_02'; 

    INSERT INTO Food_Order (id, date, time, payment_method, card, card_type, total_price) 
    VALUES ('T_C4_02', '2024-04-06', '14:05:00', 'card', '1111', 'Visa', '0.0'); 
    
    -- This INSERT INTO Ordered_By will now succeed because 99992222 exists above.
    INSERT INTO Ordered_By (order_id, member) 
    VALUES ('T_C4_02', 99992222); 

    -- Insert the VALID Prepare record: Rendang (Indonesian) by S104 (Indonesian Cook)
    INSERT INTO Prepare (order_id, item, staff, qty) 
    VALUES ('T_C4_02', 'Rendang', 'S104', 1);

    
    -- === 3. FAILURE EXECUTION ===
    SELECT 'Attempting invalid update: S104 (Indonesian) -> S101 (Italian) on Rendang...' AS Action;
    
    -- The UPDATE attempts to assign an Indonesian item to an Italian cook (S101).
    UPDATE Prepare
    SET staff = 'S101' 
    WHERE order_id = 'T_C4_02' AND item = 'Rendang' AND staff = 'S104'; 
    
COMMIT; 

ROLLBACK; 
SELECT 'Test 2.2 Complete. Original data state restored.' AS Status;

    -- === 3. ORDER CANNOT BE BEFORE REGISTRATION ===

BEGIN;

-- Member registered at 15:00
INSERT INTO Member (phone, firstname, lastname, reg_date, reg_time)
VALUES (99992222, 'Sue', 'Late', '2024-04-05', '15:00:00')
ON CONFLICT (phone) DO NOTHING;

-- Clean previous test data
DELETE FROM Ordered_By WHERE order_id = 'T_C3_FAIL_V2';
DELETE FROM Food_Order WHERE id = 'T_C3_FAIL_V2';

-- Create order at 14:00 (invalid)
INSERT INTO Food_Order (id, date, time, payment_method, card, card_type, total_price)
VALUES ('T_C3_FAIL_V2', '2024-04-05', '14:00:00', 'cash', NULL, NULL, 0.00);

-- This should RAISE EXCEPTION
INSERT INTO Ordered_By (order_id, member)
VALUES ('T_C3_FAIL_V2', 99992222);

COMMIT;


SELECT '--- Test 4.1: Activate $2 Discount (Final Execution Block) ---' AS Test;

BEGIN; 
    -- 1. GUARANTEE ALL PARENT DATA FOR THIS TEST EXISTS
    INSERT INTO Cuisine (name) VALUES ('Japanese'), ('Asian') ON CONFLICT (name) DO NOTHING;
    INSERT INTO Staff (id, name) VALUES ('S102', 'Cook Bella'), ('S104', 'Cook Delta') ON CONFLICT (id) DO NOTHING;
    INSERT INTO Cook (staff, cuisine) VALUES ('S102', 'Japanese'), ('S104', 'Asian') ON CONFLICT (staff, cuisine) DO NOTHING;
    
    -- FIX: GUARANTEE ITEMS EXIST (Prevents the 'Ramen is not present' error)
    INSERT INTO Item (name, price, cuisine) VALUES 
    ('Ramen', 8.00, 'Japanese'),
    ('Soda', 2.00, 'Asian')       
    ON CONFLICT (name) DO UPDATE SET price = EXCLUDED.price, cuisine = EXCLUDED.cuisine;

    INSERT INTO Member (phone, firstname, lastname, reg_date, reg_time)
    VALUES (99992222, 'Sue', 'Test', '2024-04-05', '15:00:00') ON CONFLICT (phone) DO NOTHING;

    -- 2. SETUP ORDER T_C4_02
    DELETE FROM Prepare WHERE order_id = 'T_C4_02';
    DELETE FROM Ordered_By WHERE order_id = 'T_C4_02';
    DELETE FROM Food_Order WHERE id = 'T_C4_02'; 

    INSERT INTO Food_Order (id, date, time, payment_method, card, card_type, total_price) 
    VALUES ('T_C4_02', '2024-04-06', '14:05:00', 'card', '1111', 'Visa', 0.00); 
    INSERT INTO Ordered_By (order_id, member) VALUES ( 'T_C4_02', 99992222); 

    -- 3. EXECUTION: ACTIVATE DISCOUNT (4 items total)
    -- Base Sum = 20.00. Final Price: 18.00
    INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('T_C4_02', 'Ramen', 'S102', 2); 
    INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('T_C4_02', 'Soda', 'S104', 2); 

COMMIT; -- Trigger 4.1 fires here and calculates the price.

-- === VERIFICATION (Must be run after the COMMIT) ===
SELECT total_price AS Final_Price_4_Items FROM Food_Order WHERE id = 'T_C4_02';

--- === FINAL CLEANUP BLOCK RUN AFTER EXECUTING THE ABOVE TEST===
SELECT '--- Final Cleanup: Removing Committed T_C4_02 Data ---' AS Status;

BEGIN;
    -- 1. Delete the Member Link (Required before deleting Member)
    DELETE FROM Ordered_By WHERE order_id = 'T_C4_02';

    -- 2. Delete the PARENT ORDER RECORD. 
    -- This triggers ON DELETE CASCADE, silently removing all Prepare items.
    DELETE FROM Food_Order WHERE id = 'T_C4_02'; 
    
    -- 3. Clean up the temporary test member (Now unblocked)
    DELETE FROM Member WHERE phone = 99992222; 
    
COMMIT;

SELECT 'Committed test data T_C4_02 and dependencies successfully removed.' AS Status;