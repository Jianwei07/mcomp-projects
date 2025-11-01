-- Set the session to execute constraints immediately for testing
SET CONSTRAINTS ALL IMMEDIATE;

-- ====================================================================
-- CONSTRAINT 1: Each order should have at least one item.
-- ====================================================================

-- Function 1.1: Checks if an order still has items after deletion
CREATE OR REPLACE FUNCTION check_order_min_items()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' AND (SELECT COUNT(*) FROM Prepare WHERE order_id = OLD.order_id) = 0 THEN
        IF EXISTS (SELECT 1 FROM Food_Order WHERE id = OLD.order_id) THEN
            RAISE EXCEPTION 'Constraint 1 Violation: Order % must have at least one item.', OLD.order_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger 1.1: Prevents deleting the last item from an existing order.
CREATE TRIGGER trg_check_prepare_delete_min_items
AFTER DELETE ON Prepare
FOR EACH ROW
EXECUTE FUNCTION check_order_min_items();


-- ====================================================================
-- CONSTRAINT 2: Staff should be able to cook the item’s cuisine.
-- ====================================================================

-- Function 2.1: Checks if a staff can cook an item's cuisine
-- Trigger 2.1: Enforce constraint on INSERT/UPDATE to Prepare

-- 🟢 FIX: Safely drop the existing trigger before recreating it
DROP TRIGGER IF EXISTS trg_check_prepare_cuisine ON Prepare;

CREATE CONSTRAINT TRIGGER trg_check_prepare_cuisine
AFTER INSERT OR UPDATE OF staff, item ON Prepare
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_staff_cuisine_capability();

-- Trigger 2.1: Enforce constraint on INSERT/UPDATE to Prepare
CREATE CONSTRAINT TRIGGER trg_check_prepare_cuisine
AFTER INSERT OR UPDATE OF staff, item ON Prepare
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_staff_cuisine_capability();


-- ====================================================================
-- CONSTRAINT 3: MEMBER CANNOT ORDER BEFORE REGISTRATION
-- ====================================================================

DROP TRIGGER IF EXISTS trg_check_order_member_time ON Ordered_By;

CREATE TRIGGER trg_check_order_member_time
BEFORE INSERT OR UPDATE ON Ordered_By
FOR EACH ROW
EXECUTE FUNCTION check_order_member_time();


CREATE OR REPLACE FUNCTION check_order_member_time()
RETURNS TRIGGER AS $$
DECLARE
    reg_datetime TIMESTAMP;
    order_datetime TIMESTAMP;
BEGIN
    SELECT (date::TIMESTAMP + time::INTERVAL)
    INTO order_datetime
    FROM Food_Order
    WHERE id = NEW.order_id;

    SELECT (reg_date::TIMESTAMP + reg_time::INTERVAL)
    INTO reg_datetime
    FROM Member
    WHERE phone = NEW.member;

    IF order_datetime < reg_datetime THEN
        RAISE EXCEPTION
        'Constraint 3 Violation: Order time (%) precedes member registration time (%)',
        order_datetime, reg_datetime;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;




-- ====================================================================
-- CONSTRAINT 4: total_price should be correctly computed (with $2 discount).
-- ====================================================================

-- Function 4.1: Core logic to calculate and update total_price
CREATE OR REPLACE FUNCTION update_order_total_price_for_id(p_order_id VARCHAR)
RETURNS VOID AS $$
DECLARE
    new_total_price NUMERIC;
    base_sum NUMERIC;
    total_qty INT;
    is_member BOOLEAN;
BEGIN
    SELECT 
        COALESCE(SUM(I.price * P.qty), 0),
        COALESCE(SUM(P.qty), 0)
    INTO base_sum, total_qty
    FROM Prepare P JOIN Item I ON P.item = I.name
    WHERE P.order_id = p_order_id;

    SELECT EXISTS (SELECT 1 FROM Ordered_By WHERE order_id = p_order_id)
    INTO is_member;

    -- Apply $2 discount if member AND total items >= 4
    IF is_member AND total_qty >= 4 THEN
        new_total_price := base_sum - 2.00;
    ELSE
        new_total_price := base_sum;
    END IF;

    IF new_total_price < 0 THEN new_total_price := 0; END IF;

    UPDATE Food_Order
    SET total_price = new_total_price
    WHERE id = p_order_id AND total_price IS DISTINCT FROM new_total_price;
END;
$$ LANGUAGE plpgsql;

-- Function 4.2: Wrapper to call 4.1 from Prepare/Item triggers
CREATE OR REPLACE FUNCTION update_order_total_price()
RETURNS TRIGGER AS $$
DECLARE
    order_id_to_update VARCHAR(256);
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        order_id_to_update := NEW.order_id;
    ELSIF TG_OP = 'DELETE' THEN
        order_id_to_update := OLD.order_id;
    END IF;

    PERFORM update_order_total_price_for_id(order_id_to_update);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger 4.1: Update total_price after INSERT/UPDATE/DELETE on Prepare
CREATE TRIGGER trg_update_prepare_total_price
AFTER INSERT OR UPDATE OR DELETE ON Prepare
FOR EACH ROW
EXECUTE FUNCTION update_order_total_price();

-- Function 4.3: Wrapper for Item price update (handles multiple orders)
CREATE OR REPLACE FUNCTION update_order_total_price_on_item_update()
RETURNS TRIGGER AS $$
DECLARE
    affected_order_id VARCHAR(256);
BEGIN
    IF OLD.price IS DISTINCT FROM NEW.price THEN
        FOR affected_order_id IN 
            SELECT DISTINCT P.order_id FROM Prepare P WHERE P.item = NEW.name
        LOOP
            PERFORM update_order_total_price_for_id(affected_order_id);
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger 4.2: Update total_price after UPDATE on Item price
CREATE TRIGGER trg_update_item_price
AFTER UPDATE OF price ON Item
FOR EACH ROW
EXECUTE FUNCTION update_order_total_price_on_item_update();