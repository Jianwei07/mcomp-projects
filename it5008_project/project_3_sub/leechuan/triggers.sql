--------------------------------------------------
-- CONSTRAINT 1: Each order must have at least one item
--------------------------------------------------

--If someone deletes from prepare, check that the order has at least one item
CREATE OR REPLACE FUNCTION check_order_has_item()
RETURNS TRIGGER AS $$
BEGIN
    -- After deleting a Prepare row, check if that order still has items
    IF NOT EXISTS (SELECT 1 FROM Prepare WHERE order_id = OLD.order_id) THEN
        RAISE EXCEPTION 'Order % must have at least one item.', OLD.order_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER ensure_order_has_item
AFTER DELETE ON Prepare
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_order_has_item();

--------------------------------------------------
-- CONSTRAINT 2: Staff must be qualified to cook the item’s cuisine
--------------------------------------------------

--If someone inserts or updates prepare, check if staff can indeed cook that cuisine
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
        RAISE EXCEPTION
        'Staff % cannot cook cuisine % for item %',
        NEW.staff, item_cuisine, NEW.item;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_staff_can_cook
BEFORE INSERT OR UPDATE ON Prepare
FOR EACH ROW
EXECUTE FUNCTION check_staff_can_cook();

--If someone deletes from Cook, the existing Prepare entries might now reference staff who can no longer cook that cuisine.
CREATE OR REPLACE FUNCTION prevent_cook_delete()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Prepare p
        JOIN Item i ON p.item = i.name
        WHERE p.staff = OLD.staff AND i.cuisine = OLD.cuisine
    ) THEN
        RAISE EXCEPTION 'Cannot delete Cook record for %, still preparing % dishes', OLD.staff, OLD.cuisine;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_cook_delete
BEFORE DELETE ON Cook
FOR EACH ROW EXECUTE FUNCTION prevent_cook_delete();

--If an item’s cuisine changes, some Prepare records may now point to a staff who can’t cook the new cuisine.
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
        RAISE EXCEPTION
        'Changing cuisine of item % to % causes invalid staff assignments.',
        OLD.name, NEW.cuisine;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_item_cuisine_update
BEFORE UPDATE OF cuisine ON Item
FOR EACH ROW
EXECUTE FUNCTION check_item_cuisine_update();

--------------------------------------------------
-- CONSTRAINT 3: Order’s date/time must not precede member’s registration
--------------------------------------------------

--If someone updates or inserts from Order_By, check that order occurs before member's registration
CREATE OR REPLACE FUNCTION check_order_after_registration()
RETURNS TRIGGER AS $$
DECLARE
    reg_ts  TIMESTAMP;
    order_ts TIMESTAMP;
BEGIN
    SELECT (reg_date + reg_time) INTO reg_ts FROM Member WHERE phone = NEW.member;
    SELECT (date + time) INTO order_ts FROM Food_Order WHERE id = NEW.order_id;

    IF order_ts < reg_ts THEN
        RAISE EXCEPTION
        'Order % occurs before registration of member %',
        NEW.order_id, NEW.member;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_order_after_registration
BEFORE INSERT OR UPDATE ON Ordered_By
FOR EACH ROW
EXECUTE FUNCTION check_order_after_registration();

--If someone changes an order’s date/time after it’s linked to a member, check that this updated order occurs before member's registration
CREATE OR REPLACE FUNCTION check_order_datetime_update()
RETURNS TRIGGER AS $$
DECLARE
    reg_ts TIMESTAMP;
    new_order_ts TIMESTAMP := NEW.date::timestamp + NEW.time;
BEGIN
    IF EXISTS (SELECT 1 FROM Ordered_By WHERE order_id = NEW.id) THEN
        SELECT (m.reg_date::timestamp + m.reg_time)
        INTO reg_ts
        FROM Member m
        JOIN Ordered_By ob ON ob.member = m.phone
        WHERE ob.order_id = NEW.id;

        IF reg_ts IS NOT NULL AND new_order_ts < reg_ts THEN
            RAISE EXCEPTION
            'Updated order % occurs before member registration.', NEW.id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_order_datetime_update
BEFORE UPDATE OF date, time ON Food_Order
FOR EACH ROW
EXECUTE FUNCTION check_order_datetime_update();

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