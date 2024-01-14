insert into public.account (id, username, first_name, last_name, role, phone, email, description, status, created_at, deleted_at, updated_at, created_by, deleted_by, updated_by, password, banned_at, banned_by, birthday, shop_name, shop_description, media, avatar, feedback_count, approved_by, approved_at)
values  (22, 'customer', 'Duy', 'Trần', 'CUSTOMER', '0912211332', 'customer@outlook.com', 'The very first customer', 'ACTIVE', '2023-10-22 12:59:05.359994 +00:00', null, '2023-12-03 02:55:58.849131 +00:00', 3, null, 3, '$2a$12$CeODYlf5ErNsYv6PzuliEOuIKGSw7Lrim8k8/Da43Z7YJX6nWC2v.', null, null, '2023-10-20', null, null, null, null, null, null, null),
        (21, 'deliverer_01', 'John', 'Doe', 'DELIVERER', '405897648957', 'lmao@gmail.com', 'string', 'ACTIVE', '2023-10-24 12:44:16.825000 +00:00', null, '2023-12-03 02:55:58.849131 +00:00', 21, null, 21, '$2a$12$CeODYlf5ErNsYv6PzuliEOuIKGSw7Lrim8k8/Da43Z7YJX6nWC2v.', null, null, '2023-10-25', null, null, null, null, null, null, null),
        (39, 'customer_02', 'Long', 'Trần Lê Phi', 'CUSTOMER', '0522457947', 'Abc@gmail.com', null, 'ACTIVE', '2023-12-29 10:25:58.901000 +00:00', null, null, 39, null, null, '$2a$10$Y19OJg7SfWACxECXfl42V.qYNh28K2ObRF0IIhm6phgNOTkQD3Mt.', null, null, '2023-12-28', null, null, 'null', 'null', null, null, null),
        (40, 'customer_99', 'Quân', 'Đặng Minh', 'CUSTOMER', '0123456789', 'Abc@gmail.com', null, 'ACTIVE', '2023-12-29 10:29:19.742000 +00:00', null, null, 40, null, null, '$2a$10$29ouvzELMyFyqNLNDkKPtepUWJhU3H3BuLX/zAWJH.HfQ1GUloMkO', null, null, '2023-12-20', null, null, 'null', 'null', null, null, null),
        (30, 'ahihi', 'Hua', 'Di Wan', 'SHOP', '1234567890', 'huadiwan@gmail.com', 'Xin chào, tôi là shopowner đã bị ban', 'BANNED', '2023-12-11 14:17:24.461000 +00:00', null, '2023-12-15 13:29:17.971548 +00:00', 30, null, 30, '$2a$10$0NzFEtuCCReTWCtCIcNpy.Byjnn5uf4hZ7H8giIWaSyvf9nru1yEO', '2023-12-12 13:19:02.973818 +00:00', 1, '2023-12-11', 'HuaDiWan', '禁止', 'null', 'null', null, null, null),
        (33, 'tungndee', 'Tùng', 'Nguyễn', 'CUSTOMER', '0946448856', 'tungnse.vn@gmail.com', 'Tung Customer', 'ACTIVE', '2023-12-12 13:06:04.346000 +00:00', null, '2023-12-12 13:12:32.998008 +00:00', 33, null, 33, '$2a$12$.fCLXdnlf3crROAT8mTM9er8pFbJ0PYpmGnf.lJ92WmIV5D5OOv4y', null, null, '1970-12-12', null, null, 'null', '{"mediaJsonObjects": [{"mediaKeys": "38630205-c6e6-4284-a00e-6695672e2d5e", "mediaType": "image/jpeg"}]}', null, null, null),
        (31, 'meine', 'Nguyễn', 'Mai', 'SHOP', '1234567890', 'Shop@gmail.com', 'Có bán chim độc lạ', 'INACTIVE', '2023-12-11 14:55:47.294000 +00:00', null, '2023-12-15 13:31:19.243191 +00:00', 31, null, 31, '$2a$10$avvovmJ0OwVbXSiKsD6HLO4lG2RZ4oS78JdnfbYF2LoTtRAcTwdQu', null, null, '2009-01-09', 'Shop này bán Chim', 'Có bán chim độc lạ', 'null', 'null', null, 35, '2023-12-14 23:53:01.225000 +00:00'),
        (43, 'Dmq99', 'Quân', 'Đặng Minh', 'CUSTOMER', '0125649785', 'minh.quan@gmail.com', null, 'ACTIVE', '2023-12-29 15:23:20.098000 +00:00', null, null, 43, null, null, '$2a$10$9hvvvkeQEvv71esV9n1HTeD..9je50jg9Yy7PEnd24OKdFnkarXl.', null, null, '2023-12-29', null, null, 'null', 'null', null, null, null),
        (1, 'btp_admin', 'Tùng', 'Nguyễn', 'ADMIN', '0946447768', 'tungndse@gmail.com', 'Admin chính', 'ACTIVE', '2023-10-03 05:09:33.840794 +00:00', null, '2023-12-14 23:46:12.221779 +00:00', 1, null, 1, '$2a$12$CeODYlf5ErNsYv6PzuliEOuIKGSw7Lrim8k8/Da43Z7YJX6nWC2v.', null, null, '1993-01-11', null, null, null, null, null, null, null),
        (35, 'btp_admin02', 'Mike', 'Nigger', 'ADMIN', '0911123111', 'tungnse.vn@gmail.com', 'Admin thứ 2', 'ACTIVE', '2023-12-14 23:46:12.221779 +00:00', null, null, 1, null, null, '$2a$12$CeODYlf5ErNsYv6PzuliEOuIKGSw7Lrim8k8/Da43Z7YJX6nWC2v.', null, null, '1988-01-01', null, null, null, null, null, null, null),
        (37, 'shop_04', 'Nguyễn', 'Hi', 'SHOP', '1234567890', 'ahihi@gmail.com', 'ahihi 1234', 'INACTIVE', '2023-12-29 10:22:06.412000 +00:00', null, '2024-01-11 21:43:30.137779 +00:00', 37, null, 37, '$2a$10$vau0xUyOI3MWcuWvQqlaPexNbMlpUwytZ7NHqmSzwWv.zXFRUjCjG', null, null, '2023-12-29', 'Shop bán chim', 'ahihi 1234', 'null', 'null', null, 1, '2024-01-11 21:43:30.141000 +00:00'),
        (34, 'Mq04052001', 'Quan', 'Dang Minh', 'CUSTOMER', '0522457947', 'minh.quan040501@gmail.com', null, 'BANNED', '2023-12-13 14:26:16.311000 +00:00', null, '2024-01-11 21:46:14.021063 +00:00', 34, null, 34, '$2a$10$EgwFruCNDoYca6BYUyC00Ond9zVJuoXM8gWuwZ/ZRJTk3FGoCXka2', '2024-01-11 21:46:14.021063 +00:00', 1, '2023-12-13', null, null, 'null', 'null', null, null, null),
        (27, 'shop_02', 'Mary', 'Curie', 'SHOP', '0933932407', 'shop02@outlook.com', 'Cạnh tranh lành mạnh', 'ACTIVE', '2023-12-02 11:29:58.425000 +00:00', null, '2023-12-15 13:31:19.243191 +00:00', 27, null, 27, '$2a$12$CeODYlf5ErNsYv6PzuliEOuIKGSw7Lrim8k8/Da43Z7YJX6nWC2v.', null, null, '1980-10-10', 'Marie Curie', 'Bán chim, lồng chim, v.v.... giá rẻ', '{"mediaJsonObjects": [{"mediaKeys": "87d933dd-e983-410e-9df9-c215503026e2", "mediaType": "image/jpeg"}]}', null, null, null, null),
        (28, 'shop_03', 'Nguyễn', 'Bằng', 'SHOP', '0123456787', 'shop@gmail.com', 'Shop vip prpo', 'ACTIVE', '2023-12-03 01:19:51.719000 +00:00', null, '2023-12-15 13:31:19.243191 +00:00', 28, null, 28, '$2a$12$CeODYlf5ErNsYv6PzuliEOuIKGSw7Lrim8k8/Da43Z7YJX6nWC2v.', null, null, '2023-12-03', 'Shop Vip', 'Shop vip pro', 'null', null, null, null, null),
        (36, 'shop_ricola', 'Steven', 'Kings', 'SHOP', '0946447768', 'saints.sszj@gmail.com', 'My name is SK', 'AWAIT_APPROVAL', '2023-12-28 04:48:40.089000 +00:00', null, null, 36, null, null, '$2a$10$pBZ5NsGg1VkXfjre7IaCzuKsL.NBscYwFp/.y88GDIU/MwPZRZJnC', null, null, '2023-12-28', 'RICOLA', 'Since 1930, the Richterich family have made Ricola from naturally good Swiss birds.', '{"mediaJsonObjects": [{"mediaKeys": "02769217-3670-421e-8e05-987304816fb8", "mediaType": "image/jpeg"}]}', '{"mediaJsonObjects": [{"mediaKeys": "08ea0654-93b0-4d6a-917b-ff4b932e5108", "mediaType": "image/jpeg"}]}', null, null, null),
        (29, 'nta_shop', 'Ân', 'Ngô Thừa', 'SHOP', '1234567890', 'tungndse@gmail.com', 'Tôi là người Trung quốc', 'INACTIVE', '2023-12-11 13:45:09.585000 +00:00', null, '2024-01-12 17:51:39.662075 +00:00', 29, null, 29, '$2a$10$B265V3aQDZ0xTJ68nVYy6OZz0wSa4QWL2/I6GMC1.QPr0U3jy/hz2', null, null, '2023-12-11', 'Chim Cảnh Trung Hoa', '西游记', '{"mediaJsonObjects": []}', 'null', null, 1, '2024-01-12 17:51:39.672000 +00:00'),
        (38, 'customer_04', 'Nguyễn', 'Hi', 'CUSTOMER', '1234567890', 'ahihi@gmail.com', '', 'ACTIVE', '2023-12-29 10:23:46.607000 +00:00', null, null, 38, null, null, '$2a$10$Rtc4OQIP.3/fR0sMUrqEbu1YWhOUS65DZyyHwbcn13O4Koe9jLAVK', null, null, '2023-12-29', null, null, 'null', 'null', null, null, null),
        (2, 'shop_01', 'Sơn', 'Trịnh', 'SHOP', '0912211331', 'shop.alpha@gmail', 'Shop đầu tiên của hệ thống nha', 'ACTIVE', '2023-10-01 19:59:30.456000 +00:00', null, '2023-12-29 19:34:37.301892 +00:00', 2, null, 1, '$2a$12$CeODYlf5ErNsYv6PzuliEOuIKGSw7Lrim8k8/Da43Z7YJX6nWC2v.', null, null, '2023-10-20', 'Thiên Ân', 'Bán các loại chim cảnh, thức ăn và phụ kiện cho chim', 'null', 'null', null, null, null),
        (42, 'abjghj6Ac', 'Quân', 'Đặng Minh', 'CUSTOMER', '052245794709911782', 'minh.quan040501@ghjdshil.com', null, 'BANNED', '2023-12-29 15:01:57.794000 +00:00', null, '2024-01-06 19:11:06.784758 +00:00', 42, null, 42, '$2a$10$nRYY8WljIZU.NpG8T6n8AuQUspMLkMgybAWvnaTPLmLPAez8HT4EC', '2024-01-06 19:11:06.784758 +00:00', 1, '2023-12-04', null, null, 'null', 'null', null, null, null),
        (41, 'Abc123', 'Quân', 'Đặng Minh', 'CUSTOMER', '1234567898', 'Mqd@gmail.com', null, 'BANNED', '2023-12-29 11:00:06.863000 +00:00', null, '2024-01-08 18:35:42.009101 +00:00', 41, null, 41, '$2a$10$ZgLvIbRIw.a9NQOawKdPr.6FNtdsI.mkAXgckawhZibACMwr4myGe', '2024-01-08 18:35:42.009101 +00:00', 1, '2023-12-29', null, null, 'null', 'null', null, null, null),
        (3, 'customer_01', 'Hải Phong', 'Trịnh Thanh', 'CUSTOMER', '0912211332', 'minh.quan040501@gmail.com', 'The very first customer', 'ACTIVE', '2023-10-22 12:59:05.359994 +00:00', null, '2023-12-21 15:24:02.006024 +00:00', 3, null, 3, '$2a$12$CeODYlf5ErNsYv6PzuliEOuIKGSw7Lrim8k8/Da43Z7YJX6nWC2v.', null, null, '2023-10-20', null, null, 'null', '{"mediaJsonObjects": [{"mediaKeys": "10d6f145-a95f-4623-8e70-f5879a00dda2", "mediaType": "image/jpeg"}]}', 21, null, null);