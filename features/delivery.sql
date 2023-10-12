CREATE TABLE delivery
(
    id              BIGSERIAL PRIMARY KEY                 NOT NULL,
    deliverer_id    BIGINT                                NOT NULL,
    order_id        BIGINT                                NOT NULL,

    type            TEXT                                  NOT NULL,
    status          TEXT        DEFAULT 'DELIVERING'      NOT NULL,

    address_from_id BIGINT                                NOT NULL,
    address_to_id   BIGINT                                NOT NULL,

    started_at      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    completed_at    TIMESTAMPTZ,

    CONSTRAINT fk_delivery_account FOREIGN KEY (deliverer_id) REFERENCES account (id),
    CONSTRAINT fk_delivery_order FOREIGN KEY (order_id) REFERENCES customer_order (id),
    CONSTRAINT fk_delivery_address_from FOREIGN KEY (address_from_id) REFERENCES address (id),
    CONSTRAINT fk_delivery_address_to FOREIGN KEY (address_from_id) REFERENCES address (id)

);

CREATE TABLE package_delivery_distinct_tariff
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    type        TEXT                  NOT NULL,
    from_weight SMALLINT              NOT NULL,
    to_weight   SMALLINT              NOT NULL,
    value       NUMERIC               NOT NULL,
    is_distinct BOOLEAN DEFAULT TRUE,

    CONSTRAINT chk_package_delivery_tariff_weight_range
        CHECK ( from_weight > 0
            AND from_weight < 1000000
            AND to_weight > 0
            AND to_weight < 1000000),
    CONSTRAINT chk_package_delivery_tariff_value CHECK ( value >= 0 ),
    CONSTRAINT chk_package_delivery_tariff_type CHECK ( type IN ('STD', 'ECO', 'FAST'))
);

CREATE TABLE package_delivery_metadata
(
    type                     TEXT NOT NULL
        CONSTRAINT uq_package_delivery_max_measure_type UNIQUE,

    saturated_weight_step    INT  NOT NULL DEFAULT 0,
    saturated_weight_point   INT  NOT NULL,
    max_weight               INT  NOT NULL,

    max_width                INT  NOT NULL,
    max_length               INT  NOT NULL,
    max_height               INT  NOT NULL,

    standard_cubic_cm_per_kg INT  NOT NULL
);

CREATE TABLE distance_delivery_tariff
(
    id BIGSERIAL PRIMARY KEY NOT NULL,
    distance FLOAT
);