-- ====================================================================
-- Insert First 100 Rows from order.csv Using Procedure
-- ====================================================================

-- Note: Since actual order.csv not provided, generating realistic test data
-- that demonstrates all features: member/non-member, cash/card, discount scenarios

-- Setup: Ensure required data exists
INSERT INTO Cuisine VALUES ('Indonesian'), ('Italian'), ('Japanese'), ('Chinese') 
ON CONFLICT (name) DO NOTHING;

INSERT INTO Item VALUES 
    ('Rendang', 10.00, 'Indonesian'),
    ('Nasi Goreng', 8.00, 'Indonesian'),
    ('Pizza Margherita', 12.00, 'Italian'),
    ('Carbonara', 14.00, 'Italian'),
    ('Sushi', 15.00, 'Japanese'),
    ('Ramen', 11.00, 'Japanese'),
    ('Kung Pao Chicken', 13.00, 'Chinese')
ON CONFLICT (name) DO NOTHING;

INSERT INTO Staff VALUES 
    ('S101', 'Chef Ahmad'), 
    ('S102', 'Chef Mario'), 
    ('S103', 'Chef Yuki'),
    ('S104', 'Chef Wei')
ON CONFLICT (id) DO NOTHING;

INSERT INTO Cook VALUES 
    ('S101', 'Indonesian'),
    ('S102', 'Italian'),
    ('S103', 'Japanese'),
    ('S104', 'Chinese')
ON CONFLICT (staff, cuisine) DO NOTHING;

INSERT INTO Member VALUES 
    (91234567, 'John', 'Doe', '2024-01-01', '10:00:00'),
    (92345678, 'Jane', 'Smith', '2024-01-02', '11:00:00'),
    (93456789, 'Bob', 'Johnson', '2024-01-03', '09:00:00'),
    (94567890, 'Alice', 'Brown', '2024-01-04', '14:00:00')
ON CONFLICT (phone) DO NOTHING;


-- ====================================================================
-- 100 CALL STATEMENTS (Simulating order.csv rows)
-- ====================================================================

-- Row 1: Member order O001 (will have 4 items for discount)
CALL insert_order_item('O001', '2024-03-01', '12:00:00', 'cash', NULL, NULL, 91234567, 'Rendang', 'S101');

-- Row 2: Same order, second item
CALL insert_order_item('O001', '2024-03-01', '12:00:00', 'cash', NULL, NULL, 91234567, 'Nasi Goreng', 'S101');

-- Row 3: Same order, third item
CALL insert_order_item('O001', '2024-03-01', '12:00:00', 'cash', NULL, NULL, 91234567, 'Rendang', 'S101');

-- Row 4: Same order, fourth item (triggers $2 discount)
CALL insert_order_item('O001', '2024-03-01', '12:00:00', 'cash', NULL, NULL, 91234567, 'Nasi Goreng', 'S101');

-- Row 5: Non-member order O002
CALL insert_order_item('O002', '2024-03-01', '13:30:00', 'card', '1234-5678-9012-3456', 'Visa', NULL, 'Pizza Margherita', 'S102');

-- Row 6: Same order
CALL insert_order_item('O002', '2024-03-01', '13:30:00', 'card', '1234-5678-9012-3456', 'Visa', NULL, 'Carbonara', 'S102');

-- Row 7: Member order O003
CALL insert_order_item('O003', '2024-03-02', '11:00:00', 'cash', NULL, NULL, 92345678, 'Sushi', 'S103');

-- Row 8
CALL insert_order_item('O003', '2024-03-02', '11:00:00', 'cash', NULL, NULL, 92345678, 'Ramen', 'S103');

-- Row 9
CALL insert_order_item('O003', '2024-03-02', '11:00:00', 'cash', NULL, NULL, 92345678, 'Sushi', 'S103');

-- Row 10
CALL insert_order_item('O003', '2024-03-02', '11:00:00', 'cash', NULL, NULL, 92345678, 'Ramen', 'S103');

-- Row 11: Order O004
CALL insert_order_item('O004', '2024-03-02', '14:00:00', 'card', '9876-5432-1098-7654', 'Mastercard', 93456789, 'Kung Pao Chicken', 'S104');

-- Row 12
CALL insert_order_item('O005', '2024-03-03', '12:30:00', 'cash', NULL, NULL, NULL, 'Pizza Margherita', 'S102');

