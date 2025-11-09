--------------------------------------------------
-- CONSTRAINT 1: Each order must have at least one item
--------------------------------------------------

DROP FUNCTION IF EXISTS check_order_min_items();
CREATE OR REPLACE FUNCTION check_order_min_items()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' AND (SELECT COUNT(*) FROM Prepare WHERE order_id = OLD.order_id) = 0 THEN
        IF EXISTS (SELECT 1 FROM Food_Order WHERE id = OLD.order_id) THEN
            RAISE EXCEPTION 'Constraint 1 Violation: Order % must have at least one item.', OLD.order_id;
        END IF;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_prepare_delete_min_items ON Prepare;
CREATE TRIGGER trg_check_prepare_delete_min_items
AFTER DELETE ON Prepare
FOR EACH ROW
EXECUTE FUNCTION check_order_min_items();

--------------------------------------------------
-- CONSTRAINT 2: Staff must be qualified to cook the item’s cuisine
--------------------------------------------------

DROP FUNCTION IF EXISTS check_staff_can_cook();
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
        RAISE EXCEPTION 'Staff % cannot cook cuisine % for item %', NEW.staff, item_cuisine, NEW.item;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_staff_can_cook ON Prepare;
CREATE TRIGGER trg_check_staff_can_cook
BEFORE INSERT OR UPDATE ON Prepare
FOR EACH ROW
EXECUTE FUNCTION check_staff_can_cook();

DROP FUNCTION IF EXISTS prevent_cook_delete();
CREATE OR REPLACE FUNCTION prevent_cook_delete()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Prepare p
        JOIN Item i ON p.item = i.name
        WHERE p.staff = OLD.staff AND i.cuisine = OLD.cuisine
    ) THEN
        RAISE EXCEPTION 
            'Cannot modify Cook record for % %, still preparing dishes',
            OLD.staff, OLD.cuisine;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_prevent_cook_delete ON Cook;
CREATE TRIGGER trg_prevent_cook_delete
BEFORE DELETE OR UPDATE ON Cook
FOR EACH ROW
EXECUTE FUNCTION prevent_cook_delete();

DROP FUNCTION IF EXISTS check_item_cuisine_update();
CREATE OR REPLACE FUNCTION check_item_cuisine_update()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Prepare p
        WHERE p.item = OLD.name
          AND NOT EXISTS (
              SELECT 1
              FROM Cook c
              WHERE c.staff = p.staff
                AND c.cuisine = NEW.cuisine
          )
    ) THEN
        RAISE EXCEPTION 'Changing cuisine of item % to % causes invalid staff assignments.', OLD.name, NEW.cuisine;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_item_cuisine_update ON Item;
CREATE TRIGGER trg_check_item_cuisine_update
BEFORE UPDATE OF cuisine ON Item
FOR EACH ROW
EXECUTE FUNCTION check_item_cuisine_update();

--------------------------------------------------
-- CONSTRAINT 3: Order’s date/time must not precede member’s registration
--------------------------------------------------

DROP FUNCTION IF EXISTS order_member();
CREATE OR REPLACE FUNCTION order_member()
RETURNS TRIGGER AS $$
DECLARE
 v_reg_datetime TIMESTAMP;
 v_order_datetime TIMESTAMP;
BEGIN
 SELECT reg_date + reg_time INTO v_reg_datetime
 FROM Member a
 WHERE a.phone = NEW.member
 LIMIT 1;

 SELECT date + time INTO v_order_datetime
 FROM Food_Order b
 WHERE b.id = NEW.order_id
 LIMIT 1;

 IF v_order_datetime < v_reg_datetime THEN
  RAISE EXCEPTION 'Invalid order - Order on % is before member registration on %', v_order_datetime, v_reg_datetime;
 END IF;

 RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS order_member_trigger ON ordered_by;
CREATE CONSTRAINT TRIGGER order_member_trigger
AFTER INSERT OR UPDATE ON ordered_by
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION order_member();

