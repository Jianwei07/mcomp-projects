-- Setup: Create schema and add sample data
-- (Assuming schema-part3.sql is already loaded)

-- Add sample cuisines
INSERT INTO Cuisine VALUES ('Vietnamese'), ('Italian');

-- Add sample items
INSERT INTO Item VALUES ('Pho', 4.00, 'Vietnamese');
INSERT INTO Item VALUES ('Bun Cha', 4.00, 'Vietnamese');
INSERT INTO Item VALUES ('Pizza', 5.00, 'Italian');

-- Add sample staff
INSERT INTO Staff VALUES ('STAFF-01', 'Alice');
INSERT INTO Staff VALUES ('STAFF-02', 'Bob');

-- Staff skills
INSERT INTO Cook VALUES ('STAFF-01', 'Vietnamese');
INSERT INTO Cook VALUES ('STAFF-02', 'Italian');

-- Add sample member
INSERT INTO Member VALUES (91234567, 'John', 'Doe', '2024-01-01', '10:00:00');


-- ============================================
-- TEST 1: Constraint 1 - Cannot delete last item
-- ============================================
-- Expected: SUCCESS (insert)
INSERT INTO Food_Order VALUES ('ORD001', '2024-02-01', '12:00:00', 'cash', NULL, NULL, 0);
INSERT INTO Prepare VALUES ('ORD001', 'Pho', 'STAFF-01', 2);

-- Expected: FAIL (cannot delete last item)
DELETE FROM Prepare WHERE order_id = 'ORD001';
-- Error: "Order must have at least one item"


-- ============================================
-- TEST 2: Constraint 2 - Staff must know cuisine
-- ============================================
-- Expected: FAIL (STAFF-02 cannot cook Vietnamese)
INSERT INTO Food_Order VALUES ('ORD002', '2024-02-02', '13:00:00', 'cash', NULL, NULL, 0);
INSERT INTO Prepare VALUES ('ORD002', 'Pho', 'STAFF-02', 1);
-- Error: "Staff cannot cook this cuisine"


-- ============================================
-- TEST 3: Constraint 3 - Order after registration
-- ============================================
-- Expected: FAIL (order before member registration)
INSERT INTO Food_Order VALUES ('ORD003', '2023-12-01', '09:00:00', 'cash', NULL, NULL, 0);
INSERT INTO Prepare VALUES ('ORD003', 'Pho', 'STAFF-01', 1);
INSERT INTO Ordered_By VALUES ('ORD003', 91234567);
-- Error: "Order date/time before member registration"


-- ============================================
-- TEST 4: Constraint 4 - Total price calculation
-- ============================================
-- Member order with 4 items: $4 × 4 - $2 = $14
INSERT INTO Food_Order VALUES ('ORD004', '2024-03-01', '12:00:00', 'cash', NULL, NULL, 0);
INSERT INTO Ordered_By VALUES ('ORD004', 91234567);
INSERT INTO Prepare VALUES ('ORD004', 'Pho', 'STAFF-01', 4);

-- Check total_price
SELECT id, total_price FROM Food_Order WHERE id = 'ORD004';
-- Expected: total_price = 14.00

-- Non-member order with 4 items: $4 × 4 = $16
INSERT INTO Food_Order VALUES ('ORD005', '2024-03-05', '15:00:00', 'cash', NULL, NULL, 0);
INSERT INTO Prepare VALUES ('ORD005', 'Pho', 'STAFF-01', 4);

-- Check total_price
SELECT id, total_price FROM Food_Order WHERE id = 'ORD005';
-- Expected: total_price = 16.00

-- Member order with 3 items: $4 × 3 = $12 (no discount)
INSERT INTO Food_Order VALUES ('ORD006', '2024-03-10', '18:00:00', 'cash', NULL, NULL, 0);
INSERT INTO Ordered_By VALUES ('ORD006', 91234567);
INSERT INTO Prepare VALUES ('ORD006', 'Pho', 'STAFF-01', 3);

-- Check total_price
SELECT id, total_price FROM Food_Order WHERE id = 'ORD006';
-- Expected: total_price = 12.00