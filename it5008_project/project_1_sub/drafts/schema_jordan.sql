-- ==========================
-- Restaurant Database Schema
-- ==========================


-- #Comments READ FIRST THANK YOU

-- First schema:

-- bills = stores payment info

-- orders = links to bills and staff

-- order_items = stores individual items for each order
-- ✅ Fully normalized: avoids redundancy, one order can have multiple items.

-- Second schema:

-- orders_20250902 combines order details + items

-- bill_20250902 contains only payment info
--  Less normalized: orders_20250902 has item in the main order table, which may duplicate rows if multiple items exist per order.

-- 3. Columns

-- First schema:

-- orders table does NOT store customer first/last name directly; references registrations

-- order_items separates item-level details

-- staff_id stored consistently

-- Second schema:

-- orders_20250902 stores item directly in orders table

-- orders table includes first_name and last_name in some versions

-- Not fully normalized; violates 1NF if multiple items per order exist (would need multiple rows for same order_id).

-- 1. Cuisine

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS staff_cuisine;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS registration;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS cuisine;

CREATE TABLE IF NOT EXISTS cuisines (
  cuisine_name VARCHAR(100) PRIMARY KEY
);

-- 2. Menu
CREATE TABLE IF NOT EXISTS menu (
  item         VARCHAR(100) PRIMARY KEY,
  price        NUMERIC NOT NULL CHECK (price >= 0),
  cuisine_name VARCHAR(100) NOT NULL REFERENCES cuisines(cuisine_name)
);

-- 3. Customers (registrations)
CREATE TABLE IF NOT EXISTS customers (
  phone       VARCHAR(8) PRIMARY KEY,
  first_name  VARCHAR(100) NOT NULL,
  last_name   VARCHAR(100) NOT NULL,
  reg_date    DATE NOT NULL,
  reg_time    TIME NOT NULL
);

-- 4. Staffs
CREATE TABLE IF NOT EXISTS staffs (
  staff_id    VARCHAR(8) PRIMARY KEY,
  staff_name  VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS registration (
  phone TEXT PRIMARY KEY,
  firstname TEXT NOT NULL,
  lastname TEXT NOT NULL,
  reg_date DATE NOT NULL,
  reg_time TIME NOT NULL
);

-- 5. Staff–Cuisine Mapping (many-to-many)
CREATE TABLE IF NOT EXISTS staff_cuisines (
  staff_id     VARCHAR(8) NOT NULL REFERENCES staffs(staff_id),
  cuisine_name VARCHAR(100) NOT NULL REFERENCES cuisines(cuisine_name),
  PRIMARY KEY (staff_id, cuisine_name)
);

-- 6. Bills (payment records / receipt headers)
CREATE TABLE IF NOT EXISTS bills (
  bill_id     VARCHAR(11) PRIMARY KEY,
  bill_date   DATE NOT NULL,
  bill_time   TIME NOT NULL,
  payment     VARCHAR(4) NOT NULL CHECK (payment IN ('cash','card')),
  card_number VARCHAR(19),
  card_type   VARCHAR(100),
  phone       VARCHAR(8) REFERENCES customers(phone),
  CHECK (
    (payment = 'cash' AND (card_number IS NULL OR card_number='') AND (card_type IS NULL OR card_type=''))
    OR
    (payment = 'card' AND (card_number IS NOT NULL AND card_number <> '') AND (card_type IS NOT NULL AND card_type <> ''))
  )
);

-- 7. Orders (high-level order info linking to bill)
CREATE TABLE IF NOT EXISTS orders (
  order_id    VARCHAR(11) PRIMARY KEY,
  order_date  DATE NOT NULL,
  order_time  TIME NOT NULL,
  total_bill  NUMERIC NOT NULL CHECK (total_bill >= 0),
  staff_id    VARCHAR(8) NOT NULL REFERENCES staffs(staff_id),
  bill_id     VARCHAR(11) NOT NULL REFERENCES bills(bill_id)
);

-- 8. Order Items (detailed items in each order)
CREATE TABLE IF NOT EXISTS order_items (
  order_id   VARCHAR(11) NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
  item       VARCHAR(100) NOT NULL REFERENCES menu(item) ON UPDATE CASCADE,
  staff_id   VARCHAR(8) NOT NULL REFERENCES staffs(staff_id),
  PRIMARY KEY (order_id, item)
);
