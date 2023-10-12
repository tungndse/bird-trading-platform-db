ALTER TABLE district
    ADD COLUMN latitude NUMERIC;
ALTER TABLE district
    ADD COLUMN longitude NUMERIC;


SELECT concat(dt.full_name, ', ', pv.full_name) , dt.full_name, pv.full_name
FROM district dt
         INNER JOIN province pv
                    ON dt.province_code = pv.code
ORDER BY dt.code
LIMIT 10;