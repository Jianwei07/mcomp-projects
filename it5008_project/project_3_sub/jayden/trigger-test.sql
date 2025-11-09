-- ====================================================================
-- SETUP: Clean and populate test data
-- ====================================================================

TRUNCATE Prepare, Ordered_By, Food_Order, Member, Cook, Staff, Item, Cuisine 
RESTART IDENTITY CASCADE;

-- Insert test data
INSERT INTO Cuisine VALUES ('Italian'), ('Japanese'), ('Chinese');

INSERT INTO Item VALUES 
    ('Pasta', 10, 'Italian'), 
    ('Sushi', 8, 'Japanese'), 
    ('Pizza', 12, 'Italian'),
    ('Ramen', 9, 'Japanese');

INSERT INTO Staff VALUES 
    ('S1', 'Mario'), 
    ('S2', 'Sakura'),
    ('S3', 'Wei');

INSERT INTO Cook VALUES 
    ('S1', 'Italian'), 
    ('S2', 'Japanese'),
    ('S3', 'Chinese');

INSERT INTO Member VALUES 
    (1111, 'John', 'Doe', '2024-01-01', '10:00:00'),
    (2222, 'Jane', 'Smith', '2024-02-01', '12:00:00');


-- ====================================================================
-- TEST CONSTRAINT 1: Each order must have at least one item
-- ====================================================================

-- Setup: Create order with one item
INSERT INTO Food_Order (id, date, time, payment_method, card, card_type, total_price)
VALUES ('O1', '2024-03-01', '13:00:00', 'cash', NULL, NULL, 0);

INSERT INTO Prepare VALUES ('O1', 'Pasta', 'S1', 1);

-- Test 1a: Delete the ONLY item -> should FAIL
-- Expected: ERROR (Constraint 1 Violation)
BEGIN;
    DELETE FROM Prepare WHERE order_id = 'O1' AND item = 'Pasta';
    -- This should raise exception
ROLLBACK;

-- Test 1b: Add second item, then delete one -> should SUCCEED
INSERT INTO Prepare VALUES ('O1', 'Pizza', 'S1', 1);
DELETE FROM Prepare WHERE order_id = 'O1' AND item = 'Pasta';
-- Expected: SUCCESS (still has Pizza)


-- ====================================================================
-- TEST CONSTRAINT 2: Staff must be qualified to cook item's cuisine
-- ====================================================================

INSERT INTO Food_Order (id, date, time, payment_method, total_price)
VALUES ('O2', '2024-03-02', '14:00:00', 'cash', 0);

-- Test 2a: Staff S2 (Japanese) tries to cook Italian -> should FAIL
-- Expected: ERROR (Constraint 2 Violation)
BEGIN;
    INSERT INTO Prepare VALUES ('O2', 'Pizza', 'S2', 1);
ROLLBACK;

-- Test 2b: Staff S1 (Italian) cooks Italian -> should SUCCEED
INSERT INTO Prepare VALUES ('O2', 'Pizza', 'S1', 1);
-- Expected: SUCCESS


-- ====================================================================
-- TEST CONSTRAINT 3: Order must be after member registration
-- ====================================================================

-- Member 1111 registered on 2024-01-01 10:00:00

-- Test 3a: Order BEFORE registration -> should FAIL
-- Expected: ERROR (Constraint 3 Violation)
INSERT INTO Food_Order (id, date, time, payment_method, total_price)
VALUES ('O3', '2023-12-31', '09:00:00', 'cash', 0);

INSERT INTO Prepare VALUES ('O3', 'Sushi', 'S2', 1);

BEGIN;
    INSERT INTO Ordered_By VALUES ('O3', 1111);
ROLLBACK;

-- Test 3b: Order AFTER registration -> should SUCCEED
INSERT INTO Food_Order (id, date, time, payment_method, total_price)
VALUES ('O4', '2024-03-10', '15:00:00', '