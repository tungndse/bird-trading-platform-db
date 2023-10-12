CREATE TABLE voucher
(
    id                  BIGSERIAL PRIMARY KEY,
    shop_id             BIGINT,

    code                TEXT                                  NOT NULL,

    is_platform         BOOLEAN,
    is_percent          BOOLEAN,
    is_deleted          BOOLEAN,
    delivery_included   BOOLEAN,

    created_at          TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at          TIMESTAMPTZ,
    valid_from          TIMESTAMPTZ                           NOT NULL,
    valid_till          TIMESTAMPTZ                           NOT NULL,

    percent_discount    FLOAT       DEFAULT 0,
    value_discount      NUMERIC     DEFAULT 0,

    min_value_required  NUMERIC     DEFAULT 0                 NOT NULL,
    max_available_count SMALLINT    DEFAULT 5                 NOT NULL,
    published_count     SMALLINT    DEFAULT 0                 NOT NULL,

    CONSTRAINT fk_voucher_shop FOREIGN KEY (shop_id) REFERENCES account,
    CONSTRAINT chk_voucher_percent_discount CHECK ( percent_discount >= 0 AND percent_discount < 1 ),
    CONSTRAINT chk_voucher_value_discount CHECK ( value_discount >= 0 AND value_discount < voucher.min_value_required ),
    CONSTRAINT chk_voucher_min_value_required CHECK ( min_value_required >= 0 ),
    CONSTRAINT chk_voucher_max_available_count CHECK ( voucher.max_available_count > 0 )
);

CREATE TABLE voucher_item
(
    id               BIGSERIAL PRIMARY KEY NOT NULL,
    voucher_id       BIGINT                NOT NULL,
    customer_id      BIGINT                NOT NULL,

    is_used          BOOLEAN,
    used_at          TIMESTAMPTZ,
    used_on BIGINT,

    CONSTRAINT fk_voucher_item_voucher FOREIGN KEY (voucher_id) REFERENCES voucher,
    CONSTRAINT fk_voucher_item_customer FOREIGN KEY (customer_id) REFERENCES account,
    CONSTRAINT fk_voucher_item_used_on_order FOREIGN KEY (used_on) REFERENCES customer_order
);

---- EXPLAIN ----
/*
    Order has voucher_id, voucher_item has order_id => voucher_id may be attached to an order
    but may not be used (cancelled, not confirmed yet), but once shop confirmed the order,
    it's voucher_item's used_on will be assigned an order_id,
    means that the voucher_item is used.
*/