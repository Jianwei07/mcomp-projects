-- ====================================================================
-- CONSTRAINT 1: Each order must have at least one item
-- ====================================================================

CREATE OR REPLACE FUNCTION check_order_has_item()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Prepare WHERE order_id = OLD.order_id) THEN
        RAISE EXCEPTION 'Constraint 1 Violation: Order % must have at least one item', OLD.order_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER ensure_order_has_item
AFTER DELETE ON Prepare
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_order_has_item();


-- ====================================================================
-- CONSTRAINT 2: Staff must be able to cook the item's cuisine
-- ====================================================================

CREATE OR REPLACE FUNCTION check_staff_can_cook()
RETURNS TRIGGER AS $$
DECLARE
    item_cuisine VARCHAR(256);
BEGIN
    SELECT cuisine INTO item_cuisine FROM Item WHERE name = NEW.item;

    IF NOT EXISTS (
        SELECT 1 FROM Cook
        WHERE staff = NEW.staff AND cuisine = item_cuisine
    ) THEN
        RAISE EXCEPTION 'Constraint 2 Violation: Staff % cannot cook cuisine % for item %',
            NEW.staff, item_cuisine, NEW.item;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_staff_can_cook
BEFORE INSERT OR UPDATE ON Prepare
FOR EACH ROW
EXECUTE FUNCTION check_staff_can_cook();


-- ====================================================================
-- CONSTRAINT 3: Order date/time >= member registration date/time
-- ====================================================================

CREATE OR REPLACE FUNCTION check_order_after_registration()
RETURNS TRIGGER AS $$
DECLARE
    reg_ts TIMESTAMP;
    order_ts TIMESTAMP;
BEGIN
    SELECT (reg_date + reg_time) INTO reg_ts 
    FROM Member WHERE phone = NEW.member;
    
    SELECT (date + time) INTO order_ts 
    FROM Food_Order WHERE id = NEW.order_id;

    IF order_ts < reg_ts THEN
        RAISE EXCEPTION 'Constraint 3 Violation: Order % occurs before registration of member %',
            NEW.order_id, NEW.member;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_order_after_registration
BEFORE INSERT OR UPDATE ON Ordered_By
FOR EACH ROW
EXECUTE FUNCTION check_order_after_registration();


-- ====================================================================
-- CONSTRAINT 4: Maintain correct total_price (with $2 discount)
-- ====================================================================

CREATE OR REPLACE FUNCTION update_order_total_price()
RETURNS TRIGGER AS $$
DECLARE
    item_sum NUMERIC := 0;
    total_qty INT := 0;
    is_member BOOLEAN := FALSE;
    discount NUMERIC := 0;
    order_id_val VARCHAR(256);
BEGIN
    -- Determine affected order ID
    order_id_val := COALESCE(NEW.order_id, OLD.order_id);

    -- Calculate subtotal and total quantity
    SELECT COALESCE(SUM(i.price * p.qty), 0),
           COALESCE(SUM(p.qty), 0)
    INTO item_sum, total_qty
    FROM Prepare p
    JOIN Item i ON p.item = i.name
    WHERE p.order_id = order_id_val;

    -- Check if member order
    SELECT EXISTS(SELECT 1 FROM Ordered_By WHERE order_id = order_id_val)
    INTO is_member;

    -- Apply $2 discount if member AND >= 4 items
    IF is_member AND total_qty >= 4 THEN
        discount := 2;
    ELSE
        discount := 0;
    END IF;

    -- Update total_price
    UPDATE Food_Order
    SET total_price = GREATEST(item_sum - discount, 0)
    WHERE id = order_id_val;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Recalculate after Prepare changes
CREATE TRIGGER trg_update_total_price
AFTER INSERT OR UPDATE OR DELETE ON Prepare
FOR EACH ROW
EXECUTE FUNCTION update_order_total_price();

-- Recalculate after Ordered_By changes (member status change)
CREATE TRIGGER trg_recalc_price_on_ordered_by_change
AFTER INSERT OR DELETE ON Ordered_By
FOR EACH ROW
EXECUTE FUNCTION update_order_total_price();


-- ====================================================================
-- ADDITIONAL CONSTRAINT: Prevent deleting Members with order history
-- ====================================================================

CREATE OR REPLACE FUNCTION prevent_member_deletion_with_orders()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Ordered_By WHERE member = OLD.phone) THEN
        RAISE EXCEPTION 'Cannot delete member %: has existing orders', OLD.phone;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_member_deletion
BEFORE DELETE ON Member
FOR EACH ROW
EXECUTE FUNCTION prevent_member_deletion_with_orders();