-- Row 13
CALL insert_order_item('O006', '2024-03-03', '13:00:00', 'card', '1111-2222-3333-4444', 'Amex', 94567890, 'Rendang', 'S101');

-- Row 14
CALL insert_order_item('O006', '2024-03-03', '13:00:00', 'card', '1111-2222-3333-4444', 'Amex', 94567890, 'Nasi Goreng', 'S101');

-- Row 15
CALL insert_order_item('O007', '2024-03-04', '11:15:00', 'cash', NULL, NULL, 91234567, 'Sushi', 'S103');

-- Row 16-30: Continue pattern
CALL insert_order_item('O007', '2024-03-04', '11:15:00', 'cash', NULL, NULL, 91234567, 'Ramen', 'S103');
CALL insert_order_item('O008', '2024-03-04', '12:00:00', 'card', '5555-6666-7777-8888', 'Visa', NULL, 'Carbonara', 'S102');
CALL insert_order_item('O009', '2024-03-05', '10:00:00', 'cash', NULL, NULL, 92345678, 'Pizza Margherita', 'S102');
CALL insert_order_item('O010', '2024-03-05', '11:30:00', 'cash', NULL, NULL, NULL, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O011', '2024-03-06', '12:00:00', 'card', '4444-3333-2222-1111', 'Mastercard', 93456789, 'Rendang', 'S101');
CALL insert_order_item('O011', '2024-03-06', '12:00:00', 'card', '4444-3333-2222-1111', 'Mastercard', 93456789, 'Nasi Goreng', 'S101');
CALL insert_order_item('O011', '2024-03-06', '12:00:00', 'card', '4444-3333-2222-1111', 'Mastercard', 93456789, 'Sushi', 'S103');
CALL insert_order_item('O011', '2024-03-06', '12:00:00', 'card', '4444-3333-2222-1111', 'Mastercard', 93456789, 'Ramen', 'S103');
CALL insert_order_item('O012', '2024-03-07', '09:00:00', 'cash', NULL, NULL, 94567890, 'Pizza Margherita', 'S102');
CALL insert_order_item('O013', '2024-03-07', '13:00:00', 'cash', NULL, NULL, NULL, 'Rendang', 'S101');
CALL insert_order_item('O014', '2024-03-08', '11:00:00', 'card', '7777-8888-9999-0000', 'Visa', 91234567, 'Carbonara', 'S102');
CALL insert_order_item('O015', '2024-03-08', '14:30:00', 'cash', NULL, NULL, 92345678, 'Sushi', 'S103');
CALL insert_order_item('O016', '2024-03-09', '10:15:00', 'cash', NULL, NULL, NULL, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O017', '2024-03-09', '12:45:00', 'card', '2222-3333-4444-5555', 'Amex', 93456789, 'Nasi Goreng', 'S101');

-- Row 31-50
CALL insert_order_item('O018', '2024-03-10', '11:00:00', 'cash', NULL, NULL, 94567890, 'Ramen', 'S103');
CALL insert_order_item('O018', '2024-03-10', '11:00:00', 'cash', NULL, NULL, 94567890, 'Sushi', 'S103');
CALL insert_order_item('O019', '2024-03-10', '13:00:00', 'cash', NULL, NULL, NULL, 'Pizza Margherita', 'S102');
CALL insert_order_item('O020', '2024-03-11', '12:00:00', 'card', '6666-7777-8888-9999', 'Visa', 91234567, 'Rendang', 'S101');
CALL insert_order_item('O020', '2024-03-11', '12:00:00', 'card', '6666-7777-8888-9999', 'Visa', 91234567, 'Nasi Goreng', 'S101');
CALL insert_order_item('O020', '2024-03-11', '12:00:00', 'card', '6666-7777-8888-9999', 'Visa', 91234567, 'Sushi', 'S103');
CALL insert_order_item('O020', '2024-03-11', '12:00:00', 'card', '6666-7777-8888-9999', 'Visa', 91234567, 'Ramen', 'S103');
CALL insert_order_item('O021', '2024-03-12', '10:30:00', 'cash', NULL, NULL, 92345678, 'Carbonara', 'S102');
CALL insert_order_item('O022', '2024-03-12', '14:00:00', 'cash', NULL, NULL, NULL, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O023', '2024-03-13', '11:15:00', 'card', '3333-4444-5555-6666', 'Mastercard', 93456789, 'Pizza Margherita', 'S102');
CALL insert_order_item('O024', '2024-03-13', '13:30:00', 'cash', NULL, NULL, 94567890, 'Rendang', 'S101');
CALL insert_order_item('O025', '2024-03-14', '09:45:00', 'cash', NULL, NULL, 91234567, 'Sushi', 'S103');
CALL insert_order_item('O025', '2024-03-14', '09:45:00', 'cash', NULL, NULL, 91234567, 'Ramen', 'S103');
CALL insert_order_item('O026', '2024-03-14', '12:00:00', 'card', '8888-9999-0000-1111', 'Visa', NULL, 'Nasi Goreng', 'S101');
CALL insert_order_item('O027', '2024-03-15', '11:30:00', 'cash', NULL, NULL, 92345678, 'Carbonara', 'S102');
CALL insert_order_item('O028', '2024-03-15', '14:15:00', 'cash', NULL, NULL, NULL, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O029', '2024-03-16', '10:00:00', 'card', '4444-5555-6666-7777', 'Amex', 93456789, 'Pizza Margherita', 'S102');
CALL insert_order_item('O030', '2024-03-16', '13:00:00', 'cash', NULL, NULL, 94567890, 'Rendang', 'S101');
CALL insert_order_item('O030', '2024-03-16', '13:00:00', 'cash', NULL, NULL, 94567890, 'Nasi Goreng', 'S101');
CALL insert_order_item('O030', '2024-03-16', '13:00:00', 'cash', NULL, NULL, 94567890, 'Sushi', 'S103');

-- Row 51-70
CALL insert_order_item('O030', '2024-03-16', '13:00:00', 'cash', NULL, NULL, 94567890, 'Ramen', 'S103');
CALL insert_order_item('O031', '2024-03-17', '11:00:00', 'cash', NULL, NULL, 91234567, 'Carbonara', 'S102');
CALL insert_order_item('O032', '2024-03-17', '14:30:00', 'card', '9999-0000-1111-2222', 'Visa', NULL, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O033', '2024-03-18', '10:15:00', 'cash', NULL, NULL, 92345678, 'Pizza Margherita', 'S102');
CALL insert_order_item('O034', '2024-03-18', '12:45:00', 'cash', NULL, NULL, NULL, 'Rendang', 'S101');
CALL insert_order_item('O035', '2024-03-19', '11:30:00', 'card', '5555-6666-7777-8888', 'Mastercard', 93456789, 'Sushi', 'S103');
CALL insert_order_item('O035', '2024-03-19', '11:30:00', 'card', '5555-6666-7777-8888', 'Mastercard', 93456789, 'Ramen', 'S103');
CALL insert_order_item('O036', '2024-03-19', '13:00:00', 'cash', NULL, NULL, 94567890, 'Nasi Goreng', 'S101');
CALL insert_order_item('O037', '2024-03-20', '09:30:00', 'cash', NULL, NULL, 91234567, 'Carbonara', 'S102');
CALL insert_order_item('O037', '2024-03-20', '09:30:00', 'cash', NULL, NULL, 91234567, 'Pizza Margherita', 'S102');
CALL insert_order_item('O038', '2024-03-20', '12:00:00', 'card', '7777-8888-9999-0000', 'Visa', NULL, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O039', '2024-03-21', '11:15:00', 'cash', NULL, NULL, 92345678, 'Rendang', 'S101');
CALL insert_order_item('O040', '2024-03-21', '14:00:00', 'cash', NULL, NULL, NULL, 'Sushi', 'S103');
CALL insert_order_item('O041', '2024-03-22', '10:30:00', 'card', '1111-2222-3333-4444', 'Amex', 93456789, 'Ramen', 'S103');
CALL insert_order_item('O041', '2024-03-22', '10:30:00', 'card', '1111-2222-3333-4444', 'Amex', 93456789, 'Sushi', 'S103');
CALL insert_order_item('O041', '2024-03-22', '10:30:00', 'card', '1111-2222-3333-4444', 'Amex', 93456789, 'Nasi Goreng', 'S101');
CALL insert_order_item('O041', '2024-03-22', '10:30:00', 'card', '1111-2222-3333-4444', 'Amex', 93456789, 'Rendang', 'S101');
CALL insert_order_item('O042', '2024-03-22', '13:30:00', 'cash', NULL, NULL, 94567890, 'Pizza Margherita', 'S102');
CALL insert_order_item('O043', '2024-03-23', '11:00:00', 'cash', NULL, NULL, 91234567, 'Carbonara', 'S102');
CALL insert_order_item('O044', '2024-03-23', '14:15:00', 'card', '2222-3333-4444-5555', 'Visa', NULL, 'Kung Pao Chicken', 'S104');

-- Row 71-90
CALL insert_order_item('O045', '2024-03-24', '10:00:00', 'cash', NULL, NULL, 92345678, 'Rendang', 'S101');
CALL insert_order_item('O045', '2024-03-24', '10:00:00', 'cash', NULL, NULL, 92345678, 'Nasi Goreng', 'S101');
CALL insert_order_item('O046', '2024-03-24', '12:30:00', 'cash', NULL, NULL, NULL, 'Sushi', 'S103');
CALL insert_order_item('O047', '2024-03-25', '11:45:00', 'card', '6666-7777-8888-9999', 'Mastercard', 93456789, 'Ramen', 'S103');
CALL insert_order_item('O048', '2024-03-25', '13:00:00', 'cash', NULL, NULL, 94567890, 'Pizza Margherita', 'S102');
CALL insert_order_item('O049', '2024-03-26', '09:30:00', 'cash', NULL, NULL, 91234567, 'Carbonara', 'S102');
CALL insert_order_item('O049', '2024-03-26', '09:30:00', 'cash', NULL, NULL, 91234567, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O050', '2024-03-26', '12:00:00', 'card', '3333-4444-5555-6666', 'Visa', NULL, 'Rendang', 'S101');
CALL insert_order_item('O051', '2024-03-27', '11:15:00', 'cash', NULL, NULL, 92345678, 'Nasi Goreng', 'S101');
CALL insert_order_item('O051', '2024-03-27', '11:15:00', 'cash', NULL, NULL, 92345678, 'Sushi', 'S103');
CALL insert_order_item('O051', '2024-03-27', '11:15:00', 'cash', NULL, NULL, 92345678, 'Ramen', 'S103');
CALL insert_order_item('O051', '2024-03-27', '11:15:00', 'cash', NULL, NULL, 92345678, 'Pizza Margherita', 'S102');
CALL insert_order_item('O052', '2024-03-27', '14:00:00', 'cash', NULL, NULL, NULL, 'Carbonara', 'S102');
CALL insert_order_item('O053', '2024-03-28', '10:30:00', 'card', '8888-9999-0000-1111', 'Amex', 93456789, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O054', '2024-03-28', '13:30:00', 'cash', NULL, NULL, 94567890, 'Rendang', 'S101');
CALL insert_order_item('O055', '2024-03-29', '11:00:00', 'cash', NULL, NULL, 91234567, 'Sushi', 'S103');
CALL insert_order_item('O056', '2024-03-29', '14:15:00', 'card', '4444-5555-6666-7777', 'Visa', NULL, 'Ramen', 'S103');
CALL insert_order_item('O057', '2024-03-30', '10:00:00', 'cash', NULL, NULL, 92345678, 'Pizza Margherita', 'S102');
CALL insert_order_item('O057', '2024-03-30', '10:00:00', 'cash', NULL, NULL, 92345678, 'Carbonara', 'S102');
CALL insert_order_item('O058', '2024-03-30', '12:45:00', 'cash', NULL, NULL, NULL, 'Nasi Goreng', 'S101');

-- Row 91-100
CALL insert_order_item('O059', '2024-03-31', '11:30:00', 'card', '9999-0000-1111-2222', 'Mastercard', 93456789, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O059', '2024-03-31', '11:30:00', 'card', '9999-0000-1111-2222', 'Mastercard', 93456789, 'Rendang', 'S101');
CALL insert_order_item('O060', '2024-03-31', '13:00:00', 'cash', NULL, NULL, 94567890, 'Sushi', 'S103');
CALL insert_order_item('O060', '2024-03-31', '13:00:00', 'cash', NULL, NULL, 94567890, 'Ramen', 'S103');
CALL insert_order_item('O060', '2024-03-31', '13:00:00', 'cash', NULL, NULL, 94567890, 'Pizza Margherita', 'S102');
CALL insert_order_item('O060', '2024-03-31', '13:00:00', 'cash', NULL, NULL, 94567890, 'Carbonara', 'S102');
CALL insert_order_item('O061', '2024-04-01', '09:30:00', 'cash', NULL, NULL, 91234567, 'Nasi Goreng', 'S101');
CALL insert_order_item('O062', '2024-04-01', '12:00:00', 'card', '5555-6666-7777-8888', 'Visa', NULL, 'Kung Pao Chicken', 'S104');
CALL insert_order_item('O063', '2024-04-02', '11:15:00', 'cash', NULL, NULL, 92345678, 'Rendang', 'S101');
CALL insert_order_item('O064', '2024-04-02', '14:00:00', 'cash', NULL, NULL, NULL, 'Sushi', 'S103');


-- ====================================================================
-- VERIFICATION QUERIES
-- ====================================================================

-- Total orders created
SELECT 'Total Food_Order records' AS description, COUNT(*) AS count 
FROM Food_Order;

-- Total items prepared
SELECT 'Total Prepare records' AS description, COUNT(*) AS count 
FROM Prepare;

-- Member vs non-member distribution
SELECT 
    CASE 
        WHEN ob.order_id IS NOT NULL THEN 'Member Order' 
        ELSE 'Non-Member Order' 
    END AS order_type,
    COUNT(*) AS count
FROM Food_Order fo
LEFT JOIN Ordered_By ob ON fo.id = ob.order_id
GROUP BY (ob.order_id IS NOT NULL)
ORDER BY order_type;

-- Sample orders with pricing details
SELECT 
    fo.id AS order_id,
    fo.date,
    SUM(i.price * p.qty) AS base_total,
    fo.total_price AS final_price,
    SUM(p.qty) AS total_items,
    EXISTS(SELECT 1 FROM Ordered_By WHERE order_id = fo.id) AS is_member,
    CASE 
        WHEN EXISTS(SELECT 1 FROM Ordered_By WHERE order_id = fo.id) 
             AND SUM(p.qty) >= 4 
        THEN '$2 Discount Applied'
        ELSE 'No Discount'
    END AS discount_status
FROM Food_Order fo
JOIN Prepare p ON fo.id = p.order_id
JOIN Item i ON p.item = i.name
GROUP BY fo.id, fo.date, fo.total_price
ORDER BY fo.date, fo.time
LIMIT 15;

-- Verify discount calculations
SELECT 
    fo.id,
    SUM(i.price * p.qty) AS calculated_base,
    fo.total_price AS stored_price,
    SUM(p.qty) AS item_count,
    EXISTS(SELECT 1 FROM Ordered_By WHERE order_id = fo.id) AS is_member,
    CASE 
        WHEN EXISTS(SELECT 1 FROM Ordered_By WHERE order_id = fo.id) AND SUM(p.qty) >= 4 
        THEN SUM(i.price * p.qty) - 2 
        ELSE SUM(i.price * p.qty) 
    END AS expected_price,
    CASE 
        WHEN fo.total_price = CASE 
            WHEN EXISTS(SELECT 1 FROM Ordered_By WHERE order_id = fo.id) AND SUM(p.qty) >= 4 
            THEN SUM(i.price * p.qty) - 2 
            ELSE SUM(i.price * p.qty) 
        END THEN '✓ Correct'
        ELSE '✗ ERROR'
    END AS validation
FROM Food_Order fo
JOIN Prepare p ON fo.id = p.order_id
JOIN Item i ON p.item = i.name
GROUP BY fo.id, fo.total_price
ORDER BY fo.id
LIMIT 20;

-- Summary statistics
SELECT 
    'Orders with discount applied' AS metric,
    COUNT(*) AS value
FROM Food_Order fo
WHERE EXISTS(SELECT 1 FROM Ordered_By WHERE order_id = fo.id)
  AND (SELECT SUM(qty) FROM Prepare WHERE order_id = fo.id) >= 4
UNION ALL
SELECT 
    'Total member orders',
    COUNT(*)
FROM Ordered_By
UNION ALL
SELECT 
    'Total non-member orders',
    COUNT(*)
FROM Food_Order
WHERE id NOT IN (SELECT order_id FROM Ordered_By);