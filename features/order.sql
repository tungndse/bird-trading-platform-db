CREATE TABLE customer_order -- created
(
    id                         BIGSERIAL PRIMARY KEY NOT NULL,
    customer_id                BIGINT                NOT NULL,
    shop_id                    BIGINT                NOT NULL,

    description                TEXT,
    total_price                NUMERIC               NOT NULL DEFAULT 0,
    final_price                NUMERIC               NOT NULL DEFAULT 0,

    status                     TEXT                           DEFAULT 'PENDING',
    is_prepaid_payment         BOOLEAN, --if order is prepaid payment type, payment (is_paid) must be made until the status can go to AWAITING
    is_paid                    BOOLEAN,

    cancelled_at               TIMESTAMPTZ,
    confirmed_at               TIMESTAMPTZ,

    started_delivery_at        TIMESTAMPTZ,
    finished_delivery_at       TIMESTAMPTZ,
    customer_reported_at       TIMESTAMPTZ,
    customer_report_decided_at TIMESTAMPTZ,

    started_delivery_back_at   TIMESTAMPTZ,
    finished_delivery_back_at  TIMESTAMPTZ,
    shop_reported_at           TIMESTAMPTZ,
    shop_report_decided_at     TIMESTAMPTZ,

    customer_refunded_at       TIMESTAMPTZ,
    shop_refunded_at           TIMESTAMPTZ,

    completed_at               TIMESTAMPTZ,

    address_from_id            BIGINT                NOT NULL,
    address_to_id              BIGINT                NOT NULL,

    CONSTRAINT fk_customer_order_customer FOREIGN KEY (customer_id) REFERENCES account,
    CONSTRAINT fk_customer_order_shop FOREIGN KEY (shop_id) REFERENCES account,
    CONSTRAINT fk_customer_order_address_from FOREIGN KEY (address_from_id) REFERENCES address,
    CONSTRAINT fk_customer_order_address_to FOREIGN KEY (address_to_id) REFERENCES address

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

CREATE TABLE customer_order_item
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    order_id    BIGINT                NOT NULL,
    product_id  BIGINT                NOT NULL,

    sub_cage_id BIGINT,
    sub_food_id BIGINT,

    quantity    SMALLINT              NOT NULL DEFAULT 1,

    CONSTRAINT fk_order_item_customer_order FOREIGN KEY (order_id) REFERENCES customer_order (id),
    CONSTRAINT fk_order_item_product FOREIGN KEY (product_id) REFERENCES product (id),

    CONSTRAINT fk_customer_order_item_sub_cage FOREIGN KEY (sub_cage_id) REFERENCES sub_cage,
    CONSTRAINT fk_customer_order_item_sub_food FOREIGN KEY (sub_food_id) REFERENCES sub_food
);



CREATE TABLE customer_cart_item
(
    id          BIGSERIAL PRIMARY KEY,
    customer_id BIGINT,
    product_id  BIGINT,

    sub_cage_id BIGINT,
    sub_food_id BIGINT,
    sub_bird_id BIGINT,

    quantity    SMALLINT,
    created_at  TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMPTZ,

    CONSTRAINT fk_customer_cart_item_account FOREIGN KEY (customer_id) REFERENCES account,
    CONSTRAINT fk_customer_cart_item_product FOREIGN KEY (product_id) REFERENCES product,
    CONSTRAINT fk_customer_cart_item_sub_cage FOREIGN KEY (sub_cage_id) REFERENCES sub_cage,
    CONSTRAINT fk_customer_cart_item_sub_food FOREIGN KEY (sub_food_id) REFERENCES sub_food,
    CONSTRAINT fk_customer_cart_item_sub_bird FOREIGN KEY (sub_bird_id) REFERENCES sub_bird
);


