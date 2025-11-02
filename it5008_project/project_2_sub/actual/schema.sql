DROP TABLE IF EXISTS membership_orders CASCADE;
DROP TABLE IF EXISTS orders_paid_by_card CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS payment_card CASCADE;
DROP TABLE IF EXISTS staff_can_prepare CASCADE;
DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS menu_belongs_to CASCADE;
DROP TABLE IF EXISTS menu CASCADE;
DROP TABLE IF EXISTS cuisines CASCADE;
DROP TABLE IF EXISTS registration CASCADE;

CREATE TABLE cuisines (
  cuisine_name TEXT PRIMARY KEY
);

CREATE TABLE menu (
  item         TEXT PRIMARY KEY,
  price        NUMERIC(10,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE menu_belongs_to (
  item         TEXT NOT NULL REFERENCES menu(item) ON UPDATE CASCADE ON DELETE RESTRICT,
  cuisine_name TEXT NOT NULL REFERENCES cuisines(cuisine_name) ON UPDATE CASCADE ON DELETE RESTRICT,
  PRIMARY KEY (item, cuisine_name)
);

CREATE TABLE staff (
  staff_id   TEXT PRIMARY KEY,
  staff_name TEXT NOT NULL
);

CREATE TABLE staff_can_prepare (
  staff_id     TEXT NOT NULL REFERENCES staff(staff_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  cuisine_name TEXT NOT NULL REFERENCES cuisines(cuisine_name) ON UPDATE CASCADE ON DELETE RESTRICT,
  PRIMARY KEY (staff_id, cuisine_name)
);

CREATE TABLE registration (
  phone      TEXT PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name  TEXT NOT NULL,
  reg_date   DATE NOT NULL,
  reg_time   TIME NOT NULL,
  CHECK (phone ~ '^[0-9]{8}$')
);

CREATE TABLE orders (
  orders_id    VARCHAR(11) PRIMARY KEY,
  orders_date  DATE NOT NULL,
  orders_time  TIME NOT NULL,
  payment    TEXT NOT NULL CHECK (payment IN ('cash','card'))
);

CREATE TABLE payment_card (
  card_number TEXT PRIMARY KEY,
  card_type   TEXT NOT NULL CHECK (card_type IN ('visa','mastercard','americanexpress')) 
);

CREATE TABLE membership_orders (
  phone      TEXT REFERENCES registration(phone) ON UPDATE CASCADE ON DELETE RESTRICT,
  orders_id  VARCHAR(11) NOT NULL REFERENCES orders(orders_id) ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (phone, orders_id)
);

CREATE TABLE orders_paid_by_card (
  orders_id     VARCHAR(11) NOT NULL REFERENCES orders(orders_id) ON UPDATE CASCADE ON DELETE CASCADE,
  card_number   TEXT NOT NULL REFERENCES payment_card(card_number) ON UPDATE CASCADE ON DELETE RESTRICT,
  PRIMARY KEY (orders_id, card_number)
);

CREATE TABLE order_items (
  orders_id     VARCHAR(11) NOT NULL REFERENCES orders(orders_id),
  item          VARCHAR(100) NOT NULL REFERENCES menu(item) ON UPDATE CASCADE,
  staff_id      VARCHAR(8) NOT NULL REFERENCES staff(staff_id),
  order_count   INTEGER NOT NULL CHECK (order_count > 0),
  PRIMARY KEY (orders_id, item, staff_id)
);