DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS staff_cuisine;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS registration;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS cuisine;
-- DROP CLAUSE ABOVE --

CREATE TABLE cuisine (
  cuisine_name TEXT PRIMARY KEY
);

CREATE TABLE menu (
  item TEXT PRIMARY KEY,
  price_cents INTEGER NOT NULL CHECK (price_cents >= 0),
  cuisine TEXT NOT NULL REFERENCES cuisine(cuisine_name)
);

CREATE TABLE registration (
  phone TEXT PRIMARY KEY,
  firstname TEXT NOT NULL,
  lastname TEXT NOT NULL,
  reg_date DATE NOT NULL,
  reg_time TIME NOT NULL
);

CREATE TABLE staff (
  staff_id TEXT PRIMARY KEY,
  staff_name TEXT NOT NULL
);

CREATE TABLE staff_cuisine (
  cuisine_name TEXT NOT NULL REFERENCES cuisine(cuisine_name) ON DELETE RESTRICT,
  staff_id TEXT NOT NULL REFERENCES staff(staff_id) ON DELETE RESTRICT,
  PRIMARY KEY (staff_id, cuisine_name)
);

-- DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  order_date  DATE NOT NULL,
  order_time  TIME NOT NULL,
  order_id    TEXT NOT NULL,
  payment     TEXT NOT NULL CHECK (payment IN ('cash','card')),
  card_number TEXT,
  card_type   TEXT,
  item        TEXT NOT NULL REFERENCES menu(item) ON UPDATE CASCADE ON DELETE RESTRICT,
  price       NUMERIC(10,2) NOT NULL CHECK (price >= 0),
  phone       TEXT,
  firstname   TEXT,
  lastname    TEXT,
  staff_id    TEXT NOT NULL REFERENCES staff(staff_id) ON DELETE RESTRICT,

  CHECK (
    (payment = 'cash' AND (card_number IS NULL OR card_number='') AND (card_type IS NULL OR card_type=''))
    OR
    (payment = 'card' AND (card_number IS NOT NULL AND card_number<>'') AND (card_type IS NOT NULL AND card_type<>''))
  ),

  CHECK (
    ((phone IS NULL OR phone='') AND (firstname IS NULL OR firstname='') AND (lastname IS NULL OR lastname=''))
    OR
    ((phone IS NOT NULL AND phone<>'') AND (firstname IS NOT NULL AND firstname<>'') AND (lastname IS NOT NULL AND lastname<>''))
  )
);
