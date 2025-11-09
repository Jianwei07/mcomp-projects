-- ============================================
-- CONSTRAINT 1: Each order must have at least one item
-- ============================================
CREATE OR REPLACE FUNCTION check_min_one_item()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Prepare WHERE order_id = OLD.order_id
    ) THEN
        RAISE EXCEPTION 'Order must have at least one item';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER trg_min_one_item
AFTER DELETE ON Prepare
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_min_one_item();


-- ============================================
-- CONSTRAINT 2: Staff must be able to cook the item's cuisine
-- ============================================
CREATE OR REPLACE FUNCTION check_staff_cuisine()
RETURNS TRIGGER AS $$
DECLARE
    item_cuisine VARCHAR(256);
BEGIN
    SELECT cuisine INTO item_cuisine FROM Item WHERE name = NEW.item;
    
    IF NOT EXISTS (
        SELECT 1 FROM Cook 
        WHERE staff = NEW.staff AND cuisine = item_cuisine
    ) THEN
        RAISE EXCEPTION 'Staff cannot cook this cuisine';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER trg_staff_cuisine
AFTER INSERT OR UPDATE ON Prepare
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_staff_cuisine();


-- ============================================
-- CONSTRAINT 3: Order date/time must be after member registration
-- ============================================
CREATE OR REPLACE FUNCTION check_order_after_registration()
RETURNS TRIGGER AS $$
DECLARE
    order_dt TIMESTAMP;
    reg_dt TIMESTAMP;
BEGIN
    SELECT (date + time) INTO order_dt 
    FROM Food_Order WHERE id = NEW.order_id;
    
    SELECT (reg_date + reg_time) INTO reg_dt 
    FROM Member WHERE phone = NEW.member;
    
    IF order_dt < reg_dt THEN
        RAISE EXCEPTION 'Order date/time before member registration';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER trg_order_after_reg
AFTER INSERT OR UPDATE ON Ordered_By
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_order_after_registration();


-- ============================================
-- CONSTRAINT 4: Total price must be correct (with discount)
-- ============================================
CREATE OR REPLACE FUNCTION update_total_price()
RETURNS TRIGGER AS $$
DECLARE
    oid VARCHAR(256);
    total NUMERIC;
    cnt INTEGER;
    is_member BOOLEAN;
BEGIN
    -- Get affected order_id
    IF TG_OP = 'DELETE' THEN
        oid := OLD.order_id;
    ELSE
        oid := NEW.order_id;
    END IF;
    
    -- Calculate sum(price * qty)
    SELECT COALESCE(SUM(i.price * p.qty), 0), COALESCE(SUM(p.qty), 0)
    INTO total, cnt
    FROM Prepare p JOIN Item i ON p.item = i.name
    WHERE p.order_id = oid;
    
    -- Check if member
    is_member := EXISTS(SELECT 1 FROM Ordered_By WHERE order_id = oid);
    
    -- Apply $2 discount if member AND >= 4 items
    IF is_member AND cnt >= 4 THEN
        total := total - 2;
    END IF;
    
    -- Update Food_Order
    UPDATE Food_Order SET total_price = total WHERE id = oid;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER trg_update_price_prepare
AFTER INSERT OR UPDATE OR DELETE ON Prepare
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION update_total_price();

CREATE CONSTRAINT TRIGGER trg_update_price_ordered_by
AFTER INSERT OR DELETE ON Ordered_By
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION update_total_price();