## FOR CUISINE

INSERT INTO cuisine (cuisine_name) VALUES ('Indonesian');
INSERT INTO cuisine (cuisine_name) VALUES ('German');
INSERT INTO cuisine (cuisine_name) VALUES ('Vietnamese');
INSERT INTO cuisine (cuisine_name) VALUES ('Chinese');
INSERT INTO cuisine (cuisine_name) VALUES ('Indian');

## FOR MENU

INSERT INTO menu (item, price_cents, cuisine) VALUES ('Rendang', 400, 'Indonesian');
INSERT INTO menu (item, price_cents, cuisine) VALUES ('Ayam Balado', 400, 'Indonesian');
INSERT INTO menu (item, price_cents, cuisine) VALUES ('Gudeg', 300, 'Indonesian');
INSERT INTO menu (item, price_cents, cuisine) VALUES ('Rinderrouladen', 350, 'German');
INSERT INTO menu (item, price_cents, cuisine) VALUES ('Sauerbraten', 400, 'German');
INSERT INTO menu (item, price_cents, cuisine) VALUES ('Bun Cha', 300, 'Vietnamese');
INSERT INTO menu (item, price_cents, cuisine) VALUES ('Thunder Tea Rice', 250, 'Chinese');
INSERT INTO menu (item, price_cents, cuisine) VALUES ('Palak Paneer', 400, 'Indian');

## For Staff

INSERT INTO staff (staff_id, staff_name) VALUES
('STAFF-01','Kat'),
('STAFF-02','Kat'),
('STAFF-03','Taro'),
('STAFF-04','Owens'),
('STAFF-05','Migi'),
('STAFF-06','Dari'),
('STAFF-07','Ida'),
('STAFF-08','Neyu'),
('STAFF-09','Rodion'),
('STAFF-10','Neon'),
('STAFF-11','Evan'),
('STAFF-12','Gerion')
ON CONFLICT (staff_id) DO NOTHING;

## For Staff_cuisine

INSERT INTO staff_cuisine (staff_id, cuisine_name) VALUES
('STAFF-01','Indonesian'),
('STAFF-01','German'),
('STAFF-02','German'),
('STAFF-02','Chinese'),
('STAFF-03','Vietnamese'),
('STAFF-03','Chinese'),
('STAFF-03','Indian'),
('STAFF-03','Indonesian'),
('STAFF-04','Indonesian'),
('STAFF-04','German'),
('STAFF-05','Indonesian'),
('STAFF-05','German'),
('STAFF-05','Vietnamese'),
('STAFF-06','Indonesian'),
('STAFF-06','German'),
('STAFF-06','Chinese'),
('STAFF-06','Indian'),
('STAFF-06','Vietnamese'),
('STAFF-07','Indonesian'),
('STAFF-07','German'),
('STAFF-07','Vietnamese'),
('STAFF-07','Chinese'),
('STAFF-08','Vietnamese'),
('STAFF-08','Chinese'),
('STAFF-08','Indian'),
('STAFF-08','Indonesian'),
('STAFF-09','Indonesian'),
('STAFF-09','German'),
('STAFF-10','Indonesian'),
('STAFF-11','Indonesian'),
('STAFF-11','German'),
('STAFF-11','Vietnamese'),
('STAFF-11','Chinese'),
('STAFF-11','Indian'),
('STAFF-12','Indonesian'),
('STAFF-12','German'),
('STAFF-12','Vietnamese'),
('STAFF-12','Chinese'),
('STAFF-12','Indian')
ON CONFLICT DO NOTHING;

## FOR ORDERS

