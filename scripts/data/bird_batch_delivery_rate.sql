insert into public.bird_batch_delivery_rate (id, delivery_type_id, quantity_from, quantity_to, rate)
values  (1, 1, 0, 1, 1),
        (2, 1, 2, 5, 0.75),
        (3, 1, 6, 20, 0.6),
        (4, 1, 21, null, 0.35),
        (5, 2, 0, 1, 1),
        (6, 2, 2, 5, 0.7),
        (7, 2, 6, 20, 0.55),
        (8, 2, 21, null, 0.35),
        (9, 4, 0, 1, 1),
        (10, 4, 2, 5, 0.85),
        (11, 4, 6, 20, 0.7),
        (12, 4, 21, null, 0.65),
        (13, 3, 0, null, 1);