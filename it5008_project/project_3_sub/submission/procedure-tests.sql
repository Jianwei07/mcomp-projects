-- Clean up previous data
TRUNCATE Prepare, Ordered_By, Food_Order, Member, Cook, Staff, Item, Cuisine RESTART IDENTITY CASCADE;


-- Populate cuisine table
INSERT INTO cuisine VALUES ('Indonesian');
INSERT INTO cuisine VALUES ('German');
INSERT INTO cuisine VALUES ('Vietnamese');
INSERT INTO cuisine VALUES ('Chinese');
INSERT INTO cuisine VALUES ('Indian');
INSERT INTO cuisine VALUES ('Western');


-- Populate Item table
INSERT INTO Item VALUES ('Rendang', '4', 'Indonesian');
INSERT INTO Item VALUES ('Ayam Balado', '4', 'Indonesian');
INSERT INTO Item VALUES ('Gudeg', '3', 'Indonesian');
INSERT INTO Item VALUES ('Rinderrouladen', '3.5', 'German');
INSERT INTO Item VALUES ('Sauerbraten', '4', 'German');
INSERT INTO Item VALUES ('Bun Cha', '3', 'Vietnamese');
INSERT INTO Item VALUES ('Thunder Tea Rice', '2.5', 'Chinese');
INSERT INTO Item VALUES ('Palak Paneer', '4', 'Indian');


-- Populate Staff table
INSERT INTO Staff VALUES ('STAFF-01', 'Kat');
INSERT INTO Staff VALUES ('STAFF-02', 'Kat');
INSERT INTO Staff VALUES ('STAFF-03', 'Taro');
INSERT INTO Staff VALUES ('STAFF-04', 'Owens');
INSERT INTO Staff VALUES ('STAFF-05', 'Migi');
INSERT INTO Staff VALUES ('STAFF-06', 'Dari');
INSERT INTO Staff VALUES ('STAFF-07', 'Ida');
INSERT INTO Staff VALUES ('STAFF-08', 'Neyu');
INSERT INTO Staff VALUES ('STAFF-09', 'Rodion');
INSERT INTO Staff VALUES ('STAFF-10', 'Neon');
INSERT INTO Staff VALUES ('STAFF-11', 'Evan');
INSERT INTO Staff VALUES ('STAFF-12', 'Gerion');


