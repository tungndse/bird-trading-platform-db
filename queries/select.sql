SELECT wd.code, wd.full_name, wd.name_en, wdt.*
FROM ward wd
         INNER JOIN (SELECT dt.code,
                            dt.full_name AS district_name,
                            p.code       AS province_code,
                            p.full_name  AS province_name
                     FROM district dt
                              INNER JOIN public.province p ON dt.province_code = p.code) AS wdt
                    ON wd.district_code = wdt.code
WHERE wd.name_en LIKE '%An Phu%'
  AND wdt.province_name = 'Thành phố Hồ Chí Minh';


SELECT pdt.weight_from, pdt.weight_to, dt.code_name AS khoangcach, pdt.value
FROM package_delivery_tariff pdt
         INNER JOIN distance_type dt ON pdt.distance_type_id = dt.id

SELECT pdt.weight_from, pdt.weight_to, dt.code_name AS khoangcach, pdt.value
FROM package_delivery_tariff pdt
         INNER JOIN distance_type dt ON pdt.distance_type_id = dt.id
WHERE pdt.weight_from < 300
  AND pdt.weight_to > 300
  AND dt.distance_from < 80
  AND dt.distance_to > 80
  AND weight_from != 0;

SELECT *
FROM account ;

SELECT status, count(*) FROM customer_order
GROUP BY status;

SELECT count(id) from customer_order;

SELECT 84000*0.85*5;

select 200*20;

SELECT (4000 - 2000)/500*12000 + 70250;

SELECT feedback.rating,
       customer_order_item.type,
       customer_order_item.accessory_id,
       customer_order_item.sub_bird_id,
       sub_bird.bird_id,
       customer_order_item.sub_food_id,
       sub_food.food_id,
       customer_order_item.sub_cage_id,
       sub_cage.cage_id,
       feedback.id,
       feedback.content,
       customer_order_item.id,
       customer_order_item.type,
       customer_order.id,
       customer_order.customer_id,
       customer_order.shop_id,
       customer_order.status
FROM feedback
         INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
         INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
         LEFT JOIN accessory ON accessory_id = accessory.id
         LEFT JOIN sub_bird ON sub_bird_id = sub_bird.id
         LEFT JOIN sub_food ON sub_food_id = sub_food.id
         LEFT JOIN sub_cage ON sub_cage_id = sub_cage.id
where feedback.id in (15, 16)
;