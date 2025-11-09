CREATE OR REPLACE PROCEDURE insert_order_item(
    p_order_id VARCHAR(256),
    p_date DATE,
    p_time TIME,
    p_payment_method VARCHAR(10),
    p_card VARCHAR(256),
    p_card_type VARCHAR(256),
    p_member_phone INTEGER,
    p_item VARCHAR(256),
    p_staff VARCHAR(256)
)
LANGUAGE plpgsql
AS $$
DECLARE
    order_exists BOOLEAN;
    member_exists BOOLEAN := FALSE;
    item_exists BOOLEAN;
    staff_exists BOOLEAN;
    cuisine_name VARCHAR(256);
    staff_can_cook BOOLEAN;
BEGIN
    -- 1. Validate item exists
    SELECT EXISTS(SELECT 1 FROM Item WHERE name = p_item)
    INTO item_exists;
    
    IF NOT item_exists THEN
        RAISE EXCEPTION 'Item % does not exist', p_item;
    END IF;

    -- 2. Validate staff exists
    SELECT EXISTS(SELECT 1 FROM Staff WHERE id = p_staff)
    INTO staff_exists;
    
    IF NOT staff_exists THEN
        RAISE EXCEPTION 'Staff % does not exist', p_staff;
    END IF;

    -- 3. Create order if it doesn't exist
    SELECT EXISTS(SELECT 1 FROM Food_Order WHERE id = p_order_id)
    INTO order_exists;

    IF NOT order_exists THEN
        -- Validate payment method
        IF p_payment_method = 'card' THEN
            IF p_card IS NULL OR p_card_type IS NULL THEN
                RAISE EXCEPTION 'Card number and type required for card payments';
            END IF;
        ELSIF p_payment_method = 'cash' THEN
            IF p_card IS NOT NULL OR p_card_type IS NOT NULL THEN
                RAISE EXCEPTION 'Card information must be NULL for cash payments';
            END IF;
        ELSE
            RAISE EXCEPTION 'Invalid payment method: % (must be card or cash)', p_payment_method;
        END IF;

        INSERT INTO Food_Order (id, date, time, payment_method, card, card_type, total_price)
        VALUES (p_order_id, p_date, p_time, p_payment_method, p_card, p_card_type, 0);
    END IF;

    -- 4. Link to member if provided
    IF p_member_phone IS NOT NULL THEN
        SELECT EXISTS(SELECT 1 FROM Member WHERE phone = p_member_phone)
        INTO member_exists;

        IF NOT member_exists THEN
            RAISE EXCEPTION 'Member with phone % does not exist', p_member_phone;
        END IF;

        -- Create member link if doesn't exist
        IF NOT EXISTS (SELECT 1 FROM Ordered_By WHERE order_id = p_order_id) THEN
            INSERT INTO Ordered_By (order_id, member)
            VALUES (p_order_id, p_member_phone);
        END IF;
    END IF;

    -- 5. Validate staff can cook item's cuisine
    SELECT cuisine INTO cuisine_name FROM Item WHERE name = p_item;

    SELECT EXISTS(
        SELECT 1 FROM Cook WHERE staff = p_staff AND cuisine = cuisine_name
    ) INTO staff_can_cook;

    IF NOT staff_can_cook THEN
        RAISE EXCEPTION 'Staff % cannot cook cuisine % for item %', 
            p_staff, cuisine_name, p_item;
    END IF;

    -- 6. Insert or update Prepare record
    IF EXISTS (
        SELECT 1 FROM Prepare 
        WHERE order_id = p_order_id AND item = p_item AND staff = p_staff
    ) THEN
        -- Increment quantity if same item+staff combination exists
        UPDATE Prepare
        SET qty = qty + 1
        WHERE order_id = p_order_id AND item = p_item AND staff = p_staff;
    ELSE
        -- Insert new item
        INSERT INTO Prepare (order_id, item, staff, qty)
        VALUES (p_order_id, p_item, p_staff, 1);
    END IF;

    -- Note: total_price auto-updates via Constraint 4 trigger
END;
$$;