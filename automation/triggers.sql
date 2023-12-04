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


CREATE or REPLACE TRIGGER tr_customer_order_updated_at_auto_fill
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
$$




CREATE or replace FUNCTION fn_generate_order_code() RETURNS trigger
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.order_code := concat('BTP-', TO_CHAR(NOW(), 'DDMMYYYY'), '-', REPLACE(FORMAT('%5s', new.id), ' ', '0'));
    RETURN new;
END
$$;

CREATE TRIGGER tr_customer_order_insert_generate_code
    BEFORE INSERT
    ON customer_order
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_order_code();



SELECT TO_CHAR(NOW(), 'DD-MM-YYYY');

SELECT REPLACE(FORMAT('%5s', 11111111), ' ', '0');


select 'BTP-' + TO_CHAR(NOW(), 'DD-MM-YYYY') + REPLACE(FORMAT('%5s', 55), ' ', '0');

select concat('BTP-', TO_CHAR(NOW(), 'DDMMYYYY'), '-', REPLACE(FORMAT('%5s', 11111155), ' ', '0'));



-- auto-generated definition
create or replace trigger tr_customer_order_insert_generate_code
    before insert
    on customer_order
    for each row
execute procedure fn_generate_order_code();

create or replace function fn_generate_order_code() returns trigger
    language plpgsql
as
$$
BEGIN
    new.order_code := concat('BTP-', TO_CHAR(NOW(), 'DDMMYYYY'), '-', REPLACE(FORMAT('%5s', new.id), ' ', '0'));
    RETURN new;
END
$$;

create or replace trigger tr_customer_order_insert_generate_code
    before insert
    on payment
    for each row
execute procedure fn_generate_payment_code();

create or replace function fn_generate_payment_code() returns trigger
    language plpgsql
as
$$
BEGIN
    new.payment_code := concat('BTP-', TO_CHAR(NOW(), 'DDMMYYYY'), '-', REPLACE(FORMAT('%5s', new.id), ' ', '0'));
    RETURN new;
END
$$;




