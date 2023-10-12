CREATE TABLE notification
(
    id         BIGSERIAL PRIMARY KEY                 NOT NULL,
    account_id BIGINT                                NOT NULL,

    content    TEXT                                  NOT NULL,
    is_read    BOOLEAN,

    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    read_at    TIMESTAMPTZ,

    CONSTRAINT fk_notification_account FOREIGN KEY (account_id) REFERENCES account (id)
);

CREATE TABLE message
(
    id          BIGSERIAL PRIMARY KEY                 NOT NULL,
    sender_id   BIGINT                                NOT NULL,
    receiver_id BIGINT                                NOT NULL,

    content     TEXT                                  NOT NULL,
    --type        TEXT        DEFAULT 'CHAT'            NOT NULL,
    is_read     BOOLEAN,

    created_at  TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    read_at     TIMESTAMPTZ,

    CONSTRAINT fk_message_account_sender_id FOREIGN KEY (sender_id) REFERENCES account (id),
    CONSTRAINT fk_message_account_receiver_id FOREIGN KEY (receiver_id) REFERENCES account (id)

);

CREATE TABLE feedback
(
    id                 BIGSERIAL PRIMARY KEY NOT NULL,
    customer_id        BIGINT                NOT NULL,
    product_id         BIGINT                NOT NULL,

    content            TEXT                  NOT NULL,
    shop_reply_content TEXT,

    rating             SMALLINT              NOT NULL,

    created_at         TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_feedback_account FOREIGN KEY (customer_id) REFERENCES account (id),
    CONSTRAINT fk_feedback_product FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE TABLE report
(
    id                           BIGSERIAL PRIMARY KEY NOT NULL,
    order_id                     BIGINT                NOT NULL,

    name                         TEXT                  NOT NULL,
    description                  TEXT                  NOT NULL,
    judge_statement              TEXT,
    is_valid                     BOOLEAN,     --valid mean customer is right, invalid means shop is right

    created_at                   TIMESTAMPTZ           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_replied_by_accuser_at   TIMESTAMPTZ, -- for limited timing
    last_replied_by_defendant_at TIMESTAMPTZ, -- for limited timing
    decided_at                   TIMESTAMPTZ           NOT NULL,

    CONSTRAINT fk_order_report_customer_order FOREIGN KEY (order_id) REFERENCES customer_order (id)
);

CREATE TABLE report_reply
(
    id         BIGSERIAL PRIMARY KEY NOT NULL,
    report_id  BIGINT                NOT NULL,
    account_id BIGINT                NOT NULL,

    content    TEXT                  NOT NULL,

    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_report_reply_order_report FOREIGN KEY (report_id) REFERENCES report,
    CONSTRAINT fk_report_reply_account FOREIGN KEY (account_id) REFERENCES account
);