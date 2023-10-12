CREATE TABLE customer_order -- created
(
    id                   BIGSERIAL PRIMARY KEY NOT NULL,
    customer_id          BIGINT                NOT NULL,
    shop_id              BIGINT                NOT NULL,
    delivery_id          BIGINT,
    voucher_id           BIGINT,
    payment_id           BIGINT,

    note                 TEXT,
    total_price          NUMERIC               NOT NULL DEFAULT 0,
    is_crafting_request  BOOLEAN,     -- to decide if this order is for 1. purchase or 2. crafting request

    status               TEXT                           DEFAULT 'PENDING',
    is_prepaid_payment   BOOLEAN,     --if order is prepaid payment type, payment (is_paid) must be made until the status can go to AWAITING
    is_paid              BOOLEAN,

    cancelled_at         TIMESTAMPTZ,
    paid_at              TIMESTAMPTZ, -- for COD method, is_paid and paid_at will be decided by deliverer
    confirmed_at         TIMESTAMPTZ,
    started_delivery_at  TIMESTAMPTZ,
    finished_delivery_at TIMESTAMPTZ,

    last_reported_at     TIMESTAMPTZ,
    report_decided_at    TIMESTAMPTZ,
    refunded_at          TIMESTAMPTZ,

    completed_at         TIMESTAMPTZ,

    CONSTRAINT fk_customer_order_customer FOREIGN KEY (customer_id) REFERENCES account (id),
    CONSTRAINT fk_customer_order_shop FOREIGN KEY (shop_id) REFERENCES account (id),
    CONSTRAINT fk_customer_order_delivery FOREIGN KEY (delivery_id) REFERENCES delivery (id),
    CONSTRAINT fk_customer_order_voucher FOREIGN KEY (voucher_id) REFERENCES voucher (id),
    CONSTRAINT fk_customer_order_payment FOREIGN KEY (payment_id) REFERENCES payment (id)
);

CREATE TABLE customer_order_item
(
    id           BIGSERIAL PRIMARY KEY NOT NULL,
    order_id     BIGINT                NOT NULL,
    product_id   BIGINT                NOT NULL,

    cage_id      BIGINT,
    bird_id      BIGINT,
    food_id      BIGINT,
    accessory_id BIGINT,

    sub_cage_id  BIGINT,
    sub_bird_id  BIGINT,
    sub_food_id  BIGINT,

    type         TEXT                  NOT NULL,
    quantity     SMALLINT              NOT NULL DEFAULT 1,
    price        NUMERIC               NOT NULL, -- why price is both on product on order_item? because voucher exists

    CONSTRAINT fk_order_item_customer_order FOREIGN KEY (order_id) REFERENCES customer_order (id),
    CONSTRAINT fk_order_item_product FOREIGN KEY (product_id) REFERENCES product (id),

    CONSTRAINT fk_customer_order_item_cage FOREIGN KEY (cage_id) REFERENCES cage,
    CONSTRAINT fk_customer_order_item_bird FOREIGN KEY (bird_id) REFERENCES bird,
    CONSTRAINT fk_customer_order_item_food FOREIGN KEY (food_id) REFERENCES food,
    CONSTRAINT fk_customer_order_item_accessory FOREIGN KEY (accessory_id) REFERENCES accessory,
    CONSTRAINT fk_customer_order_item_sub_cage FOREIGN KEY (sub_cage_id) REFERENCES sub_cage,
    CONSTRAINT fk_customer_order_item_sub_bird FOREIGN KEY (sub_bird_id) REFERENCES sub_bird,
    CONSTRAINT fk_customer_order_item_sub_food FOREIGN KEY (sub_food_id) REFERENCES sub_food
);

CREATE TABLE incurred_cost
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    order_id    BIGINT                NOT NULL,

    name        TEXT                  NOT NULL,
    value       NUMERIC               NOT NULL DEFAULT 0,
    description TEXT,

    CONSTRAINT fk_incurred_cost_order FOREIGN KEY (order_id) REFERENCES customer_order (id),
    CONSTRAINT chk_incurred_cost_value CHECK ( value >= 0 )
);