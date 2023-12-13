CREATE OR REPLACE FUNCTION fn_get_shop_product_count(_shop_id BIGINT, _product_type TEXT)
    RETURNS INT
    LANGUAGE plpgsql
AS
$$
DECLARE
    _count INT;
BEGIN
    IF _shop_id ISNULL THEN
        IF _product_type = 'BIRD'
        THEN
            SELECT COUNT(id) INTO _count FROM bird WHERE status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'CAGE'
        THEN
            SELECT COUNT(id) INTO _count FROM cage WHERE status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'ACCESSORY'
        THEN
            SELECT COUNT(id) INTO _count FROM accessory WHERE status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'FOOD'
        THEN
            SELECT COUNT(id) INTO _count FROM food WHERE status NOT IN ('DELETED', 'BANNED');
        ELSEIF _product_type ISNULL
        THEN
            SELECT fn_get_shop_product_count(NULL, 'BIRD')
                       + fn_get_shop_product_count(NULL, 'ACCESSORY')
                       + fn_get_shop_product_count(NULL, 'CAGE')
                       + fn_get_shop_product_count(NULL, 'FOOD')
            INTO _count;
        ELSE
            SELECT 0 INTO _count;
        END IF;
    ELSE
        IF _product_type = 'BIRD'
        THEN
            SELECT COUNT(id) INTO _count FROM bird WHERE shop_id = _shop_id AND status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'CAGE'
        THEN
            SELECT COUNT(id) INTO _count FROM cage WHERE shop_id = _shop_id AND status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'ACCESSORY'
        THEN
            SELECT COUNT(id)
            INTO _count
            FROM accessory
            WHERE shop_id = _shop_id
              AND status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'FOOD'
        THEN
            SELECT COUNT(id) INTO _count FROM food WHERE shop_id = _shop_id AND status NOT IN ('DELETED', 'BANNED');
        ELSEIF _product_type ISNULL
        THEN
            SELECT fn_get_shop_product_count(_shop_id, 'BIRD')
                       + fn_get_shop_product_count(_shop_id, 'ACCESSORY')
                       + fn_get_shop_product_count(_shop_id, 'CAGE')
                       + fn_get_shop_product_count(_shop_id, 'FOOD')
            INTO _count;
        ELSE
            SELECT 0 INTO _count;
        END IF;
    END IF;

    RETURN _count;
END ;
$$;

SELECT fn_get_shop_product_count(NULL, 'BIRD');

CREATE OR REPLACE FUNCTION fn_get_shop_customer_order_count(_account_id BIGINT, _order_status TEXT)
    RETURNS INT
    LANGUAGE plpgsql
AS
$$
DECLARE
    _count INT;
    _role  TEXT;
BEGIN

    IF _account_id ISNULL THEN
        IF _order_status ISNULL THEN
            SELECT COUNT(id) INTO _count FROM customer_order;
        ELSE
            SELECT COUNT(id) INTO _count FROM customer_order WHERE status = _order_status;
        END IF;
    ELSE
        SELECT role INTO _role FROM account WHERE id = _account_id;

        IF _role = 'CUSTOMER' THEN
            IF _order_status IS NULL THEN
                SELECT COUNT(id)
                INTO _count
                FROM customer_order
                WHERE customer_id = _account_id
                  AND status != 'DELETED';
            ELSE
                SELECT COUNT(id)
                INTO _count
                FROM customer_order
                WHERE customer_id = _account_id
                  AND status = _order_status;
            END IF;
        ELSIF _role = 'SHOP' THEN
            IF _order_status IS NULL THEN
                SELECT COUNT(id)
                INTO _count
                FROM customer_order
                WHERE shop_id = _account_id
                  AND status NOT IN ('AWAIT_PAYMENT', 'CANCELLED', 'DELETED');
            ELSE
                SELECT COUNT(id)
                INTO _count
                FROM customer_order
                WHERE shop_id = _account_id
                  AND status = _order_status
                  AND status NOT IN ('AWAIT_PAYMENT', 'CANCELLED', 'DELETED');
            END IF;
        ELSE
            SELECT 0 INTO _count;
        END IF;
    END IF;

    RETURN _count;
END;
$$;

SELECT COUNT(id), status
FROM customer_order
GROUP BY status;

SELECT COUNT(id)
FROM customer_order
WHERE shop_id = 2
  AND status NOT IN ('AWAIT_PAYMENT', 'CANCELLED', 'DELETED');

SELECT fn_get_shop_customer_order_count(2, 'PENDING');