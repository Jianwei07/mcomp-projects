CREATE OR REPLACE PROCEDURE insert_order_item(
    p_order_id VARCHAR(256),
    p_date DATE,
    p_time TIME,
    p_payment VARCHAR(10),
    p_card VARCHAR(256),
    p_card_type VARCHAR(256),
    p_member_phone INTEGER,
    p_item VARCHAR(256),
    p_staff VARCHAR(256)
) AS $$
BEGIN
    -- Create order if not exists
    INSERT INTO Food_Order (id, date, time, payment_method, card, card_type, total_price)
    VALUES (p_order_id, p_date, p_time, p_payment, p_card, p_card_type, 0)
    ON CONFLICT (id) DO NOTHING;
    
    -- Link to member if provided
    IF p_member_phone IS NOT NULL THEN
        INSERT INTO Ordered_By (order_id, member)
        VALUES (p_order_id, p_member_phone)
        ON CONFLICT (order_id) DO NOTHING;
    END IF;
    
    -- Add item (increment qty if already exists)
    INSERT INTO Prepare (order_id, item, staff, qty)
    VALUES (p_order_id, p_item, p_staff, 1)
    ON CONFLICT (order_id, item, staff) 
    DO UPDATE SET qty = Prepare.qty + 1;
    
    -- Total price updated automatically by trigger
END;
$$ LANGUAGE plpgsql;