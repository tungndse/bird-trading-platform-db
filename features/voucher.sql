CREATE TABLE voucher
(
    id                   BIGSERIAL PRIMARY KEY,
    shop_id              BIGINT, -- NULL = PLATFORM

    code                 TEXT                                  NOT NULL,

    is_delivery_voucher  BOOLEAN,
    is_percent           BOOLEAN,

    valid_from           TIMESTAMPTZ                           NOT NULL,
    valid_until          TIMESTAMPTZ                           NOT NULL,

    min_order_value      NUMERIC     DEFAULT 0                 NOT NULL,

    percent_discount     FLOAT       DEFAULT 0,
    max_discounted_value NUMERIC,

    value_discount       NUMERIC     DEFAULT 0,

    available_item_count SMALLINT    DEFAULT 5                 NOT NULL,
    published_item_count SMALLINT    DEFAULT 0                 NOT NULL,

    is_deleted           BOOLEAN,

    created_at           TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at           TIMESTAMPTZ,

    CONSTRAINT fk_voucher_shop FOREIGN KEY (shop_id) REFERENCES account,
    CONSTRAINT chk_voucher_percent_discount CHECK ( percent_discount >= 0 AND percent_discount < 1 ),
    CONSTRAINT chk_voucher_value_discount CHECK ( value_discount >= 0
                                                      AND value_discount <= voucher.min_order_value ),
    CONSTRAINT chk_voucher_min_order_value CHECK ( min_order_value >= 0 ),
    CONSTRAINT chk_voucher_max_discounted_value CHECK ( max_discounted_value >= 0 ),
    CONSTRAINT chk_voucher_available_item_count CHECK ( available_item_count > 0 ),
    CONSTRAINT chk_voucher_published_item_count CHECK ( published_item_count > 0 AND
                                                        published_item_count <= voucher.available_item_count)
);

CREATE TABLE voucher_item
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    voucher_id  BIGINT                NOT NULL,
    customer_id BIGINT                NOT NULL,

    is_used     BOOLEAN,
    used_at     TIMESTAMPTZ,
    used_on     BIGINT,

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