DROP FUNCTION IF EXISTS order_date();
CREATE OR REPLACE FUNCTION order_date()
RETURNS TRIGGER AS $$
DECLARE
 v_reg_datetime TIMESTAMP;
 v_order_datetime TIMESTAMP;
BEGIN
 SELECT a.date + a.time, c.reg_date + c.reg_time
 INTO v_order_datetime, v_reg_datetime
 FROM food_order a
 JOIN ordered_by b ON a.id = b.order_id
 JOIN member c ON b.member = c.phone
 WHERE a.id = OLD.id
 ORDER BY a.date + a.time
 LIMIT 1;

 IF v_order_datetime < v_reg_datetime THEN
  RAISE EXCEPTION 'Order date cannot be updated to % as it lies before member registration date %', v_order_datetime, v_reg_datetime;
 END IF;
 RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS order_date_trigger ON food_order;
CREATE CONSTRAINT TRIGGER order_date_trigger
AFTER UPDATE ON food_order
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION order_date();

DROP FUNCTION IF EXISTS reg_date();
CREATE OR REPLACE FUNCTION reg_date()
RETURNS TRIGGER AS $$
DECLARE
 v_reg_datetime TIMESTAMP;
 v_order_datetime TIMESTAMP;
BEGIN
 SELECT a.date + a.time, c.reg_date + c.reg_time
 INTO v_order_datetime, v_reg_datetime
 FROM food_order a
 JOIN ordered_by b ON a.id = b.order_id
 JOIN member c ON b.member = c.phone
 WHERE c.phone = OLD.phone
 ORDER BY a.date + a.time
 LIMIT 1;

 IF v_order_datetime < v_reg_datetime THEN
  RAISE EXCEPTION 'Member registration date cannot be updated to % as it lies after order date %', v_reg_datetime, v_order_datetime;
 END IF;
 RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS reg_date_trigger ON member;
CREATE CONSTRAINT TRIGGER reg_date_trigger
AFTER UPDATE ON member
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION reg_date();

--------------------------------------------------
-- CONSTRAINT 4: total_price must equal sum(items) - discount
--------------------------------------------------

--If someone inserts, updates, or deletes from Prepare or from Ordered_By, recalcualte the total price (with discounts if applies).
CREATE OR REPLACE FUNCTION update_order_total_price()
RETURNS TRIGGER AS $$
DECLARE
    item_sum NUMERIC := 0;
    total_qty INT := 0;
    is_member BOOLEAN := FALSE;
    discount NUMERIC := 0;
    order_id_val VARCHAR(256);
BEGIN
    -- Determine the affected order ID
    order_id_val := COALESCE(NEW.order_id, OLD.order_id);

    -- Calculate subtotal and total item quantity
    SELECT COALESCE(SUM(i.price * p.qty), 0),
           COALESCE(SUM(p.qty), 0)
    INTO item_sum, total_qty
    FROM Prepare p
    JOIN Item i ON p.item = i.name
    WHERE p.order_id = order_id_val;

    -- Check if this order is placed by a member
    SELECT EXISTS(SELECT 1 FROM Ordered_By WHERE order_id = order_id_val)
    INTO is_member;

    -- Apply discount if conditions are met
    IF is_member AND total_qty >= 4 THEN
        discount := 2;
    ELSE
        discount := 0;
    END IF;

    -- Update total_price in Food_Order
    UPDATE Food_Order
    SET total_price = GREATEST(item_sum - discount, 0)
    WHERE id = order_id_val;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Recalculate after Prepare change
CREATE TRIGGER trg_update_total_price
AFTER INSERT OR UPDATE OR DELETE ON Prepare
FOR EACH ROW
EXECUTE FUNCTION update_order_total_price();

-- Recalculate after Ordered_By change
CREATE TRIGGER trg_recalc_price_on_ordered_by_change
AFTER INSERT OR UPDATE OR DELETE ON Ordered_By
FOR EACH ROW
EXECUTE FUNCTION update_order_total_price();