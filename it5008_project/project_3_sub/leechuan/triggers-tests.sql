-- Clean up previous data
TRUNCATE Prepare, Ordered_By, Food_Order, Member, Cook, Staff, Item, Cuisine RESTART IDENTITY CASCADE;

--------------------------------------------------
-- Setup shared test data
--------------------------------------------------

-- Insert cuisines
INSERT INTO Cuisine VALUES ('Italian'), ('Japanese');

-- Insert items
INSERT INTO Item VALUES ('Pasta', 10, 'Italian'), ('Sushi', 8, 'Japanese'), ('Pizza', 12, 'Italian');

-- Insert staff
INSERT INTO Staff VALUES ('S1', 'Mario'), ('S2', 'Sakura');

-- Insert cooks (who can cook which cuisines)
INSERT INTO Cook VALUES ('S1', 'Italian'), ('S2', 'Japanese');

-- Insert members
INSERT INTO Member VALUES (1111, 'John', 'Doe', '2024-01-01', '10:00:00'),
                          (2222, 'Jane', 'Smith', '2024-02-01', '12:00:00');

-- Insert food orders
INSERT INTO Food_Order (id, date, time, payment_method, card, card_type, total_price)
VALUES ('O1', '2024-03-01', '13:00:00', 'cash', NULL, NULL, 0),
       ('O2', '2024-03-01', '14:00:00', 'card', 'AMEX', 938293847, 0);

-- Link O1 to member John
INSERT INTO Ordered_By VALUES ('O1', 1111);

--------------------------------------------------
-- CONSTRAINT 1: Each order must have at least one item
--------------------------------------------------

-- [ERROR TEST] TEST 1A: Delete all Prepare rows for an order → should be rejected
INSERT INTO Prepare VALUES ('O1', 'Pasta', 'S1', 1);
DELETE FROM Prepare WHERE order_id = 'O1'; 
-- Expected: ERROR (trigger should reject deletion because order would have 0 items)

-- [SUCCESS TEST] TEST 1B: Order with at least one item is allowed
INSERT INTO Prepare VALUES ('O1', 'Pizza', 'S1', 2);
-- Expected: SUCCESS

--------------------------------------------------
-- CONSTRAINT 2: Staff must be qualified to cook the item’s cuisine
--------------------------------------------------

-- [ERROR TEST] TEST 2A: Staff S2 (Japanese cook) tries to prepare Italian item
INSERT INTO Prepare VALUES ('O2', 'Pizza', 'S2', 1);
-- Expected: ERROR (S2 cannot cook Italian)

-- [SUCCESS TEST] TEST 2B: Staff S1 (Italian cook) prepares Italian item
INSERT INTO Prepare VALUES ('O2', 'Pizza', 'S1', 1);
-- Expected: SUCCESS

--------------------------------------------------
-- CONSTRAINT 3: Order’s date/time must not precede member’s registration
--------------------------------------------------

-- [ERROR TEST] TEST 3A: Insert order earlier than member registration
INSERT INTO Food_Order (id, date, time, payment_method, total_price)
VALUES ('O3', '2023-12-31', '09:00:00', 'cash', 0);

INSERT INTO Ordered_By VALUES ('O3', 1111);
-- Expected: ERROR (order date/time before registration)

-- [SUCCESS TEST] TEST 3B: Order after registration
INSERT INTO Food_Order (id, date, time, payment_method, total_price)
VALUES ('O4', '2024-03-10', '14:00:00', 'cash', 0);
INSERT INTO Ordered_By VALUES ('O4', 1111);
-- Expected: SUCCESS

--------------------------------------------------
-- CONSTRAINT 4: total_price must equal sum(items) - discount
--------------------------------------------------

-- Clean test order
INSERT INTO Food_Order (id, date, time, payment_method, total_price)
VALUES ('O5', '2024-04-01', '12:00:00', 'cash', 0);
INSERT INTO Ordered_By VALUES ('O5', 1111);

-- Insert items for O5 (staff S1 can cook Italian)
INSERT INTO Prepare VALUES ('O5', 'Pasta', 'S1', 1);
INSERT INTO Prepare VALUES ('O5', 'Pizza', 'S1', 1);
-- Expected: total_price = 10 + 12 = 22

-- [SUCCESS TEST] Check total price
SELECT id, total_price FROM Food_Order WHERE id = 'O5';
-- Expected output: O5 | 22

-- Add 2 more items → triggers $2 discount
INSERT INTO Prepare VALUES ('O5', 'Sushi', 'S2', 2);
-- Expected: total_price = (10+12+8+8) - 2 = 36

SELECT id, total_price FROM Food_Order WHERE id = 'O5';
-- Expected output: O5 | 36

-- [ERROR TEST] TEST 4A: Remove Ordered_By link → should lose discount
DELETE FROM Ordered_By WHERE order_id = 'O5';
-- Expected: total_price = 38 (no discount now)

SELECT id, total_price FROM Food_Order WHERE id = 'O5';
-- Expected output: O5 | 38

-- [SUCCESS TEST] TEST 4B: Add member back → regain discount
INSERT INTO Ordered_By VALUES ('O5', 1111);
SELECT id, total_price FROM Food_Order WHERE id = 'O5';
-- Expected output: O5 | 36 (discount applied again)
