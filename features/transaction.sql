CREATE TABLE payment
(
    id          BIGSERIAL PRIMARY KEY                 NOT NULL,
    account_id  BIGINT                                NOT NULL,

    description TEXT,
    total       NUMERIC                               NOT NULL,

    created_at  TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,

    CONSTRAINT fk_payment_account FOREIGN KEY (account_id) REFERENCES account (id)
);

CREATE TABLE order_refund -- can only be created when order.status = 'refunding'
(
    id           BIGSERIAL PRIMARY KEY NOT NULL,
    order_id     BIGINT                NOT NULL,

    description  TEXT                  NOT NULL,
    total_refund NUMERIC               NOT NULL DEFAULT 0,

    created_at   TIMESTAMPTZ           NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_customer_order_refund_customer_order FOREIGN KEY (order_id) REFERENCES customer_order (id)
);