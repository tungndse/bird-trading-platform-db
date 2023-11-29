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