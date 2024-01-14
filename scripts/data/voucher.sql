insert into public.voucher (id, created_by, code, is_delivery_voucher, is_percent, valid_from, valid_until, min_order_value, percent_discount, max_discounted_value, value_discount, quantity, is_deleted, created_at, deleted_at, name, description)
values  (18, 27, 'BTP-V1222-TET', false, true, '2023-12-20 18:04:53.791000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 0, 0.5, 75000, 0, 100, false, '2023-12-21 18:15:37.660000 +00:00', null, 'Giảm giá shop Tết 2024', 'Marie-Voucher22-Lunar-12'),
        (21, 2, 'THIENAN-109H3-2024', false, true, '2023-12-20 18:04:53.791000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 0, 0.45, 120000, 0, 100, false, '2023-12-21 18:18:13.852000 +00:00', null, 'Giảm giá shop năm 2024 Loai 2', 'ThienAn-Vcher-2024'),
        (8, 2, 'SINHNHAT1', false, true, '2023-11-27 12:20:28.447000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 0, 0.1, 25000, 0, 100, false, '2023-11-27 12:42:10.861000 +00:00', null, 'SINHNHAT1', 'Giảm giá sinh nhật 1 tuổi'),
        (15, 2, '111', false, true, '2023-12-16 18:47:35.155000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 0, 0.5, 1, 1, 100, false, '2023-12-15 18:49:07.223000 +00:00', null, '111', '11'),
        (14, 2, 'asd', false, true, '2023-12-15 18:28:20.062000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 0, 0.6, 1, 1, 100, false, '2023-12-15 18:35:01.337000 +00:00', null, 'asd', 'sdsad'),
        (9, 1, 'BTPVOUCHER-2', true, false, '2023-11-25 18:08:02.287000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 50000, 0, 0, 25000, 100, false, '2023-11-25 11:10:45.815294 +00:00', null, 'VOUCHER-Delivery 2', 'Chào mừng quý khách đến với BTP'),
        (7, 1, 'BTPVOUCHER-1', true, false, '2023-11-25 18:08:02.287000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 50000, 0, 0, 25000, 100, false, '2023-11-25 11:10:45.815294 +00:00', null, 'VOUCHER-Delivery', 'Chào mừng quý khách đến với BTP'),
        (6, 2, 'V-321TA', false, false, '2023-11-10 09:59:44.541000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 50000, 0, 0, 30000, 100, false, '2023-11-14 10:13:55.637000 +00:00', null, 'VOUCHER-Tri Ân', 'Tri Ân Khách Hàng - Giảm giá'),
        (20, 2, 'THIENAN-109H2-2024', false, false, '2023-12-20 18:04:53.791000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 50000, 0, 0, 40000, 100, false, '2023-12-21 18:17:37.120000 +00:00', null, 'Giảm giá shop năm 2024', 'ThienAn-Vcher-2024'),
        (19, 27, 'BTP-V1222-2024', false, false, '2023-12-20 18:04:53.791000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 50000, 0, 0, 40000, 99, false, '2023-12-21 18:16:25.325000 +00:00', null, 'Giảm giá shop năm 2024', 'Marie-Voucher25-Lunar-12'),
        (16, 1, 'BTP-V1222', true, false, '2023-12-20 18:04:53.791000 +00:00', '2024-02-21 18:04:53.791000 +00:00', 50000, 0, 0, 40000, 100, false, '2023-12-21 18:11:53.712000 +00:00', null, 'Giảm giá vc tháng 12', 'BTP-Voucher22-12'),
        (17, 1, 'BTP-V1222-TET', true, false, '2023-12-20 18:04:53.791000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 50000, 0, 0, 40000, 100, false, '2023-12-21 18:12:48.557000 +00:00', null, 'Giảm giá vc Tết 2024', 'BTP-Voucher22-Lunar-12'),
        (23, 1, 'ahihi 123 1234', true, true, '2024-01-03 12:12:37.579000 +00:00', '2024-01-14 12:12:37.579000 +00:00', 0, 0.1, 10000, 0, 100, false, '2024-01-03 12:14:41.344000 +00:00', null, 'Voucher nè', 'Add vô là khuyến mãi'),
        (1, 2, 'VOUCHERSHOP2', false, true, '2023-11-09 21:10:31.249000 +00:00', '2024-03-21 18:04:53.791000 +00:00', 200000, 0.5, 1000000, 0, 97, false, '2023-11-10 21:11:48.183000 +00:00', null, 'VOUCHER-KhaiChuong', 'Mừng dịp khai trương'),
        (24, 1, 'DEL2024', true, true, '2024-01-07 01:10:08.157000 +00:00', '2024-02-18 01:10:08.157000 +00:00', 10000, 0.6, 15000, 0, 50, false, '2024-01-07 01:11:56.568000 +00:00', null, 'Admin Discount đón tết', 'Tết 2024'),
        (25, 1, 'DEL2024', true, true, '2024-01-07 01:10:08.157000 +00:00', '2024-02-18 01:10:08.157000 +00:00', 10000, 0.6, 15000, 0, 50, false, '2024-01-07 01:14:06.101000 +00:00', null, 'Admin Discount đón tết', 'Tết 2024'),
        (26, 1, 'PLATFORMV_12012024', true, true, '2024-01-11 21:31:09.354000 +00:00', '2024-01-27 21:31:09.354000 +00:00', 100000, 0.2, 100000, 25000, 100, false, '2024-01-11 21:32:32.919000 +00:00', null, 'Platform voucher 2024', 'Platform voucher 2024');