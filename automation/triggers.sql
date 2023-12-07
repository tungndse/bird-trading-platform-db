CREATE TRIGGER tr_account_status_update
    BEFORE UPDATE
        OF status
    ON account
    FOR EACH ROW
EXECUTE PROCEDURE fn_account_set_event_saver_for_tr_account_status_update();

CREATE TRIGGER tr_account_details_update
    BEFORE UPDATE
        OF password, first_name, last_name, role, phone, email, description, birthday
    ON account
    FOR EACH ROW
EXECUTE PROCEDURE fn_account_set_event_saver_for_tr_account_details_update();

CREATE TRIGGER tr_account_insert
    BEFORE INSERT
    ON account
    FOR EACH ROW
EXECUTE PROCEDURE fn_account_set_event_saver_for_tr_account_insert();

CREATE FUNCTION fn_account_set_event_saver_for_tr_account_status_update() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF new.status = 'BANNED' AND old.status = 'ACTIVE' THEN
        new.banned_at := CURRENT_TIMESTAMP;

    ELSIF new.status = 'ACTIVE' AND old.status = 'BANNED' THEN
        new.banned_at := NULL;
        new.banned_by := NULL;

    ELSIF new.status = 'DELETED' AND old.status != 'DELETED' THEN
        new.deleted_at := CURRENT_TIMESTAMP;

        IF new.deleted_by IS NULL THEN
            new.deleted_by := new.id;
        END IF;

    END IF;
    RETURN new;
END;

$$;

ALTER FUNCTION fn_account_set_event_saver_for_tr_account_status_update() OWNER TO btp;

CREATE FUNCTION fn_account_set_event_saver_for_tr_account_details_update() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.updated_at = CURRENT_TIMESTAMP;

    IF new.updated_by IS NULL THEN
        new.updated_by := new.id;
    END IF;
    RETURN new;
END
$$;

ALTER FUNCTION fn_account_set_event_saver_for_tr_account_details_update() OWNER TO btp;

CREATE FUNCTION fn_account_set_event_saver_for_tr_account_insert() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF new.created_by IS NULL THEN
        new.created_by := new.id;
    END IF;
    RETURN new;
END
$$;

-- Auto generate a cosmetic id for customer order when created

CREATE TRIGGER tr_customer_order_insert_generate_code
    BEFORE INSERT
    ON customer_order
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_order_code();

CREATE FUNCTION fn_generate_order_code() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.order_code := CONCAT('BTP-', TO_CHAR(NOW(), 'DDMMYYYY'), '-', REPLACE(FORMAT('%5s', new.id), ' ', '0'));
    RETURN new;
END
$$;


CREATE OR REPLACE TRIGGER tr_customer_order_updated_at_auto_fill
    BEFORE UPDATE
    ON customer_order
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_updated_at();

CREATE OR REPLACE FUNCTION fn_generate_updated_at()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.updated_at = CURRENT_TIMESTAMP;
    RETURN new;
END;
$$;
---------