INSERT INTO orders VALUES ('2024-03-01', '10:15:51', '20240301001', 'card', '3742-8375-6443-8590', 'americanexpress', 'Rendang', '4', '', '', '', 'STAFF-01');
INSERT INTO orders VALUES ('2024-03-01', '12:19:23', '20240301002', 'card', '5108-7574-2920-6803', 'mastercard', 'Ayam Balado', '14', '93627414', 'Ignazio', 'Abrahmer', 'STAFF-03');
INSERT INTO orders VALUES ('2024-03-01', '12:19:23', '20240301002', 'card', '5108-7574-2920-6803', 'mastercard', 'Ayam Balado', '14', '93627414', 'Ignazio', 'Abrahmer', 'STAFF-03');
INSERT INTO orders VALUES ('2024-03-01', '12:19:23', '20240301002', 'card', '5108-7574-2920-6803', 'mastercard', 'Ayam Balado', '14', '93627414', 'Ignazio', 'Abrahmer', 'STAFF-03');
INSERT INTO orders VALUES ('2024-03-01', '12:19:23', '20240301002', 'card', '5108-7574-2920-6803', 'mastercard', 'Ayam Balado', '14', '93627414', 'Ignazio', 'Abrahmer', 'STAFF-04');
INSERT INTO orders VALUES ('2024-03-01', '13:46:33', '20240301003', 'card', '3466-5960-1418-4580', 'americanexpress', 'Gudeg', '9', '', '', '', 'STAFF-05');
INSERT INTO orders VALUES ('2024-03-01', '13:46:33', '20240301003', 'card', '3466-5960-1418-4580', 'americanexpress', 'Gudeg', '9', '', '', '', 'STAFF-05');
INSERT INTO orders VALUES ('2024-03-01', '13:46:33', '20240301003', 'card', '3466-5960-1418-4580', 'americanexpress', 'Gudeg', '9', '', '', '', 'STAFF-05');
INSERT INTO orders VALUES ('2024-03-01', '13:48:15', '20240301004', 'card', '3379-4110-3466-1310', 'americanexpress', 'Rendang', '8', '', '', '', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-01', '13:48:15', '20240301004', 'card', '3379-4110-3466-1310', 'americanexpress', 'Rendang', '8', '', '', '', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-01', '15:39:48', '20240301005', 'card', '3742-8382-6101-0570', 'americanexpress', 'Rinderrouladen', '3.5', '89007281', 'Bernard', 'Cowlard', 'STAFF-02');
INSERT INTO orders VALUES ('2024-03-01', '16:19:03', '20240301006', 'card', '5002-3594-5319-1014', 'mastercard', 'Ayam Balado', '12', '81059611', 'Laurette', 'Birney', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-01', '16:19:03', '20240301006', 'card', '5002-3594-5319-1014', 'mastercard', 'Ayam Balado', '12', '81059611', 'Laurette', 'Birney', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-01', '16:19:03', '20240301006', 'card', '5002-3594-5319-1014', 'mastercard', 'Ayam Balado', '12', '81059611', 'Laurette', 'Birney', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-01', '18:39:04', '20240301007', 'card', '3438-5506-5448-2790', 'americanexpress', 'Rinderrouladen', '7.0', '93342383', 'Corby', 'Crinage', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-01', '18:39:04', '20240301007', 'card', '3438-5506-5448-2790', 'americanexpress', 'Rinderrouladen', '7.0', '93342383', 'Corby', 'Crinage', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-01', '19:22:02', '20240301008', 'card', '5122-4098-9757-8766', 'mastercard', 'Rinderrouladen', '17.5', '85625766', 'Mal', 'Bavister', 'STAFF-12');
INSERT INTO orders VALUES ('2024-03-01', '19:22:02', '20240301008', 'card', '5122-4098-9757-8766', 'mastercard', 'Sauerbraten', '17.5', '85625766', 'Mal', 'Bavister', 'STAFF-11');
INSERT INTO orders VALUES ('2024-03-01', '19:22:02', '20240301008', 'card', '5122-4098-9757-8766', 'mastercard', 'Sauerbraten', '17.5', '85625766', 'Mal', 'Bavister', 'STAFF-11');
INSERT INTO orders VALUES ('2024-03-01', '19:22:02', '20240301008', 'card', '5122-4098-9757-8766', 'mastercard', 'Sauerbraten', '17.5', '85625766', 'Mal', 'Bavister', 'STAFF-11');
INSERT INTO orders VALUES ('2024-03-01', '19:22:02', '20240301008', 'card', '5122-4098-9757-8766', 'mastercard', 'Sauerbraten', '17.5', '85625766', 'Mal', 'Bavister', 'STAFF-11');
INSERT INTO orders VALUES ('2024-03-01', '19:29:17', '20240301009', 'card', '3742-8376-7036-0310', 'americanexpress', 'Rinderrouladen', '3.5', '', '', '', 'STAFF-01');
INSERT INTO orders VALUES ('2024-03-02', '10:22:07', '20240302001', 'card', '4041-3757-4304-3407', 'visa', 'Gudeg', '6', '', '', '', 'STAFF-08');
INSERT INTO orders VALUES ('2024-03-02', '10:22:07', '20240302001', 'card', '4041-3757-4304-3407', 'visa', 'Gudeg', '6', '', '', '', 'STAFF-08');
INSERT INTO orders VALUES ('2024-03-02', '10:30:36', '20240302002', 'cash', '', '', 'Rendang', '8', '', '', '', 'STAFF-10');
INSERT INTO orders VALUES ('2024-03-02', '10:30:36', '20240302002', 'cash', '', '', 'Rendang', '8', '', '', '', 'STAFF-10');
INSERT INTO orders VALUES ('2024-03-02', '10:41:41', '20240302003', 'card', '3742-8862-9783-4150', 'americanexpress', 'Rinderrouladen', '3.5', '95672712', 'Terese', 'Chetwind', 'STAFF-02');
INSERT INTO orders VALUES ('2024-03-02', '11:59:45', '20240302004', 'card', '5100-1491-9212-0304', 'mastercard', 'Rinderrouladen', '7.0', '', '', '', 'STAFF-04');
INSERT INTO orders VALUES ('2024-03-02', '11:59:45', '20240302004', 'card', '5100-1491-9212-0304', 'mastercard', 'Rinderrouladen', '7.0', '', '', '', 'STAFF-04');
INSERT INTO orders VALUES ('2024-03-02', '14:38:36', '20240302005', 'card', '5108-7546-4908-7766', 'mastercard', 'Gudeg', '3', '94385675', 'Kipp', 'Pettifer', 'STAFF-03');
INSERT INTO orders VALUES ('2024-03-02', '16:37:24', '20240302006', 'card', '4262-9066-4365-7000', 'visa', 'Rinderrouladen', '3.5', '97416639', 'Ernestine', 'Loughney', 'STAFF-05');
INSERT INTO orders VALUES ('2024-03-02', '17:34:55', '20240302007', 'card', '3379-4110-3466-1310', 'americanexpress', 'Gudeg', '9', '87113774', 'Estell', 'Barwell', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-02', '17:34:55', '20240302007', 'card', '3379-4110-3466-1310', 'americanexpress', 'Gudeg', '9', '87113774', 'Estell', 'Barwell', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-02', '17:34:55', '20240302007', 'card', '3379-4110-3466-1310', 'americanexpress', 'Gudeg', '9', '87113774', 'Estell', 'Barwell', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-03', '10:10:44', '20240303001', 'cash', '', '', 'Rendang', '12', '', '', '', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-03', '10:10:44', '20240303001', 'cash', '', '', 'Rendang', '12', '', '', '', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-03', '10:10:44', '20240303001', 'cash', '', '', 'Rendang', '12', '', '', '', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-03', '10:27:19', '20240303002', 'card', '3723-0139-1287-8790', 'americanexpress', 'Rendang', '4', '95961010', 'Othello', 'Reymers', 'STAFF-08');
INSERT INTO orders VALUES ('2024-03-03', '11:33:56', '20240303003', 'card', '4858-5115-7122-3000', 'visa', 'Bun Cha', '6', '', '', '', 'STAFF-11');
INSERT INTO orders VALUES ('2024-03-03', '11:33:56', '20240303003', 'card', '4858-5115-7122-3000', 'visa', 'Bun Cha', '6', '', '', '', 'STAFF-11');
INSERT INTO orders VALUES ('2024-03-03', '12:26:56', '20240303004', 'card', '5100-1491-9212-0304', 'mastercard', 'Gudeg', '6', '', '', '', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-03', '12:26:56', '20240303004', 'card', '5100-1491-9212-0304', 'mastercard', 'Gudeg', '6', '', '', '', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-03', '13:09:36', '20240303005', 'card', '5100-1472-8131-7534', 'mastercard', 'Ayam Balado', '4', '', '', '', 'STAFF-10');
INSERT INTO orders VALUES ('2024-03-03', '17:06:40', '20240303006', 'card', '5100-1730-4728-0832', 'mastercard', 'Sauerbraten', '4', '96537349', 'Grissel', 'Howels', 'STAFF-12');
INSERT INTO orders VALUES ('2024-03-03', '17:08:46', '20240303007', 'card', '4017-9500-6281-0000', 'visa', 'Bun Cha', '3', '', '', '', 'STAFF-03');
INSERT INTO orders VALUES ('2024-03-03', '18:03:23', '20240303008', 'card', '4041-5965-2059-3000', 'visa', 'Rinderrouladen', '18.0', '', '', '', 'STAFF-02');
INSERT INTO orders VALUES ('2024-03-03', '18:03:23', '20240303008', 'card', '4041-5965-2059-3000', 'visa', 'Ayam Balado', '18.0', '', '', '', 'STAFF-04');
INSERT INTO orders VALUES ('2024-03-03', '18:03:23', '20240303008', 'card', '4041-5965-2059-3000', 'visa', 'Rinderrouladen', '18.0', '', '', '', 'STAFF-01');
INSERT INTO orders VALUES ('2024-03-03', '18:03:23', '20240303008', 'card', '4041-5965-2059-3000', 'visa', 'Rinderrouladen', '18.0', '', '', '', 'STAFF-01');
INSERT INTO orders VALUES ('2024-03-03', '18:03:23', '20240303008', 'card', '4041-5965-2059-3000', 'visa', 'Rinderrouladen', '18.0', '', '', '', 'STAFF-01');
INSERT INTO orders VALUES ('2024-03-04', '10:03:52', '20240304001', 'card', '3742-8375-6443-8590', 'americanexpress', 'Rendang', '12', '93603800', 'Maddie', 'Izkoveski', 'STAFF-05');
INSERT INTO orders VALUES ('2024-03-04', '10:03:52', '20240304001', 'card', '3742-8375-6443-8590', 'americanexpress', 'Rendang', '12', '93603800', 'Maddie', 'Izkoveski', 'STAFF-05');
INSERT INTO orders VALUES ('2024-03-04', '10:03:52', '20240304001', 'card', '3742-8375-6443-8590', 'americanexpress', 'Rendang', '12', '93603800', 'Maddie', 'Izkoveski', 'STAFF-05');
INSERT INTO orders VALUES ('2024-03-04', '10:54:51', '20240304002', 'card', '5100-1431-0442-7071', 'mastercard', 'Rendang', '12', '87433248', 'Nolan', 'Capelin', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-04', '10:54:51', '20240304002', 'card', '5100-1431-0442-7071', 'mastercard', 'Rendang', '12', '87433248', 'Nolan', 'Capelin', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-04', '10:54:51', '20240304002', 'card', '5100-1431-0442-7071', 'mastercard', 'Rendang', '12', '87433248', 'Nolan', 'Capelin', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-04', '11:05:16', '20240304003', 'card', '5100-1491-9212-0304', 'mastercard', 'Rinderrouladen', '3.5', '', '', '', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-04', '14:04:38', '20240304004', 'card', '3481-6980-7796-5230', 'americanexpress', 'Thunder Tea Rice', '7.5', '98216900', 'Alyce', 'Brenard', 'STAFF-08');
INSERT INTO orders VALUES ('2024-03-04', '14:04:38', '20240304004', 'card', '3481-6980-7796-5230', 'americanexpress', 'Thunder Tea Rice', '7.5', '98216900', 'Alyce', 'Brenard', 'STAFF-08');
INSERT INTO orders VALUES ('2024-03-04', '14:04:38', '20240304004', 'card', '3481-6980-7796-5230', 'americanexpress', 'Thunder Tea Rice', '7.5', '98216900', 'Alyce', 'Brenard', 'STAFF-08');
INSERT INTO orders VALUES ('2024-03-05', '09:59:53', '20240305001', 'card', '3742-8375-6443-8590', 'americanexpress', 'Rendang', '12', '93603800', 'Maddie', 'Izkoveski', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-05', '09:59:53', '20240305001', 'card', '3742-8375-6443-8590', 'americanexpress', 'Rendang', '12', '93603800', 'Maddie', 'Izkoveski', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-05', '09:59:53', '20240305001', 'card', '3742-8375-6443-8590', 'americanexpress', 'Rendang', '12', '93603800', 'Maddie', 'Izkoveski', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-05', '14:34:56', '20240305002', 'card', '3742-8889-7783-4510', 'americanexpress', 'Rendang', '8', '95624750', 'Jacenta', 'Buxsy', 'STAFF-10');
INSERT INTO orders VALUES ('2024-03-05', '14:34:56', '20240305002', 'card', '3742-8889-7783-4510', 'americanexpress', 'Rendang', '8', '95624750', 'Jacenta', 'Buxsy', 'STAFF-10');
INSERT INTO orders VALUES ('2024-03-05', '17:34:06', '20240305003', 'card', '5002-3537-1745-1926', 'mastercard', 'Rendang', '4', '85205752', 'Kiah', 'Cotter', 'STAFF-11');
INSERT INTO orders VALUES ('2024-03-05', '17:35:25', '20240305004', 'card', '3742-8385-3694-9250', 'americanexpress', 'Ayam Balado', '4', '', '', '', 'STAFF-12');
INSERT INTO orders VALUES ('2024-03-05', '17:36:29', '20240305005', 'card', '3403-2288-8123-5330', 'americanexpress', 'Ayam Balado', '16', '', '', '', 'STAFF-03');
INSERT INTO orders VALUES ('2024-03-05', '17:36:29', '20240305005', 'card', '3403-2288-8123-5330', 'americanexpress', 'Ayam Balado', '16', '', '', '', 'STAFF-04');
INSERT INTO orders VALUES ('2024-03-05', '17:36:29', '20240305005', 'card', '3403-2288-8123-5330', 'americanexpress', 'Sauerbraten', '16', '', '', '', 'STAFF-01');
INSERT INTO orders VALUES ('2024-03-05', '17:36:29', '20240305005', 'card', '3403-2288-8123-5330', 'americanexpress', 'Sauerbraten', '16', '', '', '', 'STAFF-01');
INSERT INTO orders VALUES ('2024-03-05', '17:56:16', '20240305006', 'card', '3497-9717-6891-3400', 'americanexpress', 'Ayam Balado', '15', '', '', '', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-05', '17:56:16', '20240305006', 'card', '3497-9717-6891-3400', 'americanexpress', 'Ayam Balado', '15', '', '', '', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-05', '17:56:16', '20240305006', 'card', '3497-9717-6891-3400', 'americanexpress', 'Ayam Balado', '15', '', '', '', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-05', '17:56:16', '20240305006', 'card', '3497-9717-6891-3400', 'americanexpress', 'Bun Cha', '15', '', '', '', 'STAFF-05');
INSERT INTO orders VALUES ('2024-03-06', '12:30:27', '20240306001', 'cash', '', '', 'Rinderrouladen', '7.0', '', '', '', 'STAFF-02');
INSERT INTO orders VALUES ('2024-03-06', '12:30:27', '20240306001', 'cash', '', '', 'Rinderrouladen', '7.0', '', '', '', 'STAFF-02');
INSERT INTO orders VALUES ('2024-03-06', '13:24:08', '20240306002', 'card', '5100-1491-9212-0304', 'mastercard', 'Bun Cha', '12', '', '', '', 'STAFF-08');
INSERT INTO orders VALUES ('2024-03-06', '13:24:08', '20240306002', 'card', '5100-1491-9212-0304', 'mastercard', 'Gudeg', '12', '', '', '', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-06', '13:24:08', '20240306002', 'card', '5100-1491-9212-0304', 'mastercard', 'Gudeg', '12', '', '', '', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-06', '13:24:08', '20240306002', 'card', '5100-1491-9212-0304', 'mastercard', 'Gudeg', '12', '', '', '', 'STAFF-07');
INSERT INTO orders VALUES ('2024-03-06', '14:52:02', '20240306003', 'card', '5580-9476-7037-6028', 'mastercard', 'Palak Paneer', '8', '93344468', 'Gage', 'Whaymand', 'STAFF-11');
INSERT INTO orders VALUES ('2024-03-06', '14:52:02', '20240306003', 'card', '5580-9476-7037-6028', 'mastercard', 'Palak Paneer', '8', '93344468', 'Gage', 'Whaymand', 'STAFF-12');
INSERT INTO orders VALUES ('2024-03-07', '10:08:59', '20240307001', 'cash', '', '', 'Rendang', '12', '', '', '', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-07', '10:08:59', '20240307001', 'cash', '', '', 'Rendang', '12', '', '', '', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-07', '10:08:59', '20240307001', 'cash', '', '', 'Rendang', '12', '', '', '', 'STAFF-09');
INSERT INTO orders VALUES ('2024-03-07', '10:18:41', '20240307002', 'card', '3723-0124-5489-1920', 'americanexpress', 'Ayam Balado', '4', '', '', '', 'STAFF-10');
INSERT INTO orders VALUES ('2024-03-07', '11:03:59', '20240307003', 'card', '3746-2243-5619-5890', 'americanexpress', 'Rendang', '8', '', '', '', 'STAFF-01');
INSERT INTO orders VALUES ('2024-03-07', '11:03:59', '20240307003', 'card', '3746-2243-5619-5890', 'americanexpress', 'Rendang', '8', '', '', '', 'STAFF-01');
INSERT INTO orders VALUES ('2024-03-07', '11:25:44', '20240307004', 'cash', '', '', 'Rendang', '4', '', '', '', 'STAFF-03');
INSERT INTO orders VALUES ('2024-03-07', '15:40:23', '20240307005', 'card', '5108-7557-3480-9949', 'mastercard', 'Gudeg', '9', '', '', '', 'STAFF-04');
INSERT INTO orders VALUES ('2024-03-07', '15:40:23', '20240307005', 'card', '5108-7557-3480-9949', 'mastercard', 'Gudeg', '9', '', '', '', 'STAFF-04');
INSERT INTO orders VALUES ('2024-03-07', '15:40:23', '20240307005', 'card', '5108-7557-3480-9949', 'mastercard', 'Gudeg', '9', '', '', '', 'STAFF-04');
INSERT INTO orders VALUES ('2024-03-07', '15:41:29', '20240307006', 'card', '4041-5976-8082-0030', 'visa', 'Rinderrouladen', '3.5', '83187835', 'Rickey', 'Hector', 'STAFF-02');
INSERT INTO orders VALUES ('2024-03-08', '10:34:41', '20240308001', 'card', '5100-1491-9212-0304', 'mastercard', 'Bun Cha', '3', '', '', '', 'STAFF-05');
INSERT INTO orders VALUES ('2024-03-08', '12:22:29', '20240308002', 'card', '5100-1476-0010-6766', 'mastercard', 'Palak Paneer', '14', '87547836', 'Flynn', 'Massot', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-08', '12:22:29', '20240308002', 'card', '5100-1476-0010-6766', 'mastercard', 'Palak Paneer', '14', '87547836', 'Flynn', 'Massot', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-08', '12:22:29', '20240308002', 'card', '5100-1476-0010-6766', 'mastercard', 'Palak Paneer', '14', '87547836', 'Flynn', 'Massot', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-08', '12:22:29', '20240308002', 'card', '5100-1476-0010-6766', 'mastercard', 'Palak Paneer', '14', '87547836', 'Flynn', 'Massot', 'STAFF-06');
INSERT INTO orders VALUES ('2024-03-08', '13:53:02', '20240308003', 'card', '3746-2267-7977-3800', 'americanexpress', 'Gudeg', '3', '', '', '', 'STAFF-07');
