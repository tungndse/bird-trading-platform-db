---------- SHARED FUNCTIONS ------------
CREATE OR REPLACE FUNCTION sp_save_deleted_at() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.deleted_at = CURRENT_TIMESTAMP;
    RETURN new;
END;
$$;

CREATE OR REPLACE FUNCTION sp_save_updated_at() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.updated_at = CURRENT_TIMESTAMP;
    RETURN new;
END;
$$;

CREATE OR REPLACE FUNCTION sp_save_updated_at_for_referenced()
    RETURNS TRIGGER AS
$$
BEGIN
    UPDATE product
    SET updated_at = CURRENT_TIMESTAMP
    FROM (SELECT DISTINCT product_id FROM old_table) AS od
    WHERE product.id = od.product_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_save_read_at()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.read_at = CURRENT_TIMESTAMP;
    RETURN new;
END;
$$;


------ DELIVERY TARIFF ------------

CREATE OR REPLACE FUNCTION auto_generate_delivery_distinct_tariff(_type TEXT, _max_weight INT)
    RETURNS VOID AS
$$
DECLARE
    std_top          NUMERIC;
    value_temp       NUMERIC;
    from_weight_temp INT;
    to_weight_temp   INT;
    value_step       NUMERIC;

BEGIN
    std_top := (SELECT MAX(value)
                FROM package_delivery_distinct_tariff
                WHERE type = _type
                GROUP BY type = _type);

    value_temp := std_top;

    value_step := std_top - (SELECT value
                             FROM package_delivery_distinct_tariff
                             WHERE type = _type
                             ORDER BY value DESC
                             OFFSET 1 LIMIT 1);

    from_weight_temp := (SELECT MAX(from_weight)
                         FROM package_delivery_distinct_tariff
                         WHERE type = _type
                         GROUP BY type = _type);

    to_weight_temp := (SELECT MAX(to_weight)
                       FROM package_delivery_distinct_tariff
                       WHERE type = _type
                       GROUP BY type = _type);

    WHILE to_weight_temp < _max_weight
        LOOP
            from_weight_temp := from_weight_temp + 500;
            to_weight_temp := to_weight_temp + 500;
            value_temp := value_temp + value_step;
            INSERT INTO package_delivery_distinct_tariff (type, from_weight, to_weight, value)
            VALUES (_type, from_weight_temp, to_weight_temp, value_temp);
        END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_package_delivery_fee(_type TEXT,
                                                          _package_weight INT, _package_width INT,
                                                          _package_length INT, _package_height INT)
    RETURNS NUMERIC AS
$$
DECLARE
    norm_weight                 INT;
    target_saturated_to_weight  INT;
    target_saturated_value      NUMERIC;
    target_saturated_value_step NUMERIC;
    temp_weight_to              INT;
    count                       SMALLINT;
BEGIN
    target_saturated_to_weight := (SELECT saturated_to_weight FROM package_delivery_metadata WHERE type = _type);

    target_saturated_value := (SELECT saturated_value FROM package_delivery_metadata WHERE type = _type);

    target_saturated_value_step := (SELECT saturated_value_step FROM package_delivery_metadata WHERE type = _type);


    norm_weight := (_package_width * _package_length * _package_height) / (SELECT standard_cubic_cm_per_kg
                                                                           FROM package_delivery_metadata
                                                                           WHERE type = _type);
    IF _package_weight > norm_weight * 1000
    THEN
        norm_weight := _package_weight;
    END IF;

    temp_weight_to := target_saturated_to_weight;
    count := 0;

    IF norm_weight > target_saturated_to_weight
    THEN
        WHILE temp_weight_to < norm_weight
            LOOP
                temp_weight_to := temp_weight_to + 500;
                count := count + 1;
            END LOOP;
        RETURN target_saturated_value + target_saturated_value_step * count;
    ELSE
        RETURN (SELECT value
                FROM package_delivery_distinct_tariff
                WHERE type = _type
                  AND norm_weight >= from_weight
                  AND norm_weight <= to_weight);

    END IF;

END;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_account_status_timestamp(status_ TEXT)
    RETURNS INT AS
$$
BEGIN
    IF status_ = 'BANNED'
    THEN
        UPDATE account
        SET banned_at = CURRENT_TIMESTAMP
        FROM (SELECT DISTINCT id FROM old_table) AS od
        WHERE account.id = od.id;

    ELSIF status_ = 'DELETED'
    THEN
        UPDATE account
        SET deleted_at = CURRENT_TIMESTAMP
        FROM (SELECT DISTINCT id FROM old_table) AS od
        WHERE account.id = od.id;


    END IF;
END;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_auto_update_timestamp_for_status
    AFTER UPDATE
    ON account
    REFERENCING old TABLE AS old_table
    FOR EACH STATEMENT
EXECUTE FUNCTION update_account_status_timestamp_banned_at();

CREATE OR REPLACE FUNCTION update_account_status_timestamp_banned_at()
    RETURNS TRIGGER AS
$$
BEGIN

    UPDATE account
    SET banned_at = CURRENT_TIMESTAMP
    FROM (SELECT DISTINCT id FROM old_table) AS od
    WHERE account.id = od.id;


END;

$$ LANGUAGE plpgsql;




