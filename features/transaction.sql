CREATE TABLE payment
(
    id            BIGSERIAL PRIMARY KEY                 NOT NULL,
    to_account_id BIGINT,                                         -- case refund
    by_account_id BIGINT                                NOT NULL, --<if platform, must be by an admin>
    on_order      BIGINT,                                         -- case normal order

    description   TEXT,
    total         NUMERIC                               NOT NULL,
    status        TEXT        DEFAULT 'PENDING'         NOT NULL,
    type          TEXT                                  NOT NULL,

    created_at    TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    completed_at  TIMESTAMPTZ,
    failed_at     TIMESTAMPTZ,

    CONSTRAINT fk_payment_to_account FOREIGN KEY (to_account_id) REFERENCES account,
    CONSTRAINT fk_payment_by_account FOREIGN KEY (by_account_id) REFERENCES account,
    CONSTRAINT fk_payment_on_order FOREIGN KEY (on_order) REFERENCES customer_order
);