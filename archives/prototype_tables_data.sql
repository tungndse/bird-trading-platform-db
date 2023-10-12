INSERT INTO package_delivery_distinct_tariff (type, from_weight, to_weight, value)
VALUES ('STD', 1, 504, 16500),
       ('STD', 505, 1004, 18300),
       ('STD', 1005, 1504, 19600),
       ('STD', 1505, 2504, 20700),
       ('STD', 2505, 3004, 21200),
       ('STD', 3005, 3504, 23600),
       ('ECO', 1, 254, 13500),
       ('ECO', 255, 504, 14750),
       ('ECO', 505, 1004, 14850),
       ('ECO', 1005, 2004, 16200),
       ('FAST', 1, 30000, 22000);

INSERT INTO public.package_delivery_metadata (type, saturated_value_step, saturated_value, max_weight, max_width,
                                              max_length, max_height, standard_cubic_cm_per_kg)
VALUES ('STD', 2400, 23600, 119994, 200, 200, 200, 6000),
       ('ECO', 1350, 16200, 200000, 100000, 100000, 100000, 6000),
       ('FAST', 0, 22000, 30000, 60, 60, 60, 6000);