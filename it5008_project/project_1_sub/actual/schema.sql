DROP TABLE IF EXISTS staff_cuisine CASCADE;
DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS registration CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS menu CASCADE;
DROP TABLE IF EXISTS cuisines CASCADE;
DROP TABLE IF EXISTS bills CASCADE;

-- DROP CLAUSE ABOVE --

CREATE TABLE IF NOT EXISTS cuisines (
  cuisine_name  VARCHAR(100) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS menu (
  item      VARCHAR(100) PRIMARY KEY,
  price     NUMERIC NOT NULL CHECK (price >= 0),
  cuisine_name  VARCHAR(100) NOT NULL REFERENCES cuisines(cuisine_name)
);

CREATE TABLE IF NOT EXISTS staff (
  staff_id    VARCHAR(8) PRIMARY KEY,
  staff_name  VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS staff_cuisine (
  cuisine_name  VARCHAR(100) NOT NULL REFERENCES cuisines(cuisine_name),
  staff_id    VARCHAR(8) NOT NULL REFERENCES staff(staff_id),
  PRIMARY KEY (staff_id, cuisine_name)
);

CREATE TABLE IF NOT EXISTS registration (
  reg_date    DATE NOT NULL,
  reg_time    TIME NOT NULL,
  phone     VARCHAR(8) PRIMARY KEY,
  first_name  VARCHAR(100) NOT NULL,
  last_name   VARCHAR(100) NOT NULL,
  CHECK (phone ~ '^[0-9]{8}$')
);

CREATE TABLE IF NOT EXISTS bills (
  bill_date     DATE NOT NULL,
  bill_time     TIME NOT NULL,
  bill_id       VARCHAR(11) PRIMARY KEY,
  payment       VARCHAR(4) NOT NULL CHECK (payment IN ('cash','card')),
  total_bill    NUMERIC NOT NULL CHECK (total_bill >= 0),
  card_number   VARCHAR(19), 
  card_type     VARCHAR(100),
  phone         VARCHAR(8) REFERENCES registration(phone),
  
  CHECK (
    (payment = 'cash' AND (card_number IS NULL OR card_number = '') AND (card_type IS NULL OR card_type = ''))
    OR
    (payment = 'card' AND (card_number IS NOT NULL AND card_number <> '') AND (card_type IS NOT NULL AND card_type <> ''))
  )
);

CREATE TABLE IF NOT EXISTS order_items (
  order_id      VARCHAR(100) PRIMARY KEY,
  bill_id     VARCHAR(11) NOT NULL REFERENCES bills(bill_id),
  item          VARCHAR(100) NOT NULL REFERENCES menu(item) ON UPDATE CASCADE,
  staff_id      VARCHAR(8) NOT NULL REFERENCES staff(staff_id)
);