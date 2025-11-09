-- Example calls using the procedure
-- (You'll adapt this based on your actual order.csv data)

-- Row 1: Member order
CALL insert_order_item(
    '20240301001',           -- order_id
    '2024-03-01',           -- date
    '11:30:00',             -- time
    'cash',                 -- payment_method
    NULL,                   -- card
    NULL,                   -- card_type
    91234567,               -- member_phone
    'Pho',                  -- item
    'STAFF-01'              -- staff
);

-- Row 2: Add another item to same order
CALL insert_order_item(
    '20240301001',
    '2024-03-01',
    '11:30:00',
    'cash',
    NULL,
    NULL,
    91234567,
    'Bun Cha',
    'STAFF-01'
);

-- Row 3: Non-member order
CALL insert_order_item(
    '20240301002',
    '2024-03-01',
    '12:00:00',
    'card',
    '1111-2222-3333-4444',
    'Visa',
    NULL,                   -- No member
    'Pizza',
    'STAFF-02'
);

-- Continue for 100 rows...
-- (Adapt from your order.csv - each row is one procedure call)

-- Verify insertions
SELECT 'Total Orders' AS metric, COUNT(*) AS value FROM Food_Order
UNION ALL
SELECT 'Total Items', COUNT(*) FROM Prepare
UNION ALL
SELECT 'Member Orders', COUNT(*) FROM Ordered_By;

-- Check some total_price calculations
SELECT id, total_price, 
       (SELECT SUM(qty) FROM Prepare WHERE order_id = Food_Order.id) AS item_count
FROM Food_Order
ORDER BY id
LIMIT 10;