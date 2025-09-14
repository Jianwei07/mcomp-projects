--
-- File: data.sql
-- Description: INSERT statements for all tables
-- Generated automatically by generate_data.py
--

--
-- Data for table: cuisines
--
INSERT INTO cuisines (cuisine_name) VALUES ('Indonesian');
INSERT INTO cuisines (cuisine_name) VALUES ('German');
INSERT INTO cuisines (cuisine_name) VALUES ('Vietnamese');
INSERT INTO cuisines (cuisine_name) VALUES ('Chinese');
INSERT INTO cuisines (cuisine_name) VALUES ('Indian');

--
-- Data for table: menu
--
INSERT INTO menu (item, price) VALUES ('Rendang', '4.0');
INSERT INTO menu (item, price) VALUES ('Ayam Balado', '4.0');
INSERT INTO menu (item, price) VALUES ('Gudeg', '3.0');
INSERT INTO menu (item, price) VALUES ('Rinderrouladen', '3.5');
INSERT INTO menu (item, price) VALUES ('Sauerbraten', '4.0');
INSERT INTO menu (item, price) VALUES ('Bun Cha', '3.0');
INSERT INTO menu (item, price) VALUES ('Thunder Tea Rice', '2.5');
INSERT INTO menu (item, price) VALUES ('Palak Paneer', '4.0');

--
-- Data for table: menu_belongs_to
--
INSERT INTO menu_belongs_to (item, cuisine_name) VALUES ('Rendang', 'Indonesian');
INSERT INTO menu_belongs_to (item, cuisine_name) VALUES ('Ayam Balado', 'Indonesian');
INSERT INTO menu_belongs_to (item, cuisine_name) VALUES ('Gudeg', 'Indonesian');
INSERT INTO menu_belongs_to (item, cuisine_name) VALUES ('Rinderrouladen', 'German');
INSERT INTO menu_belongs_to (item, cuisine_name) VALUES ('Sauerbraten', 'German');
INSERT INTO menu_belongs_to (item, cuisine_name) VALUES ('Bun Cha', 'Vietnamese');
INSERT INTO menu_belongs_to (item, cuisine_name) VALUES ('Thunder Tea Rice', 'Chinese');
INSERT INTO menu_belongs_to (item, cuisine_name) VALUES ('Palak Paneer', 'Indian');

--
-- Data for table: staff
--
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-01', 'Kat');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-02', 'Kat');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-03', 'Taro');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-04', 'Owens');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-05', 'Migi');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-06', 'Dari');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-07', 'Ida');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-08', 'Neyu');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-09', 'Rodion');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-10', 'Neon');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-11', 'Evan');
INSERT INTO staff (staff_id, staff_name) VALUES ('STAFF-12', 'Gerion');

--
-- Data for table: staff_can_prepare
--
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-01', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-01', 'German');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-02', 'German');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-02', 'Chinese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-03', 'Vietnamese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-03', 'Chinese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-03', 'Indian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-03', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-04', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-04', 'German');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-05', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-05', 'German');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-05', 'Vietnamese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-06', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-06', 'German');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-06', 'Chinese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-06', 'Indian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-06', 'Vietnamese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-07', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-07', 'German');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-07', 'Vietnamese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-07', 'Chinese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-08', 'Vietnamese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-08', 'Chinese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-08', 'Indian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-08', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-09', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-09', 'German');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-10', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-11', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-11', 'German');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-11', 'Vietnamese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-11', 'Chinese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-11', 'Indian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-12', 'Indonesian');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-12', 'German');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-12', 'Vietnamese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-12', 'Chinese');
INSERT INTO staff_can_prepare (staff_id, cuisine_name) VALUES ('STAFF-12', 'Indian');

-- Simple query to show data is successfully inserted
SELECT COUNT(*) FROM orders;
