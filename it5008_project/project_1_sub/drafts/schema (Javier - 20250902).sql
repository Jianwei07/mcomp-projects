DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS staff_cuisine;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS registration;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS cuisine;
DROP TABLE IF EXISTS bill_20250902;
DROP TABLE IF EXISTS orders_20250902;
-- DROP CLAUSE ABOVE --

CREATE TABLE IF NOT EXISTS cuisine (
  cuisine_name 	VARCHAR(100) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS menu (
  item 			VARCHAR(100) PRIMARY KEY,
  price 		NUMERIC NOT NULL CHECK (price >= 0),
  cuisine_name 	VARCHAR(100) NOT NULL REFERENCES cuisine(cuisine_name)
);

CREATE TABLE IF NOT EXISTS registration (
  reg_date 		DATE NOT NULL,
  reg_time 		TIME NOT NULL,
  phone 		VARCHAR(8) PRIMARY KEY,
  first_name 	VARCHAR(100) NOT NULL,
  last_name 	VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS staff (
  staff_id 		VARCHAR(8) PRIMARY KEY,
  staff_name 	VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS staff_cuisine (
  cuisine_name 	VARCHAR(100) NOT NULL REFERENCES cuisine(cuisine_name),
  staff_id 		VARCHAR(8) NOT NULL REFERENCES staff(staff_id),
  PRIMARY KEY (staff_id, cuisine_name)
);

-- Breaking down "order" CSV file ------------------------------------------------
CREATE TABLE IF NOT EXISTS bill_20250902 (
  bill_date  	DATE NOT NULL,
  bill_time  	TIME NOT NULL,
  bill_id    	VARCHAR(11) PRIMARY KEY, -- Originally 'order' column
  payment     	VARCHAR(4) NOT NULL CHECK (payment IN ('cash','card')),
  total_bill  NUMERIC NOT NULL CHECK (total_bill >= 0),
  card_number 	VARCHAR(19),
  card_type   	VARCHAR(100),
  phone       	VARCHAR(8) REFERENCES registration(phone),
  CHECK (
    (payment = 'cash' AND (card_number IS NULL OR card_number='') AND (card_type IS NULL OR card_type=''))
    OR
    (payment = 'card' AND (card_number IS NOT NULL AND card_number<>'') AND (card_type IS NOT NULL AND card_type<>''))
  )
);

CREATE TABLE IF NOT EXISTS orders_20250902 (
  order_id		VARCHAR(100) PRIMARY KEY,
  bill_id    	VARCHAR(11) NOT NULL REFERENCES bill_20250902(bill_id),
  item        	VARCHAR(100) NOT NULL REFERENCES menu(item) ON UPDATE CASCADE,
  staff_id    	VARCHAR(8) NOT NULL REFERENCES staff(staff_id)
);