-- Populate Cook table
INSERT INTO Cook VALUES ('STAFF-01', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-01', 'German');
INSERT INTO Cook VALUES ('STAFF-02', 'German');
INSERT INTO Cook VALUES ('STAFF-02', 'Chinese');
INSERT INTO Cook VALUES ('STAFF-03', 'Vietnamese');
INSERT INTO Cook VALUES ('STAFF-03', 'Chinese');
INSERT INTO Cook VALUES ('STAFF-03', 'Indian');
INSERT INTO Cook VALUES ('STAFF-03', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-04', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-04', 'German');
INSERT INTO Cook VALUES ('STAFF-05', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-05', 'German');
INSERT INTO Cook VALUES ('STAFF-05', 'Vietnamese');
INSERT INTO Cook VALUES ('STAFF-06', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-06', 'German');
INSERT INTO Cook VALUES ('STAFF-06', 'Chinese');
INSERT INTO Cook VALUES ('STAFF-06', 'Indian');
INSERT INTO Cook VALUES ('STAFF-06', 'Vietnamese');
INSERT INTO Cook VALUES ('STAFF-07', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-07', 'German');
INSERT INTO Cook VALUES ('STAFF-07', 'Vietnamese');
INSERT INTO Cook VALUES ('STAFF-07', 'Chinese');
INSERT INTO Cook VALUES ('STAFF-08', 'Vietnamese');
INSERT INTO Cook VALUES ('STAFF-08', 'Chinese');
INSERT INTO Cook VALUES ('STAFF-08', 'Indian');
INSERT INTO Cook VALUES ('STAFF-08', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-09', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-09', 'German');
INSERT INTO Cook VALUES ('STAFF-10', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-11', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-11', 'German');
INSERT INTO Cook VALUES ('STAFF-11', 'Vietnamese');
INSERT INTO Cook VALUES ('STAFF-11', 'Chinese');
INSERT INTO Cook VALUES ('STAFF-11', 'Indian');
INSERT INTO Cook VALUES ('STAFF-12', 'Indonesian');
INSERT INTO Cook VALUES ('STAFF-12', 'German');
INSERT INTO Cook VALUES ('STAFF-12', 'Vietnamese');
INSERT INTO Cook VALUES ('STAFF-12', 'Chinese');
INSERT INTO Cook VALUES ('STAFF-12', 'Indian');


-- Populate Member table
INSERT INTO Member VALUES ('93627414', 'Ignazio', 'Abrahmer', '2024-03-01', '12:19:23');
INSERT INTO Member VALUES ('89007281', 'Bernard', 'Cowlard', '2024-03-01', '15:39:48');
INSERT INTO Member VALUES ('81059611', 'Laurette', 'Birney', '2024-03-01', '16:19:03');
INSERT INTO Member VALUES ('93342383', 'Corby', 'Crinage', '2024-03-01', '18:39:04');
INSERT INTO Member VALUES ('85625766', 'Mal', 'Bavister', '2024-03-01', '19:22:02');
INSERT INTO Member VALUES ('95672712', 'Terese', 'Chetwind', '2024-03-02', '10:41:41');
INSERT INTO Member VALUES ('94385675', 'Kipp', 'Pettifer', '2024-03-02', '14:38:36');
INSERT INTO Member VALUES ('97416639', 'Ernestine', 'Loughney', '2024-03-02', '16:37:24');
INSERT INTO Member VALUES ('87113774', 'Estell', 'Barwell', '2024-03-02', '17:34:55');
INSERT INTO Member VALUES ('95961010', 'Othello', 'Reymers', '2024-03-03', '10:27:19');
INSERT INTO Member VALUES ('96537349', 'Grissel', 'Howels', '2024-03-03', '17:06:40');
INSERT INTO Member VALUES ('93603800', 'Maddie', 'Izkoveski', '2024-03-04', '10:03:52');
INSERT INTO Member VALUES ('87433248', 'Nolan', 'Capelin', '2024-03-04', '10:54:51');
INSERT INTO Member VALUES ('98216900', 'Alyce', 'Brenard', '2024-03-04', '14:04:38');
INSERT INTO Member VALUES ('95624750', 'Jacenta', 'Buxsy', '2024-03-05', '14:34:56');
INSERT INTO Member VALUES ('85205752', 'Kiah', 'Cotter', '2024-03-05', '17:34:06');
INSERT INTO Member VALUES ('93344468', 'Gage', 'Whaymand', '2024-03-06', '14:52:02');
INSERT INTO Member VALUES ('83187835', 'Rickey', 'Hector', '2024-03-07', '15:41:29');
INSERT INTO Member VALUES ('87547836', 'Flynn', 'Massot', '2024-03-08', '12:22:29');


-- Populate via Procedure
CALL insert_order_item(
        '20240301001', '2024-03-01', '10:15:51', 'card', 
        '3742-8375-6443-8590', 
        'americanexpress', 
        NULL, 'Rendang', 'STAFF-01'
    );
CALL insert_order_item(
        '20240301002', '2024-03-01', '12:19:23', 'card', 
        '5108-7574-2920-6803', 
        'mastercard', 
        93627414, 'Ayam Balado', 'STAFF-03'
    );
CALL insert_order_item(
        '20240301002', '2024-03-01', '12:19:23', 'card', 
        '5108-7574-2920-6803', 
        'mastercard', 
        93627414, 'Ayam Balado', 'STAFF-03'
    );
CALL insert_order_item(
        '20240301002', '2024-03-01', '12:19:23', 'card', 
        '5108-7574-2920-6803', 
        'mastercard', 
        93627414, 'Ayam Balado', 'STAFF-03'
    );
CALL insert_order_item(
        '20240301002', '2024-03-01', '12:19:23', 'card', 
        '5108-7574-2920-6803', 
        'mastercard', 
        93627414, 'Ayam Balado', 'STAFF-04'
    );
CALL insert_order_item(
        '20240301003', '2024-03-01', '13:46:33', 'card', 
        '3466-5960-1418-4580', 
        'americanexpress', 
        NULL, 'Gudeg', 'STAFF-05'
    );
CALL insert_order_item(
        '20240301003', '2024-03-01', '13:46:33', 'card', 
        '3466-5960-1418-4580', 
        'americanexpress', 
        NULL, 'Gudeg', 'STAFF-05'
    );
CALL insert_order_item(
        '20240301003', '2024-03-01', '13:46:33', 'card', 
        '3466-5960-1418-4580', 
        'americanexpress', 
        NULL, 'Gudeg', 'STAFF-05'
    );
CALL insert_order_item(
        '20240301004', '2024-03-01', '13:48:15', 'card', 
        '3379-4110-3466-1310', 
        'americanexpress', 
        NULL, 'Rendang', 'STAFF-06'
    );
CALL insert_order_item(
        '20240301004', '2024-03-01', '13:48:15', 'card', 
        '3379-4110-3466-1310', 
        'americanexpress', 
        NULL, 'Rendang', 'STAFF-06'
    );
CALL insert_order_item(
        '20240301005', '2024-03-01', '15:39:48', 'card', 
        '3742-8382-6101-0570', 
        'americanexpress', 
        89007281, 'Rinderrouladen', 'STAFF-02'
    );
CALL insert_order_item(
        '20240301006', '2024-03-01', '16:19:03', 'card', 
        '5002-3594-5319-1014', 
        'mastercard', 
        81059611, 'Ayam Balado', 'STAFF-07'
    );
CALL insert_order_item(
        '20240301006', '2024-03-01', '16:19:03', 'card', 
        '5002-3594-5319-1014', 
        'mastercard', 
        81059611, 'Ayam Balado', 'STAFF-07'
    );
CALL insert_order_item(
        '20240301006', '2024-03-01', '16:19:03', 'card', 
        '5002-3594-5319-1014', 
        'mastercard', 
        81059611, 'Ayam Balado', 'STAFF-07'
    );
CALL insert_order_item(
        '20240301007', '2024-03-01', '18:39:04', 'card', 
        '3438-5506-5448-2790', 
        'americanexpress', 
        93342383, 'Rinderrouladen', 'STAFF-09'
    );
CALL insert_order_item(
        '20240301007', '2024-03-01', '18:39:04', 'card', 
        '3438-5506-5448-2790', 
        'americanexpress', 
        93342383, 'Rinderrouladen', 'STAFF-09'
    );
CALL insert_order_item(
        '20240301008', '2024-03-01', '19:22:02', 'card', 
        '5122-4098-9757-8766', 
        'mastercard', 
        85625766, 'Rinderrouladen', 'STAFF-12'
    );
CALL insert_order_item(
        '20240301008', '2024-03-01', '19:22:02', 'card', 
        '5122-4098-9757-8766', 
        'mastercard', 
        85625766, 'Sauerbraten', 'STAFF-11'
    );
CALL insert_order_item(
        '20240301008', '2024-03-01', '19:22:02', 'card', 
        '5122-4098-9757-8766', 
        'mastercard', 
        85625766, 'Sauerbraten', 'STAFF-11'
    );
CALL insert_order_item(
        '20240301008', '2024-03-01', '19:22:02', 'card', 
        '5122-4098-9757-8766', 
        'mastercard', 
        85625766, 'Sauerbraten', 'STAFF-11'
    );
CALL insert_order_item(
        '20240301008', '2024-03-01', '19:22:02', 'card', 
        '5122-4098-9757-8766', 
        'mastercard', 
        85625766, 'Sauerbraten', 'STAFF-11'
    );
CALL insert_order_item(
        '20240301009', '2024-03-01', '19:29:17', 'card', 
        '3742-8376-7036-0310', 
        'americanexpress', 
        NULL, 'Rinderrouladen', 'STAFF-01'
    );
CALL insert_order_item(
        '20240302001', '2024-03-02', '10:22:07', 'card', 
        '4041-3757-4304-3407', 
        'visa', 
        NULL, 'Gudeg', 'STAFF-08'
    );
CALL insert_order_item(
        '20240302001', '2024-03-02', '10:22:07', 'card', 
        '4041-3757-4304-3407', 
        'visa', 
        NULL, 'Gudeg', 'STAFF-08'
    );
CALL insert_order_item(
        '20240302002', '2024-03-02', '10:30:36', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rendang', 'STAFF-10'
    );
CALL insert_order_item(
        '20240302002', '2024-03-02', '10:30:36', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rendang', 'STAFF-10'
    );
CALL insert_order_item(
        '20240302003', '2024-03-02', '10:41:41', 'card', 
        '3742-8862-9783-4150', 
        'americanexpress', 
        95672712, 'Rinderrouladen', 'STAFF-02'
    );
CALL insert_order_item(
        '20240302004', '2024-03-02', '11:59:45', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Rinderrouladen', 'STAFF-04'
    );
CALL insert_order_item(
        '20240302004', '2024-03-02', '11:59:45', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Rinderrouladen', 'STAFF-04'
    );
CALL insert_order_item(
        '20240302005', '2024-03-02', '14:38:36', 'card', 
        '5108-7546-4908-7766', 
        'mastercard', 
        94385675, 'Gudeg', 'STAFF-03'
    );
CALL insert_order_item(
        '20240302006', '2024-03-02', '16:37:24', 'card', 
        '4262-9066-4365-7000', 
        'visa', 
        97416639, 'Rinderrouladen', 'STAFF-05'
    );
CALL insert_order_item(
        '20240302007', '2024-03-02', '17:34:55', 'card', 
        '3379-4110-3466-1310', 
        'americanexpress', 
        87113774, 'Gudeg', 'STAFF-06'
    );
CALL insert_order_item(
        '20240302007', '2024-03-02', '17:34:55', 'card', 
        '3379-4110-3466-1310', 
        'americanexpress', 
        87113774, 'Gudeg', 'STAFF-06'
    );
CALL insert_order_item(
        '20240302007', '2024-03-02', '17:34:55', 'card', 
        '3379-4110-3466-1310', 
        'americanexpress', 
        87113774, 'Gudeg', 'STAFF-06'
    );
CALL insert_order_item(
        '20240303001', '2024-03-03', '10:10:44', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rendang', 'STAFF-07'
    );
CALL insert_order_item(
        '20240303001', '2024-03-03', '10:10:44', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rendang', 'STAFF-07'
    );
CALL insert_order_item(
        '20240303001', '2024-03-03', '10:10:44', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rendang', 'STAFF-07'
    );
CALL insert_order_item(
        '20240303002', '2024-03-03', '10:27:19', 'card', 
        '3723-0139-1287-8790', 
        'americanexpress', 
        95961010, 'Rendang', 'STAFF-08'
    );
CALL insert_order_item(
        '20240303003', '2024-03-03', '11:33:56', 'card', 
        '4858-5115-7122-3000', 
        'visa', 
        NULL, 'Bun Cha', 'STAFF-11'
    );
CALL insert_order_item(
        '20240303003', '2024-03-03', '11:33:56', 'card', 
        '4858-5115-7122-3000', 
        'visa', 
        NULL, 'Bun Cha', 'STAFF-11'
    );
CALL insert_order_item(
        '20240303004', '2024-03-03', '12:26:56', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Gudeg', 'STAFF-09'
    );
CALL insert_order_item(
        '20240303004', '2024-03-03', '12:26:56', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Gudeg', 'STAFF-09'
    );
CALL insert_order_item(
        '20240303005', '2024-03-03', '13:09:36', 'card', 
        '5100-1472-8131-7534', 
        'mastercard', 
        NULL, 'Ayam Balado', 'STAFF-10'
    );
CALL insert_order_item(
        '20240303006', '2024-03-03', '17:06:40', 'card', 
        '5100-1730-4728-0832', 
        'mastercard', 
        96537349, 'Sauerbraten', 'STAFF-12'
    );
CALL insert_order_item(
        '20240303007', '2024-03-03', '17:08:46', 'card', 
        '4017-9500-6281-0000', 
        'visa', 
        NULL, 'Bun Cha', 'STAFF-03'
    );
CALL insert_order_item(
        '20240303008', '2024-03-03', '18:03:23', 'card', 
        '4041-5965-2059-3000', 
        'visa', 
        NULL, 'Rinderrouladen', 'STAFF-02'
    );
CALL insert_order_item(
        '20240303008', '2024-03-03', '18:03:23', 'card', 
        '4041-5965-2059-3000', 
        'visa', 
        NULL, 'Ayam Balado', 'STAFF-04'
    );
CALL insert_order_item(
        '20240303008', '2024-03-03', '18:03:23', 'card', 
        '4041-5965-2059-3000', 
        'visa', 
        NULL, 'Rinderrouladen', 'STAFF-01'
    );
CALL insert_order_item(
        '20240303008', '2024-03-03', '18:03:23', 'card', 
        '4041-5965-2059-3000', 
        'visa', 
        NULL, 'Rinderrouladen', 'STAFF-01'
    );
CALL insert_order_item(
        '20240303008', '2024-03-03', '18:03:23', 'card', 
        '4041-5965-2059-3000', 
        'visa', 
        NULL, 'Rinderrouladen', 'STAFF-01'
    );
CALL insert_order_item(
        '20240304001', '2024-03-04', '10:03:52', 'card', 
        '3742-8375-6443-8590', 
        'americanexpress', 
        93603800, 'Rendang', 'STAFF-05'
    );
CALL insert_order_item(
        '20240304001', '2024-03-04', '10:03:52', 'card', 
        '3742-8375-6443-8590', 
        'americanexpress', 
        93603800, 'Rendang', 'STAFF-05'
    );
CALL insert_order_item(
        '20240304001', '2024-03-04', '10:03:52', 'card', 
        '3742-8375-6443-8590', 
        'americanexpress', 
        93603800, 'Rendang', 'STAFF-05'
    );
CALL insert_order_item(
        '20240304002', '2024-03-04', '10:54:51', 'card', 
        '5100-1431-0442-7071', 
        'mastercard', 
        87433248, 'Rendang', 'STAFF-06'
    );
CALL insert_order_item(
        '20240304002', '2024-03-04', '10:54:51', 'card', 
        '5100-1431-0442-7071', 
        'mastercard', 
        87433248, 'Rendang', 'STAFF-06'
    );
CALL insert_order_item(
        '20240304002', '2024-03-04', '10:54:51', 'card', 
        '5100-1431-0442-7071', 
        'mastercard', 
        87433248, 'Rendang', 'STAFF-06'
    );
CALL insert_order_item(
        '20240304003', '2024-03-04', '11:05:16', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Rinderrouladen', 'STAFF-07'
    );
CALL insert_order_item(
        '20240304004', '2024-03-04', '14:04:38', 'card', 
        '3481-6980-7796-5230', 
        'americanexpress', 
        98216900, 'Thunder Tea Rice', 'STAFF-08'
    );
CALL insert_order_item(
        '20240304004', '2024-03-04', '14:04:38', 'card', 
        '3481-6980-7796-5230', 
        'americanexpress', 
        98216900, 'Thunder Tea Rice', 'STAFF-08'
    );
CALL insert_order_item(
        '20240304004', '2024-03-04', '14:04:38', 'card', 
        '3481-6980-7796-5230', 
        'americanexpress', 
        98216900, 'Thunder Tea Rice', 'STAFF-08'
    );
CALL insert_order_item(
        '20240305001', '2024-03-05', '09:59:53', 'card', 
        '3742-8375-6443-8590', 
        'americanexpress', 
        93603800, 'Rendang', 'STAFF-09'
    );
CALL insert_order_item(
        '20240305001', '2024-03-05', '09:59:53', 'card', 
        '3742-8375-6443-8590', 
        'americanexpress', 
        93603800, 'Rendang', 'STAFF-09'
    );
CALL insert_order_item(
        '20240305001', '2024-03-05', '09:59:53', 'card', 
        '3742-8375-6443-8590', 
        'americanexpress', 
        93603800, 'Rendang', 'STAFF-09'
    );
CALL insert_order_item(
        '20240305002', '2024-03-05', '14:34:56', 'card', 
        '3742-8889-7783-4510', 
        'americanexpress', 
        95624750, 'Rendang', 'STAFF-10'
    );
CALL insert_order_item(
        '20240305002', '2024-03-05', '14:34:56', 'card', 
        '3742-8889-7783-4510', 
        'americanexpress', 
        95624750, 'Rendang', 'STAFF-10'
    );
CALL insert_order_item(
        '20240305003', '2024-03-05', '17:34:06', 'card', 
        '5002-3537-1745-1926', 
        'mastercard', 
        85205752, 'Rendang', 'STAFF-11'
    );
CALL insert_order_item(
        '20240305004', '2024-03-05', '17:35:25', 'card', 
        '3742-8385-3694-9250', 
        'americanexpress', 
        NULL, 'Ayam Balado', 'STAFF-12'
    );
CALL insert_order_item(
        '20240305005', '2024-03-05', '17:36:29', 'card', 
        '3403-2288-8123-5330', 
        'americanexpress', 
        NULL, 'Ayam Balado', 'STAFF-03'
    );
CALL insert_order_item(
        '20240305005', '2024-03-05', '17:36:29', 'card', 
        '3403-2288-8123-5330', 
        'americanexpress', 
        NULL, 'Ayam Balado', 'STAFF-04'
    );
CALL insert_order_item(
        '20240305005', '2024-03-05', '17:36:29', 'card', 
        '3403-2288-8123-5330', 
        'americanexpress', 
        NULL, 'Sauerbraten', 'STAFF-01'
    );
CALL insert_order_item(
        '20240305005', '2024-03-05', '17:36:29', 'card', 
        '3403-2288-8123-5330', 
        'americanexpress', 
        NULL, 'Sauerbraten', 'STAFF-01'
    );
CALL insert_order_item(
        '20240305006', '2024-03-05', '17:56:16', 'card', 
        '3497-9717-6891-3400', 
        'americanexpress', 
        NULL, 'Ayam Balado', 'STAFF-06'
    );
CALL insert_order_item(
        '20240305006', '2024-03-05', '17:56:16', 'card', 
        '3497-9717-6891-3400', 
        'americanexpress', 
        NULL, 'Ayam Balado', 'STAFF-06'
    );
CALL insert_order_item(
        '20240305006', '2024-03-05', '17:56:16', 'card', 
        '3497-9717-6891-3400', 
        'americanexpress', 
        NULL, 'Ayam Balado', 'STAFF-06'
    );
CALL insert_order_item(
        '20240305006', '2024-03-05', '17:56:16', 'card', 
        '3497-9717-6891-3400', 
        'americanexpress', 
        NULL, 'Bun Cha', 'STAFF-05'
    );
CALL insert_order_item(
        '20240306001', '2024-03-06', '12:30:27', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rinderrouladen', 'STAFF-02'
    );
CALL insert_order_item(
        '20240306001', '2024-03-06', '12:30:27', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rinderrouladen', 'STAFF-02'
    );
CALL insert_order_item(
        '20240306002', '2024-03-06', '13:24:08', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Bun Cha', 'STAFF-08'
    );
CALL insert_order_item(
        '20240306002', '2024-03-06', '13:24:08', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Gudeg', 'STAFF-07'
    );
CALL insert_order_item(
        '20240306002', '2024-03-06', '13:24:08', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Gudeg', 'STAFF-07'
    );
CALL insert_order_item(
        '20240306002', '2024-03-06', '13:24:08', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Gudeg', 'STAFF-07'
    );
CALL insert_order_item(
        '20240306003', '2024-03-06', '14:52:02', 'card', 
        '5580-9476-7037-6028', 
        'mastercard', 
        93344468, 'Palak Paneer', 'STAFF-11'
    );
CALL insert_order_item(
        '20240306003', '2024-03-06', '14:52:02', 'card', 
        '5580-9476-7037-6028', 
        'mastercard', 
        93344468, 'Palak Paneer', 'STAFF-12'
    );
CALL insert_order_item(
        '20240307001', '2024-03-07', '10:08:59', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rendang', 'STAFF-09'
    );
CALL insert_order_item(
        '20240307001', '2024-03-07', '10:08:59', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rendang', 'STAFF-09'
    );
CALL insert_order_item(
        '20240307001', '2024-03-07', '10:08:59', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rendang', 'STAFF-09'
    );
CALL insert_order_item(
        '20240307002', '2024-03-07', '10:18:41', 'card', 
        '3723-0124-5489-1920', 
        'americanexpress', 
        NULL, 'Ayam Balado', 'STAFF-10'
    );
CALL insert_order_item(
        '20240307003', '2024-03-07', '11:03:59', 'card', 
        '3746-2243-5619-5890', 
        'americanexpress', 
        NULL, 'Rendang', 'STAFF-01'
    );
CALL insert_order_item(
        '20240307003', '2024-03-07', '11:03:59', 'card', 
        '3746-2243-5619-5890', 
        'americanexpress', 
        NULL, 'Rendang', 'STAFF-01'
    );
CALL insert_order_item(
        '20240307004', '2024-03-07', '11:25:44', 'cash', 
        NULL, 
        NULL, 
        NULL, 'Rendang', 'STAFF-03'
    );
CALL insert_order_item(
        '20240307005', '2024-03-07', '15:40:23', 'card', 
        '5108-7557-3480-9949', 
        'mastercard', 
        NULL, 'Gudeg', 'STAFF-04'
    );
CALL insert_order_item(
        '20240307005', '2024-03-07', '15:40:23', 'card', 
        '5108-7557-3480-9949', 
        'mastercard', 
        NULL, 'Gudeg', 'STAFF-04'
    );
CALL insert_order_item(
        '20240307005', '2024-03-07', '15:40:23', 'card', 
        '5108-7557-3480-9949', 
        'mastercard', 
        NULL, 'Gudeg', 'STAFF-04'
    );
CALL insert_order_item(
        '20240307006', '2024-03-07', '15:41:29', 'card', 
        '4041-5976-8082-0030', 
        'visa', 
        83187835, 'Rinderrouladen', 'STAFF-02'
    );
CALL insert_order_item(
        '20240308001', '2024-03-08', '10:34:41', 'card', 
        '5100-1491-9212-0304', 
        'mastercard', 
        NULL, 'Bun Cha', 'STAFF-05'
    );
CALL insert_order_item(
        '20240308002', '2024-03-08', '12:22:29', 'card', 
        '5100-1476-0010-6766', 
        'mastercard', 
        87547836, 'Palak Paneer', 'STAFF-06'
    );
CALL insert_order_item(
        '20240308002', '2024-03-08', '12:22:29', 'card', 
        '5100-1476-0010-6766', 
        'mastercard', 
        87547836, 'Palak Paneer', 'STAFF-06'
    );
CALL insert_order_item(
        '20240308002', '2024-03-08', '12:22:29', 'card', 
        '5100-1476-0010-6766', 
        'mastercard', 
        87547836, 'Palak Paneer', 'STAFF-06'
    );
CALL insert_order_item(
        '20240308002', '2024-03-08', '12:22:29', 'card', 
        '5100-1476-0010-6766', 
        'mastercard', 
        87547836, 'Palak Paneer', 'STAFF-06'
    );
CALL insert_order_item(
        '20240308003', '2024-03-08', '13:53:02', 'card', 
        '3746-2267-7977-3800', 
        'americanexpress', 
        NULL, 'Gudeg', 'STAFF-07'
    );