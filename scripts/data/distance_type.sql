insert into public.distance_type (id, code_name, distance_from, distance_to, description)
values  (1, 'INNER_PROVINCE', null, null, 'Nội tỉnh'),
        (4, '300_INFINITE', 300, null, 'Từ 300 km trở lên'),
        (3, '100_300', 100, 300, 'Từ 100km đến dưới 300 km'),
        (2, 'BELOW_100', 0, 100, 'Dưới 100 km');