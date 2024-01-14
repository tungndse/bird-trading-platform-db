CREATE SEQUENCE bird_species_id_seq;

ALTER SEQUENCE bird_species_id_seq OWNER TO btp;

CREATE SEQUENCE package_delivery_tariff_id_seq1;

ALTER SEQUENCE package_delivery_tariff_id_seq1 OWNER TO btp;

CREATE SEQUENCE bird_size_delivery_tariff_id_seq;

ALTER SEQUENCE bird_size_delivery_tariff_id_seq OWNER TO btp;

CREATE SEQUENCE delivery_package_id_seq;

ALTER SEQUENCE delivery_package_id_seq OWNER TO btp;

CREATE SEQUENCE birdsize_batch_delivery_rate_id_seq;

ALTER SEQUENCE birdsize_batch_delivery_rate_id_seq OWNER TO btp;

CREATE SEQUENCE favorite_product_id_seq;

ALTER SEQUENCE favorite_product_id_seq OWNER TO btp;

CREATE TABLE account
(
    id               BIGSERIAL
        PRIMARY KEY,
    username         TEXT                                            NOT NULL
        CONSTRAINT uq_account_username
            UNIQUE,
    first_name       TEXT                                            NOT NULL,
    last_name        TEXT                                            NOT NULL,
    role             TEXT                                            NOT NULL
        CONSTRAINT chk_account_role
            CHECK (role = ANY (ARRAY ['ADMIN'::TEXT, 'CUSTOMER'::TEXT, 'SHOP'::TEXT, 'DELIVERER'::TEXT])),
    phone            TEXT                                            NOT NULL,
    email            TEXT                                            NOT NULL,
    description      TEXT,
    status           TEXT                     DEFAULT 'ACTIVE'::TEXT NOT NULL,
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at       TIMESTAMP WITH TIME ZONE,
    updated_at       TIMESTAMP WITH TIME ZONE,
    created_by       BIGINT
        CONSTRAINT fk_account_created_by
            REFERENCES account,
    deleted_by       BIGINT
        CONSTRAINT fk_account_deleted_by
            REFERENCES account,
    updated_by       BIGINT
        CONSTRAINT fk_account_updated_by
            REFERENCES account,
    password         TEXT                                            NOT NULL,
    banned_at        TIMESTAMP WITH TIME ZONE,
    banned_by        BIGINT
        CONSTRAINT fk_account_banned_by
            REFERENCES account,
    birthday         DATE,
    shop_name        TEXT,
    shop_description TEXT,
    media            JSONB,
    avatar           JSONB,
    feedback_count   BIGINT,
    approved_by      BIGINT
        CONSTRAINT fk_account_approved_by
            REFERENCES account,
    approved_at      TIMESTAMP WITH TIME ZONE
);

COMMENT ON COLUMN account.status IS 'ACTIVE, DELETED, BANNED';

ALTER TABLE account
    OWNER TO btp;

CREATE TABLE bird_type
(
    id          BIGINT DEFAULT NEXTVAL('bird_species_id_seq'::REGCLASS) NOT NULL
        CONSTRAINT bird_species_pkey
            PRIMARY KEY,
    name        TEXT                                                    NOT NULL
        CONSTRAINT uq_bird_species_name
            UNIQUE,
    description TEXT,
    name_en     TEXT,
    size_group  TEXT
);

ALTER TABLE bird_type
    OWNER TO btp;

ALTER SEQUENCE bird_species_id_seq OWNED BY bird_type.id;

CREATE TABLE address
(
    id                    BIGSERIAL
        PRIMARY KEY,
    description           TEXT,
    account_id            BIGINT                NOT NULL
        CONSTRAINT fk_address_account
            REFERENCES account,
    is_default            BOOLEAN DEFAULT FALSE NOT NULL,
    longitude             NUMERIC,
    latitude              NUMERIC,
    formatted_description TEXT,
    phone                 TEXT,
    receiver_name         TEXT,
    status                TEXT
);

ALTER TABLE address
    OWNER TO btp;

CREATE TABLE cage
(
    id             BIGSERIAL
        PRIMARY KEY,
    bird_type_id   BIGINT                                          NOT NULL
        CONSTRAINT fk_cage_bird_type
            REFERENCES bird_type,
    name           TEXT                                            NOT NULL,
    description    TEXT                                            NOT NULL,
    status         TEXT                     DEFAULT 'HIDDEN'::TEXT NOT NULL,
    created_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP WITH TIME ZONE,
    deleted_at     TIMESTAMP WITH TIME ZONE,
    shop_id        BIGINT                                          NOT NULL
        CONSTRAINT fk_cage_account
            REFERENCES account,
    package_height NUMERIC                                         NOT NULL,
    package_width  NUMERIC                                         NOT NULL,
    package_length NUMERIC                                         NOT NULL,
    banned_by      BIGINT
        CONSTRAINT fk_cage_banned_by_account
            REFERENCES account,
    banned_at      TIMESTAMP WITH TIME ZONE,
    created_by     BIGINT
        CONSTRAINT fk_cage_shop_created_by
            REFERENCES account,
    updated_by     BIGINT
        CONSTRAINT fk_cage_shop_updated_by
            REFERENCES account,
    deleted_by     BIGINT
        CONSTRAINT fk_cage_shop_deleted_by
            REFERENCES account,
    media          JSONB,
    avg_rating     DOUBLE PRECISION
);

ALTER TABLE cage
    OWNER TO btp;

CREATE TABLE bird_origin
(
    id          BIGSERIAL
        PRIMARY KEY,
    name        TEXT NOT NULL
        CONSTRAINT uq_bird_origin_name
            UNIQUE,
    description TEXT
);

ALTER TABLE bird_origin
    OWNER TO btp;

CREATE TABLE bird
(
    id           BIGSERIAL
        PRIMARY KEY,
    bird_type_id BIGINT                                          NOT NULL
        CONSTRAINT fk_bird_type
            REFERENCES bird_type,
    origin_id    BIGINT
        CONSTRAINT fk_bird_origin
            REFERENCES bird_origin,
    has_serial   BOOLEAN                                         NOT NULL,
    agegroup     TEXT                                            NOT NULL,
    bundle_type  TEXT                                            NOT NULL,
    description  TEXT                                            NOT NULL,
    name         TEXT                                            NOT NULL,
    status       TEXT                     DEFAULT 'HIDDEN'::TEXT NOT NULL,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP WITH TIME ZONE,
    deleted_at   TIMESTAMP WITH TIME ZONE,
    shop_id      BIGINT                                          NOT NULL
        CONSTRAINT fk_bird_account
            REFERENCES account,
    banned_by    BIGINT
        CONSTRAINT fk_bird_banned_by_account
            REFERENCES account,
    banned_at    TIMESTAMP WITH TIME ZONE,
    created_by   BIGINT
        CONSTRAINT fk_bird_shop_created_by
            REFERENCES account,
    deleted_by   BIGINT
        CONSTRAINT fk_bird_shop_deleted_by
            REFERENCES account,
    updated_by   BIGINT
        CONSTRAINT fk_bird_shop_updated_by
            REFERENCES account,
    media        JSONB,
    origin       TEXT,
    avg_rating   DOUBLE PRECISION
);

ALTER TABLE bird
    OWNER TO btp;

CREATE TABLE sub_bird
(
    id              BIGSERIAL
        PRIMARY KEY,
    bird_id         BIGINT            NOT NULL
        CONSTRAINT fk_sub_bird_bird
            REFERENCES bird,
    age             SMALLINT          NOT NULL
        CONSTRAINT chk_sub_bird_age
            CHECK (age > 0),
    description     TEXT,
    mutation        TEXT,
    color           TEXT,
    quantity        INTEGER DEFAULT 1 NOT NULL
        CONSTRAINT chk_sub_bird_quantity
            CHECK (quantity > '-1'::INTEGER),
    price           NUMERIC DEFAULT 0 NOT NULL
        CONSTRAINT chk_sub_bird_price
            CHECK (price > ('-1'::INTEGER)::NUMERIC),
    is_domesticated BOOLEAN,
    is_male         BOOLEAN,
    sold_quantity   INTEGER DEFAULT 0 NOT NULL,
    brief           TEXT,
    name            TEXT,
    media           JSONB,
    status          TEXT,
    nest_quantity   INTEGER
);

ALTER TABLE sub_bird
    OWNER TO btp;

CREATE TABLE accessory
(
    id             BIGSERIAL
        PRIMARY KEY,
    name           TEXT                                            NOT NULL,
    quantity       BIGINT                   DEFAULT 1              NOT NULL,
    price          NUMERIC                  DEFAULT 0              NOT NULL,
    description    TEXT,
    status         TEXT                     DEFAULT 'HIDDEN'::TEXT NOT NULL,
    created_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP WITH TIME ZONE,
    deleted_at     TIMESTAMP WITH TIME ZONE,
    shop_id        BIGINT                                          NOT NULL
        CONSTRAINT fk_accessory_account
            REFERENCES account,
    package_height NUMERIC                                         NOT NULL,
    package_width  NUMERIC                                         NOT NULL,
    package_length NUMERIC                                         NOT NULL,
    banned_by      BIGINT
        CONSTRAINT fk_accessory_banned_by_account
            REFERENCES account,
    banned_at      TIMESTAMP WITH TIME ZONE,
    sold_quantity  BIGINT                   DEFAULT 0,
    weight         NUMERIC                                         NOT NULL,
    deleted_by     BIGINT
        CONSTRAINT fk_accessory_shop_deleted_by
            REFERENCES account,
    created_by     BIGINT
        CONSTRAINT fk_accessory_shop_created_by
            REFERENCES account,
    updated_by     BIGINT
        CONSTRAINT fk_accessory_shop_updated_by
            REFERENCES account,
    media          JSONB,
    avg_rating     DOUBLE PRECISION
);

ALTER TABLE accessory
    OWNER TO btp;

CREATE TABLE food_specialty
(
    id          BIGSERIAL
        PRIMARY KEY,
    name        TEXT NOT NULL
        CONSTRAINT uq_food_specialty_name
            UNIQUE,
    description TEXT
);

ALTER TABLE food_specialty
    OWNER TO btp;

CREATE TABLE food
(
    id             BIGSERIAL
        PRIMARY KEY,
    bird_type_id   BIGINT
        CONSTRAINT fk_food_bird_type
            REFERENCES bird_type,
    type           TEXT                                            NOT NULL
        CONSTRAINT chk_food_type
            CHECK (type = ANY
                   (ARRAY ['NUTS'::TEXT, 'FRUIT'::TEXT, 'VEGETABLE'::TEXT, 'NATURAL'::TEXT, 'ARTIFICIAL'::TEXT, 'VITAMIN'::TEXT, 'MEDICINE'::TEXT])),
    description    TEXT                                            NOT NULL,
    name           TEXT                                            NOT NULL,
    status         TEXT                     DEFAULT 'HIDDEN'::TEXT NOT NULL,
    created_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP WITH TIME ZONE,
    deleted_at     TIMESTAMP WITH TIME ZONE,
    shop_id        BIGINT                                          NOT NULL
        CONSTRAINT fk_food_account
            REFERENCES account,
    package_height NUMERIC                                         NOT NULL,
    package_width  NUMERIC                                         NOT NULL,
    package_length NUMERIC                                         NOT NULL,
    banned_by      BIGINT
        CONSTRAINT fk_food_banned_by_account
            REFERENCES account,
    banned_at      TIMESTAMP WITH TIME ZONE,
    updated_by     BIGINT
        CONSTRAINT fk_cage_food_updated_by
            REFERENCES food
        CONSTRAINT fk_food_shop_updated_by
            REFERENCES account,
    deleted_by     BIGINT
        CONSTRAINT fk_food_shop_deleted_by
            REFERENCES account,
    created_by     BIGINT
        CONSTRAINT fk_food_shop_created_by
            REFERENCES account,
    origin_id      BIGINT
        CONSTRAINT food_origin_fk
            REFERENCES bird_origin,
    media          JSONB,
    origin         TEXT,
    avg_rating     DOUBLE PRECISION
);

ALTER TABLE food
    OWNER TO btp;

CREATE TABLE sub_food
(
    id            BIGSERIAL
        PRIMARY KEY,
    food_id       BIGINT            NOT NULL
        CONSTRAINT fk_sub_food_food
            REFERENCES food,
    quantity      BIGINT  DEFAULT 1 NOT NULL
        CONSTRAINT chk_sub_bird_quantity
            CHECK (quantity > '-1'::INTEGER),
    price         NUMERIC DEFAULT 0 NOT NULL
        CONSTRAINT chk_sub_bird_price
            CHECK (price > ('-1'::INTEGER)::NUMERIC),
    agegroup      TEXT,
    sold_quantity BIGINT  DEFAULT 0 NOT NULL,
    weight        NUMERIC           NOT NULL,
    description   TEXT,
    name          TEXT              NOT NULL,
    brief         TEXT,
    media         JSONB,
    status        TEXT
);

ALTER TABLE sub_food
    OWNER TO btp;

CREATE TABLE sub_food_has_specialty
(
    sub_food_id       BIGINT NOT NULL
        CONSTRAINT fk_sub_food_has_specialty_sub_food
            REFERENCES sub_food,
    food_specialty_id BIGINT NOT NULL
        CONSTRAINT fk_sub_food_has_specialty_food_specialty
            REFERENCES food_specialty,
    id                BIGSERIAL
        CONSTRAINT sub_food_has_specialty_pk
            PRIMARY KEY
);

ALTER TABLE sub_food_has_specialty
    OWNER TO btp;

CREATE TABLE notification
(
    id         BIGSERIAL
        PRIMARY KEY,
    account_id BIGINT                                             NOT NULL
        CONSTRAINT fk_notification_account
            REFERENCES account,
    content    TEXT                                               NOT NULL,
    is_read    BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    read_at    TIMESTAMP WITH TIME ZONE
);

ALTER TABLE notification
    OWNER TO btp;

CREATE TABLE payment
(
    id           BIGSERIAL
        PRIMARY KEY,
    payer_id     BIGINT                                             NOT NULL
        CONSTRAINT fk_payment_by_account
            REFERENCES account,
    description  TEXT,
    total        NUMERIC                                            NOT NULL,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type         TEXT                                               NOT NULL,
    payment_url  TEXT,
    payment_code TEXT
);

ALTER TABLE payment
    OWNER TO btp;

CREATE TABLE voucher
(
    id                   BIGSERIAL
        PRIMARY KEY,
    created_by           BIGINT
        CONSTRAINT fk_voucher_created_by
            REFERENCES account,
    code                 TEXT                                               NOT NULL,
    is_delivery_voucher  BOOLEAN,
    is_percent           BOOLEAN                                            NOT NULL,
    valid_from           TIMESTAMP WITH TIME ZONE                           NOT NULL,
    valid_until          TIMESTAMP WITH TIME ZONE                           NOT NULL,
    min_order_value      NUMERIC                  DEFAULT 0                 NOT NULL
        CONSTRAINT chk_voucher_min_order_value
            CHECK (min_order_value >= (0)::NUMERIC),
    percent_discount     DOUBLE PRECISION         DEFAULT 0
        CONSTRAINT chk_voucher_percent_discount
            CHECK ((percent_discount >= (0)::DOUBLE PRECISION) AND (percent_discount < (1)::DOUBLE PRECISION)),
    max_discounted_value NUMERIC
        CONSTRAINT chk_voucher_max_discounted_value
            CHECK (max_discounted_value >= (0)::NUMERIC),
    value_discount       NUMERIC                  DEFAULT 0
        CONSTRAINT chk_voucher_value_discount
            CHECK (value_discount >= (0)::NUMERIC),
    quantity             SMALLINT                                           NOT NULL
        CONSTRAINT chk_voucher_available_item_count
            CHECK (quantity > 0),
    is_deleted           BOOLEAN                                            NOT NULL,
    created_at           TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at           TIMESTAMP WITH TIME ZONE,
    name                 TEXT,
    description          TEXT
);

ALTER TABLE voucher
    OWNER TO btp;

CREATE TABLE bird_document
(
    id          BIGSERIAL
        PRIMARY KEY,
    name        TEXT NOT NULL,
    sub_bird_id BIGINT
        CONSTRAINT fk_bird_document_sub_bird
            REFERENCES sub_bird,
    media       JSONB,
    description TEXT
);

ALTER TABLE bird_document
    OWNER TO btp;

CREATE TABLE distance_type
(
    id            BIGSERIAL
        PRIMARY KEY,
    code_name     TEXT NOT NULL
        CONSTRAINT uq_distance_type_name
            UNIQUE,
    distance_from NUMERIC,
    distance_to   NUMERIC,
    description   TEXT
);

ALTER TABLE distance_type
    OWNER TO btp;

CREATE TABLE cage_shape
(
    id          BIGSERIAL
        PRIMARY KEY,
    name        TEXT NOT NULL,
    description TEXT,
    status      TEXT
);

ALTER TABLE cage_shape
    OWNER TO btp;

CREATE TABLE cage_vignette
(
    id          BIGSERIAL
        PRIMARY KEY,
    name        TEXT NOT NULL,
    description TEXT,
    status      TEXT
);

ALTER TABLE cage_vignette
    OWNER TO btp;

CREATE TABLE cage_material
(
    id          BIGSERIAL
        PRIMARY KEY,
    name        TEXT NOT NULL,
    description TEXT,
    status      TEXT
);

ALTER TABLE cage_material
    OWNER TO btp;

CREATE TABLE sub_cage
(
    id            BIGSERIAL
        PRIMARY KEY,
    cage_id       BIGINT             NOT NULL
        CONSTRAINT fk_sub_cage_cage
            REFERENCES cage,
    material_id   BIGINT             NOT NULL
        CONSTRAINT fk_sub_cage_material
            REFERENCES cage_material,
    vignette_id   BIGINT             NOT NULL
        CONSTRAINT fk_sub_cage_vignette
            REFERENCES cage_vignette,
    shape_id      BIGINT             NOT NULL
        CONSTRAINT fk_sub_cage_shape
            REFERENCES cage_shape,
    description   TEXT               NOT NULL,
    quantity      BIGINT   DEFAULT 1 NOT NULL
        CONSTRAINT chk_sub_cage_quantity
            CHECK (quantity > '-1'::INTEGER),
    price         NUMERIC  DEFAULT 0 NOT NULL
        CONSTRAINT chk_sub_cage_price
            CHECK (price >= (0)::NUMERIC),
    sold_quantity BIGINT   DEFAULT 0 NOT NULL,
    weight        NUMERIC            NOT NULL,
    picket_num    SMALLINT DEFAULT 0,
    name          TEXT,
    brief         TEXT,
    media         JSONB,
    status        TEXT
);

ALTER TABLE sub_cage
    OWNER TO btp;

CREATE TABLE customer_cart_item
(
    id           BIGSERIAL
        PRIMARY KEY,
    customer_id  BIGINT                             NOT NULL
        CONSTRAINT fk_customer_cart_item_account
            REFERENCES account,
    sub_cage_id  BIGINT
        CONSTRAINT fk_customer_cart_item_sub_cage
            REFERENCES sub_cage,
    sub_food_id  BIGINT
        CONSTRAINT fk_customer_cart_item_sub_food
            REFERENCES sub_food,
    sub_bird_id  BIGINT
        CONSTRAINT fk_customer_cart_item_sub_bird
            REFERENCES sub_bird,
    accessory_id BIGINT
        CONSTRAINT fk_customer_cart_item_accessory
            REFERENCES accessory,
    quantity     BIGINT                   DEFAULT 1 NOT NULL,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP WITH TIME ZONE,
    type         TEXT                               NOT NULL,
    is_deleted   BOOLEAN                            NOT NULL,
    removed_at   TIMESTAMP WITH TIME ZONE,
    is_selected  BOOLEAN
);

ALTER TABLE customer_cart_item
    OWNER TO btp;

CREATE TABLE delivery_type
(
    id                  BIGINT DEFAULT NEXTVAL('delivery_package_id_seq'::REGCLASS) NOT NULL
        CONSTRAINT delivery_package_pkey
            PRIMARY KEY,
    code_name           TEXT                                                        NOT NULL,
    name                TEXT                                                        NOT NULL,
    description         TEXT,
    preparation_hours   NUMERIC,
    hours_per_kilometer NUMERIC
);

ALTER TABLE delivery_type
    OWNER TO btp;

ALTER SEQUENCE delivery_package_id_seq OWNED BY delivery_type.id;

CREATE TABLE customer_order
(
    id                         BIGSERIAL
        PRIMARY KEY,
    customer_id                BIGINT            NOT NULL
        CONSTRAINT fk_customer_order_customer
            REFERENCES account,
    shop_id                    BIGINT            NOT NULL
        CONSTRAINT fk_customer_order_shop
            REFERENCES account,
    description                TEXT,
    gross_price                NUMERIC DEFAULT 0 NOT NULL,
    net_price                  NUMERIC DEFAULT 0 NOT NULL,
    status                     TEXT    DEFAULT 'PENDING'::TEXT,
    is_paid                    BOOLEAN,
    cancelled_at               TIMESTAMP WITH TIME ZONE,
    confirmed_at               TIMESTAMP WITH TIME ZONE,
    started_delivery_at        TIMESTAMP WITH TIME ZONE,
    finished_delivery_at       TIMESTAMP,
    last_reported_at           TIMESTAMP WITH TIME ZONE,
    last_report_decided_at     TIMESTAMP WITH TIME ZONE,
    started_returning_at       TIMESTAMP WITH TIME ZONE,
    finished_returning_at      TIMESTAMP WITH TIME ZONE,
    payment_resolved_at        TIMESTAMP WITH TIME ZONE,
    created_at                 TIMESTAMP WITH TIME ZONE,
    declined_at                TIMESTAMP WITH TIME ZONE,
    completed_at               TIMESTAMP WITH TIME ZONE,
    delivery_price             NUMERIC,
    address_from_id            BIGINT            NOT NULL
        CONSTRAINT fk_customer_order_address_from
            REFERENCES address,
    address_to_id              BIGINT            NOT NULL
        CONSTRAINT fk_customer_order_address_to
            REFERENCES address,
    delivery_type_id           BIGINT
        CONSTRAINT fk_customer_order_delivery_type
            REFERENCES delivery_type,
    distance_type_id           BIGINT
        CONSTRAINT customer_order_distance_type_id_fk
            REFERENCES distance_type,
    voucher_total_discount     NUMERIC DEFAULT 0,
    delivery_distance          NUMERIC,
    delivery_duration          NUMERIC,
    delivery_distance_readable TEXT,
    delivery_duration_readable TEXT,
    updated_at                 TIMESTAMP WITH TIME ZONE,
    order_code                 TEXT,
    payment_id                 BIGINT
        CONSTRAINT customer_order_fk_payment
            REFERENCES payment,
    canceled_by                BIGINT
        CONSTRAINT fk_customer_order_canceled_by
            REFERENCES account,
    from_address_static        JSONB,
    to_address_static          JSONB,
    delivery_fail_by           TEXT
);

ALTER TABLE customer_order
    OWNER TO btp;

CREATE TABLE report
(
    id                           BIGSERIAL
        PRIMARY KEY,
    order_id                     BIGINT
        CONSTRAINT fk_order_report_customer_order
            REFERENCES customer_order,
    name                         TEXT                                               NOT NULL,
    description                  TEXT                                               NOT NULL,
    judgement                    TEXT,
    is_valid                     BOOLEAN,
    created_at                   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_replied_by_accuser_at   TIMESTAMP WITH TIME ZONE,
    last_replied_by_defendant_at TIMESTAMP WITH TIME ZONE,
    decided_at                   TIMESTAMP WITH TIME ZONE,
    judged_by                    BIGINT
        CONSTRAINT fk_report_judged_by
            REFERENCES account,
    role                         TEXT                                               NOT NULL,
    created_by                   BIGINT                                             NOT NULL
        CONSTRAINT fk_report_created_by_account
            REFERENCES account,
    status                       TEXT,
    received_at                  TIMESTAMP WITH TIME ZONE,
    requested_refund_value       NUMERIC                  DEFAULT 0                 NOT NULL,
    decided_refund_value         NUMERIC                  DEFAULT 0                 NOT NULL,
    media                        JSONB,
    bank_account_number          TEXT,
    account_bank_codename        TEXT,
    report_type                  TEXT,
    reported_account_id          BIGINT
        CONSTRAINT fk_reported_account
            REFERENCES account,
    bank_name                    TEXT,
    beneficiary_name             TEXT,
    canceled_at                  TIMESTAMP WITH TIME ZONE
);

ALTER TABLE report
    OWNER TO btp;

CREATE TABLE report_reply
(
    id         BIGSERIAL
        PRIMARY KEY,
    report_id  BIGINT NOT NULL
        CONSTRAINT fk_report_reply_order_report
            REFERENCES report,
    role       TEXT   NOT NULL,
    content    TEXT   NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT NOT NULL
        CONSTRAINT fk_report_reply_created_by
            REFERENCES account
);

ALTER TABLE report_reply
    OWNER TO btp;

CREATE TABLE voucher_item
(
    id                BIGSERIAL
        PRIMARY KEY,
    voucher_id        BIGINT                       NOT NULL
        CONSTRAINT fk_voucher_item_voucher
            REFERENCES voucher,
    status            TEXT DEFAULT 'PENDING'::TEXT NOT NULL,
    used_at           TIMESTAMP WITH TIME ZONE,
    customer_order_id BIGINT
        CONSTRAINT fk_voucher_item_customer_order
            REFERENCES customer_order,
    value_discounted  NUMERIC
);

ALTER TABLE voucher_item
    OWNER TO btp;

CREATE TABLE package_delivery_tariff
(
    id               BIGINT  DEFAULT NEXTVAL('package_delivery_tariff_id_seq1'::REGCLASS) NOT NULL
        PRIMARY KEY,
    weight_from      NUMERIC DEFAULT 1                                                    NOT NULL,
    weight_to        NUMERIC DEFAULT 1                                                    NOT NULL,
    distance_type_id BIGINT                                                               NOT NULL
        CONSTRAINT fk_package_delivery_tariff_distance_type
            REFERENCES distance_type,
    value            NUMERIC DEFAULT 0                                                    NOT NULL
        CONSTRAINT chk_package_delivery_tariff_value
            CHECK (value >= (0)::NUMERIC),
    delivery_type_id BIGINT                                                               NOT NULL
        CONSTRAINT fk_package_delivery_tariff_delivery_type
            REFERENCES delivery_type,
    CONSTRAINT chk_package_delivery_tariff_weight
        CHECK ((weight_from > ('-1'::INTEGER)::NUMERIC) AND (weight_to > (0)::NUMERIC) AND
               (weight_from < (1000000)::NUMERIC) AND (weight_to < (1000000)::NUMERIC) AND (weight_from < weight_to))
);

ALTER TABLE package_delivery_tariff
    OWNER TO btp;

ALTER SEQUENCE package_delivery_tariff_id_seq1 OWNED BY package_delivery_tariff.id;

CREATE TABLE birdsize_delivery_tariff
(
    id               BIGINT DEFAULT NEXTVAL('bird_size_delivery_tariff_id_seq'::REGCLASS) NOT NULL
        CONSTRAINT bird_size_delivery_tariff_pkey
            PRIMARY KEY,
    bird_size_group  TEXT,
    distance_type_id BIGINT
        CONSTRAINT fk_bird_size_delivery_tariff_distance_type
            REFERENCES distance_type,
    value            NUMERIC,
    delivery_type_id BIGINT                                                               NOT NULL
        CONSTRAINT fk_birdsize_delivery_tariff_delivery_type
            REFERENCES delivery_type
);

ALTER TABLE birdsize_delivery_tariff
    OWNER TO btp;

ALTER SEQUENCE bird_size_delivery_tariff_id_seq OWNED BY birdsize_delivery_tariff.id;

CREATE TABLE customer_order_item
(
    id                      BIGSERIAL
        PRIMARY KEY,
    order_id                BIGINT
        CONSTRAINT fk_order_item_customer_order
            REFERENCES customer_order,
    sub_cage_id             BIGINT
        CONSTRAINT fk_customer_order_item_sub_cage
            REFERENCES sub_cage,
    sub_food_id             BIGINT
        CONSTRAINT fk_customer_order_item_sub_food
            REFERENCES sub_food,
    sub_bird_id             BIGINT
        CONSTRAINT fk_customer_order_item_sub_bird
            REFERENCES sub_bird,
    accessory_id            BIGINT
        CONSTRAINT fk_customer_order_item_accessory
            REFERENCES accessory,
    quantity                BIGINT  DEFAULT 1 NOT NULL,
    type                    TEXT              NOT NULL,
    price                   NUMERIC           NOT NULL,
    delivery_group_codename TEXT,
    delivery_group_draft    SMALLINT,
    delivery_group_price    NUMERIC DEFAULT 0,
    product_static          JSONB
);

ALTER TABLE customer_order_item
    OWNER TO btp;

CREATE TABLE feedback
(
    id                     BIGSERIAL
        PRIMARY KEY,
    customer_order_item_id BIGINT NOT NULL
        CONSTRAINT uq_feedback_customer_order_item_id
            UNIQUE
        CONSTRAINT fk_feedback_customer_order_item
            REFERENCES customer_order_item,
    rating                 DOUBLE PRECISION
        CONSTRAINT chk_feedback_rating
            CHECK ((rating > (0)::DOUBLE PRECISION) AND (rating < (6)::DOUBLE PRECISION)),
    content                TEXT   NOT NULL,
    shop_reply             TEXT,
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    shop_replied_at        TIMESTAMP WITH TIME ZONE,
    media                  JSONB
);

ALTER TABLE feedback
    OWNER TO btp;

CREATE TABLE package_delivery_saturated_step_tariff
(
    id                         BIGSERIAL
        PRIMARY KEY,
    max_value_before_saturated NUMERIC,
    step_value                 NUMERIC,
    distance_type_id           BIGINT NOT NULL
        CONSTRAINT fk_package_delivery_saturated_step_tariff_distance_type
            REFERENCES distance_type,
    delivery_type_id           BIGINT NOT NULL
        CONSTRAINT fk_package_delivery_saturated_step_tariff_delivery_type
            REFERENCES delivery_type
);

ALTER TABLE package_delivery_saturated_step_tariff
    OWNER TO btp;

CREATE TABLE bird_batch_delivery_rate
(
    id               BIGINT DEFAULT NEXTVAL('birdsize_batch_delivery_rate_id_seq'::REGCLASS) NOT NULL
        CONSTRAINT birdsize_batch_delivery_rate_pkey
            PRIMARY KEY,
    delivery_type_id BIGINT                                                                  NOT NULL
        CONSTRAINT fk_birdsize_batch_delivery_rate_delivery_type
            REFERENCES delivery_type,
    quantity_from    SMALLINT,
    quantity_to      SMALLINT,
    rate             DOUBLE PRECISION                                                        NOT NULL
);

ALTER TABLE bird_batch_delivery_rate
    OWNER TO btp;

ALTER SEQUENCE birdsize_batch_delivery_rate_id_seq OWNED BY bird_batch_delivery_rate.id;

CREATE TABLE product_favorite
(
    id           BIGINT DEFAULT NEXTVAL('favorite_product_id_seq'::REGCLASS) NOT NULL
        CONSTRAINT favorite_product_pkey
            PRIMARY KEY,
    account_id   BIGINT                                                      NOT NULL
        CONSTRAINT fk_favorite_product_account
            REFERENCES account,
    accessory_id BIGINT
        CONSTRAINT fk_favorite_product_accessory
            REFERENCES accessory,
    cage_id      BIGINT
        CONSTRAINT fk_favorite_product_cage
            REFERENCES cage,
    food_id      BIGINT
        CONSTRAINT fk_favorite_product_food
            REFERENCES food,
    bird_id      BIGINT
        CONSTRAINT fk_favorite_product_bird
            REFERENCES bird,
    product_type TEXT,
    CONSTRAINT uq_product_favorite_accountid_foodid
        UNIQUE (account_id, food_id),
    CONSTRAINT uq_product_favorite_accountid_cageid
        UNIQUE (account_id, cage_id),
    CONSTRAINT uq_product_favorite_accountid_accessoryid
        UNIQUE (account_id, accessory_id),
    CONSTRAINT uq_product_favorite_accountid_birdid
        UNIQUE (account_id, bird_id)
);

ALTER TABLE product_favorite
    OWNER TO btp;

ALTER SEQUENCE favorite_product_id_seq OWNED BY product_favorite.id;

CREATE TABLE media
(
    id         BIGINT GENERATED BY DEFAULT AS IDENTITY
        CONSTRAINT media_pk
            PRIMARY KEY,
    media_type TEXT,
    key        TEXT
        CONSTRAINT media_pk2
            UNIQUE
);

ALTER TABLE media
    OWNER TO btp;

CREATE TABLE transaction
(
    id                  BIGSERIAL
        CONSTRAINT transaction_pk
            PRIMARY KEY,
    transaction_code    TEXT,
    note                TEXT,
    status              TEXT,
    total_gross_amount  NUMERIC,
    created_at          TIMESTAMP WITH TIME ZONE,
    updated_at          TIMESTAMP WITH TIME ZONE,
    account_id          BIGINT
        CONSTRAINT transaction_account_id_fk
            REFERENCES account,
    total_net_amount    NUMERIC,
    total_platform_fee  NUMERIC,
    transaction_type    TEXT,
    transaction_name    TEXT,
    bank_name           TEXT,
    bank_account_number TEXT,
    beneficiary_name    TEXT,
    bank_code           TEXT
);

ALTER TABLE transaction
    OWNER TO btp;

CREATE TABLE transaction_detail
(
    id             BIGSERIAL
        CONSTRAINT transaction_detail_pk
            PRIMARY KEY,
    transaction_id BIGINT
        CONSTRAINT transaction_detail_transaction_id_fk
            REFERENCES transaction,
    gross_amount   NUMERIC,
    net_amount     NUMERIC,
    platform_fee   NUMERIC,
    note           TEXT,
    status         TEXT,
    order_id       INTEGER
        CONSTRAINT transaction_detail_customer_order_id_fk
            REFERENCES customer_order,
    created_at     TIMESTAMP WITH TIME ZONE,
    updated_at     TIMESTAMP WITH TIME ZONE
);

ALTER TABLE transaction_detail
    OWNER TO btp;

CREATE TABLE bank_account
(
    id                  BIGSERIAL
        CONSTRAINT bank_account_pk
            PRIMARY KEY,
    bank_name           TEXT,
    bank_account_number TEXT,
    beneficiary_name    TEXT,
    account_id          BIGINT
        CONSTRAINT bank_account_account_id_fk
            REFERENCES account,
    created_at          TIMESTAMP WITH TIME ZONE,
    updated_at          TIMESTAMP WITH TIME ZONE,
    bank_code           TEXT
);

ALTER TABLE bank_account
    OWNER TO btp;

CREATE TABLE product_combo
(
    id           BIGSERIAL
        PRIMARY KEY,
    shop_id      BIGINT
        CONSTRAINT fk_product_combo_shop
            REFERENCES account,
    bird_id      BIGINT
        CONSTRAINT fk_product_combo_bird_main
            REFERENCES bird,
    master_key   TEXT,
    name         TEXT,
    description  TEXT,
    is_deleted   BOOLEAN DEFAULT FALSE,
    cage_id      BIGINT
        CONSTRAINT fk_product_combo_cage
            REFERENCES cage,
    food_id      BIGINT
        CONSTRAINT fk_product_combo_food
            REFERENCES food,
    accessory_id BIGINT
        CONSTRAINT fk_product_combo_accessory
            REFERENCES accessory,
    created_at   TIMESTAMP WITH TIME ZONE,
    updated_at   TIMESTAMP WITH TIME ZONE,
    type         TEXT
);

ALTER TABLE product_combo
    OWNER TO btp;

CREATE FUNCTION fn_account_set_event_saver_for_tr_account_status_update() RETURNS trigger
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

CREATE TRIGGER tr_account_status_update
    BEFORE UPDATE
        OF status
    ON account
    FOR EACH ROW
EXECUTE PROCEDURE fn_account_set_event_saver_for_tr_account_status_update();

CREATE FUNCTION fn_account_set_event_saver_for_tr_account_details_update() RETURNS trigger
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

CREATE TRIGGER tr_account_details_update
    BEFORE UPDATE
        OF password, first_name, last_name, role, phone, email, description, birthday
    ON account
    FOR EACH ROW
EXECUTE PROCEDURE fn_account_set_event_saver_for_tr_account_details_update();

CREATE FUNCTION fn_account_set_event_saver_for_tr_account_insert() RETURNS trigger
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

ALTER FUNCTION fn_account_set_event_saver_for_tr_account_insert() OWNER TO btp;

CREATE TRIGGER tr_account_insert
    BEFORE INSERT
    ON account
    FOR EACH ROW
EXECUTE PROCEDURE fn_account_set_event_saver_for_tr_account_insert();

CREATE FUNCTION fn_generate_order_code() RETURNS trigger
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.order_code := concat('BTP-', TO_CHAR(NOW(), 'DDMMYYYY'),'-',REPLACE(FORMAT('%5s', new.id), ' ', '0'));
    RETURN new;
END
$$;

ALTER FUNCTION fn_generate_order_code() OWNER TO btp;

CREATE TRIGGER tr_customer_order_insert_generate_code
    BEFORE INSERT
    ON customer_order
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_order_code();

CREATE FUNCTION fn_generate_updated_at() RETURNS trigger
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.updated_at = CURRENT_TIMESTAMP;
    RETURN new;
END;
$$;

ALTER FUNCTION fn_generate_updated_at() OWNER TO btp;

CREATE TRIGGER tr_customer_order_updated_at_auto_fill
    BEFORE UPDATE
    ON customer_order
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_updated_at();

CREATE TRIGGER tr_cage_updated_at
    AFTER UPDATE
    ON cage
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_updated_at();

CREATE TRIGGER tr_bird_updated_at
    AFTER UPDATE
    ON bird
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_updated_at();

CREATE TRIGGER tr_accessory_updated_at
    AFTER UPDATE
    ON accessory
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_updated_at();

CREATE TRIGGER tr_food_updated_at
    AFTER UPDATE
    ON food
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_updated_at();

CREATE TRIGGER tr_bank_account_updated_at
    AFTER UPDATE
    ON bank_account
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_updated_at();

CREATE FUNCTION fn_generate_payment_code() RETURNS trigger
    LANGUAGE plpgsql
AS
$$
BEGIN
    new.payment_code := concat('BTP-', TO_CHAR(NOW(), 'DDMMYYYY'), '-', REPLACE(FORMAT('%5s', new.id), ' ', '0'));
    RETURN new;
END
$$;

ALTER FUNCTION fn_generate_payment_code() OWNER TO btp;

CREATE TRIGGER tr_customer_order_insert_generate_code
    BEFORE INSERT
    ON payment
    FOR EACH ROW
EXECUTE PROCEDURE fn_generate_payment_code();

CREATE FUNCTION fn_get_product_brief_from_feedback_id(feedback_id_ bigint)
    RETURNS TABLE(product_id bigint, product_type text)
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN QUERY SELECT
                     CASE
                         WHEN (customer_order_item.type = 'ACCESSORY') THEN accessory_id
                         WHEN (customer_order_item.type = 'FOOD') THEN food_id
                         WHEN (customer_order_item.type = 'BIRD') THEN bird_id
                         WHEN (customer_order_item.type = 'CAGE') THEN cage_id
                         ELSE 0 END
                                              AS product_id,
                     customer_order_item.type AS product_type
                 FROM feedback
                          INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
                          INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
                          LEFT JOIN accessory ON accessory_id = accessory.id
                          LEFT JOIN sub_bird ON sub_bird_id = sub_bird.id
                          LEFT JOIN sub_food ON sub_food_id = sub_food.id
                          LEFT JOIN sub_cage ON sub_cage_id = sub_cage.id
                 WHERE feedback.id = feedback_id_;

END;

$$;

ALTER FUNCTION fn_get_product_brief_from_feedback_id(BIGINT) OWNER TO btp;

CREATE FUNCTION fn_avg_product_feedback_rating_by_product_id_and_type(product_id_ bigint, product_type_ text) RETURNS double precision
    LANGUAGE plpgsql
AS
$$
DECLARE
    result_ DOUBLE PRECISION;
BEGIN

    SELECT AVG(feedback.rating)
    INTO result_
    FROM feedback
             INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
             INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
             LEFT JOIN accessory ON accessory_id = accessory.id
             LEFT JOIN sub_bird ON sub_bird_id = sub_bird.id
             LEFT JOIN sub_food ON sub_food_id = sub_food.id
             LEFT JOIN sub_cage ON sub_cage_id = sub_cage.id
    WHERE CASE
              WHEN product_type_ = 'ACCESSORY' THEN accessory_id = product_id_
              WHEN product_type_ = 'BIRD' THEN bird_id = product_id_
              WHEN product_type_ = 'CAGE' THEN cage_id = product_id_
              WHEN product_type_ = 'FOOD' THEN food_id = product_id_
              END;
    RETURN result_;
END;
$$;

ALTER FUNCTION fn_avg_product_feedback_rating_by_product_id_and_type(BIGINT, TEXT) OWNER TO btp;

CREATE FUNCTION fn_auto_calculate_product_avg_rating() RETURNS trigger
    LANGUAGE plpgsql
AS
$$
DECLARE
    avg_result_   DOUBLE PRECISION;
    product_id_   BIGINT;
    product_type_ TEXT;
BEGIN

    SELECT product_id, product_type
    INTO product_id_, product_type_
    FROM fn_get_product_brief_from_feedback_id(new.id);

    SELECT fn_avg_product_feedback_rating_by_product_id_and_type(product_id_, product_type_)
    INTO avg_result_;

    IF product_type_ = 'ACCESSORY' THEN
        UPDATE accessory SET avg_rating = avg_result_ WHERE id = product_id_;
    ELSEIF product_type_ = 'BIRD' THEN
        UPDATE bird SET avg_rating = avg_result_ WHERE id = product_id_;
    ELSEIF product_type_ = 'FOOD' THEN
        UPDATE food SET avg_rating = avg_result_ WHERE id = product_id_;
    ELSEIF product_type_ = 'CAGE' THEN
        UPDATE cage SET avg_rating = avg_result_ WHERE id = product_id_;
    END IF;

    RETURN new;
END;
$$;

ALTER FUNCTION fn_auto_calculate_product_avg_rating() OWNER TO btp;

CREATE TRIGGER tr_feedback_product_rating
    AFTER INSERT
    ON feedback
    FOR EACH ROW
EXECUTE PROCEDURE fn_auto_calculate_product_avg_rating();

CREATE FUNCTION fn_auto_update_feedback_count() RETURNS trigger
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_count_  BIGINT;
    account_id_ BIGINT;
BEGIN

    SELECT COUNT(customer_order.customer_id)
    INTO new_count_
    FROM feedback
             INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
             INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
    WHERE customer_id = 3;

    SELECT customer_id
    INTO account_id_
    FROM feedback
             INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
             INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
    WHERE feedback.id = new.id;

    update account SET feedback_count = new_count_ WHERE account.id = account_id_;

    RETURN new;
END;
$$;

ALTER FUNCTION fn_auto_update_feedback_count() OWNER TO btp;

CREATE TRIGGER tr_feedback_count_for_account
    AFTER INSERT
    ON feedback
    FOR EACH ROW
EXECUTE PROCEDURE fn_auto_update_feedback_count();

CREATE FUNCTION fn_x(weight_to_limit numeric)
    RETURNS TABLE(weight_from numeric, weight_to numeric, distance_type_id bigint, delivery_type_id bigint, value numeric)
    LANGUAGE plpgsql
AS
$$
DECLARE
    weight_from_temp      NUMERIC;
    weight_to_temp        NUMERIC;
    weight_to_saturated   NUMERIC;
    value_temp            NUMERIC;
    delivery_type_id_temp BIGINT;
    distance_type_id_temp BIGINT;

BEGIN
    weight_to_saturated = 2000;
    weight_from_temp := 2000;
    weight_to_temp := 2500;
    delivery_type_id_temp := 1;
    distance_type_id_temp := 1;
    while distance_type_id_temp in (SELECT id from distance_type) loop
            WHILE (delivery_type_id_temp IN (SELECT id FROM delivery_type))
                LOOP
                    WHILE (weight_to_temp <= weight_to_limit)
                        LOOP
                            SELECT (weight_to_temp - weight_to_saturated) / 500 * step_value + max_value_before_saturated
                            INTO value_temp
                            FROM package_delivery_saturated_step_tariff
                            WHERE package_delivery_saturated_step_tariff.delivery_type_id = delivery_type_id_temp
                              AND package_delivery_saturated_step_tariff.distance_type_id = distance_type_id_temp;

                            RETURN QUERY (SELECT weight_from_temp,
                                                 weight_to_temp,
                                                 distance_type_id_temp,
                                                 delivery_type_id_temp,
                                                 value_temp);

                            weight_to_temp := weight_to_temp + 500;
                            weight_from_temp := weight_from_temp + 500;
                        END LOOP;
                    weight_to_temp := 2500;
                    weight_from_temp := 2000;
                    delivery_type_id_temp := delivery_type_id_temp + 1;
                END LOOP;
            delivery_type_id_temp := 1;
            distance_type_id_temp := distance_type_id_temp + 1;
        END LOOP;


END
$$;

ALTER FUNCTION fn_x(NUMERIC) OWNER TO btp;

CREATE FUNCTION fn_get_shop_product_count(_shop_id bigint, _product_type text) RETURNS integer
    LANGUAGE plpgsql
AS
$$
DECLARE
    _count INT;
BEGIN
    IF _shop_id ISNULL THEN
        IF _product_type = 'BIRD'
        THEN
            SELECT COUNT(id) INTO _count FROM bird WHERE status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'CAGE'
        THEN
            SELECT COUNT(id) INTO _count FROM cage WHERE status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'ACCESSORY'
        THEN
            SELECT COUNT(id) INTO _count FROM accessory WHERE status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'FOOD'
        THEN
            SELECT COUNT(id) INTO _count FROM food WHERE status NOT IN ('DELETED', 'BANNED');
        ELSEIF _product_type ISNULL
        THEN
            SELECT fn_get_shop_product_count(NULL, 'BIRD')
                       + fn_get_shop_product_count(NULL, 'ACCESSORY')
                       + fn_get_shop_product_count(NULL, 'CAGE')
                       + fn_get_shop_product_count(NULL, 'FOOD')
            INTO _count;
        ELSE
            SELECT 0 INTO _count;
        END IF;
    ELSE
        IF _product_type = 'BIRD'
        THEN
            SELECT COUNT(id) INTO _count FROM bird WHERE shop_id = _shop_id AND status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'CAGE'
        THEN
            SELECT COUNT(id) INTO _count FROM cage WHERE shop_id = _shop_id AND status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'ACCESSORY'
        THEN
            SELECT COUNT(id)
            INTO _count
            FROM accessory
            WHERE shop_id = _shop_id
              AND status NOT IN ('DELETED', 'BANNED');
        ELSIF _product_type = 'FOOD'
        THEN
            SELECT COUNT(id) INTO _count FROM food WHERE shop_id = _shop_id AND status NOT IN ('DELETED', 'BANNED');
        ELSEIF _product_type ISNULL
        THEN
            SELECT fn_get_shop_product_count(_shop_id, 'BIRD')
                       + fn_get_shop_product_count(_shop_id, 'ACCESSORY')
                       + fn_get_shop_product_count(_shop_id, 'CAGE')
                       + fn_get_shop_product_count(_shop_id, 'FOOD')
            INTO _count;
        ELSE
            SELECT 0 INTO _count;
        END IF;
    END IF;

    RETURN _count;
END ;
$$;

ALTER FUNCTION fn_get_shop_product_count(BIGINT, TEXT) OWNER TO btp;

CREATE FUNCTION fn_get_shop_customer_order_count(_account_id bigint, _order_status text) RETURNS integer
    LANGUAGE plpgsql
AS
$$
DECLARE
    _count INT;
    _role  TEXT;
BEGIN

    IF _account_id ISNULL THEN
        IF _order_status ISNULL THEN
            SELECT COUNT(id) INTO _count FROM customer_order;
        ELSE
            SELECT COUNT(id) INTO _count FROM customer_order WHERE status = _order_status;
        END IF;
    ELSE
        SELECT role INTO _role FROM account WHERE id = _account_id;

        IF _role = 'CUSTOMER' THEN
            IF _order_status IS NULL THEN
                SELECT COUNT(id)
                INTO _count
                FROM customer_order
                WHERE customer_id = _account_id
                  AND status != 'DELETED';
            ELSE
                SELECT COUNT(id)
                INTO _count
                FROM customer_order
                WHERE customer_id = _account_id
                  AND status = _order_status;
            END IF;
        ELSIF _role = 'SHOP' THEN
            IF _order_status IS NULL THEN
                SELECT COUNT(id)
                INTO _count
                FROM customer_order
                WHERE shop_id = _account_id
                  AND status NOT IN ('AWAIT_PAYMENT', 'CANCELLED', 'DELETED');
            ELSE
                SELECT COUNT(id)
                INTO _count
                FROM customer_order
                WHERE shop_id = _account_id
                  AND status = _order_status
                  AND status NOT IN ('AWAIT_PAYMENT', 'CANCELLED', 'DELETED');
            END IF;
        ELSE
            SELECT 0 INTO _count;
        END IF;
    END IF;

    RETURN _count;
END;
$$;

ALTER FUNCTION fn_get_shop_customer_order_count(BIGINT, TEXT) OWNER TO btp;

CREATE FUNCTION fn_calculate_shop_avg_rating(_shop_id bigint) RETURNS double precision
    LANGUAGE plpgsql
AS
$$
declare
    _avg float;
begin
    select avg(avg_rating) into _avg from
        (select bird.id, bird.avg_rating, shop_id
         from bird
         where avg_rating IS NOT NULL
         union
         select cage.id, cage.avg_rating, shop_id
         from cage
         where avg_rating IS NOT NULL
         union
         select accessory.id, accessory.avg_rating, shop_id
         from accessory
         where avg_rating IS NOT NULL
         union
         select food.id, food.avg_rating, shop_id
         from food
         where avg_rating IS NOT NULL) as tbl
    where shop_id = _shop_id;

    return _avg;
end;
$$;

ALTER FUNCTION fn_calculate_shop_avg_rating(BIGINT) OWNER TO btp;

CREATE FUNCTION fn_generate_product_combo_key(shop_username text) RETURNS text
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_uid TEXT;
    done    BOOL;
BEGIN
    done := FALSE;
    WHILE NOT done
        LOOP
            new_uid :=
                    CONCAT(MD5('' || NOW()::TEXT || RANDOM()::TEXT), '|',
                           TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD|HH:MI:SS'),
                           '|', shop_username);
            done := NOT EXISTS(SELECT 1 FROM public.product_combo WHERE public.product_combo.master_key = new_uid);
        END LOOP;
    RETURN new_uid;
END;
$$;

ALTER FUNCTION fn_generate_product_combo_key(TEXT) OWNER TO btp;

CREATE PROCEDURE get_number_total_of_orders(IN fromdate timestamp with time zone, INOUT count_out integer)
    LANGUAGE plpgsql
AS
$$
begin
    SELECT COUNT(*) into count_out from public.customer_order co WHERE co.created_at >= fromDate;
end;$$;

ALTER PROCEDURE get_number_total_of_orders(TIMESTAMP WITH TIME ZONE, INOUT INTEGER) OWNER TO btp;

CREATE PROCEDURE procedure_name(IN _parameter timestamp with time zone, INOUT result refcursor)
    LANGUAGE plpgsql
AS
$$
BEGIN
    open result for SELECT  * from public.customer_order co where co.created_at >= _parameter;
END;
$$;

ALTER PROCEDURE procedure_name(TIMESTAMP WITH TIME ZONE, INOUT REFCURSOR) OWNER TO btp;

CREATE PROCEDURE get_total_cars_by_model1(IN model_in character varying, OUT count_out integer)
    LANGUAGE plpgsql
AS
$$ BEGIN
    SELECT COUNT(*) into count_out from public.customer_order co WHERE co.description = model_in;
END $$;

ALTER PROCEDURE get_total_cars_by_model1(VARCHAR, OUT INTEGER) OWNER TO btp;

CREATE PROCEDURE get_total_cars_by_model2(IN model_in text, OUT count_out integer)
    LANGUAGE plpgsql
AS
$$ BEGIN
    SELECT COUNT(*) into count_out from public.customer_order co WHERE co.created_at >= model_in;
END $$;

ALTER PROCEDURE get_total_cars_by_model2(TEXT, OUT INTEGER) OWNER TO btp;

CREATE PROCEDURE get_total_cars_by_model3(IN model_in text, OUT count_out integer)
    LANGUAGE plpgsql
AS
$$ BEGIN
    SELECT COUNT(*) into count_out from public.customer_order co WHERE co.created_at >= model_in::timestamptz;
END $$;

ALTER PROCEDURE get_total_cars_by_model3(TEXT, OUT INTEGER) OWNER TO btp;

CREATE FUNCTION fn_get_product_count_of_btp_by_status(status_ text, shop_id_ bigint) RETURNS integer
    LANGUAGE plpgsql
AS
$$
DECLARE
    bird_count_      INT;
    accessory_count_ INT;
    food_count_      INT;
    cage_count_      INT;

BEGIN
    SELECT COUNT(id) into bird_count_
    FROM bird
    WHERE CASE WHEN shop_id_ IS NOT NULL THEN shop_id = shop_id_ AND status = status_ ELSE status = status_ END;
    SELECT COUNT(id) into accessory_count_
    FROM accessory
    WHERE CASE WHEN shop_id_ IS NOT NULL THEN shop_id = shop_id_ AND status = status_ ELSE status = status_ END;
    SELECT COUNT(id) into food_count_
    FROM food
    WHERE CASE WHEN shop_id_ IS NOT NULL THEN shop_id = shop_id_ AND status = status_ ELSE status = status_ END;
    SELECT COUNT(id) into cage_count_
    FROM cage
    WHERE CASE WHEN shop_id_ IS NOT NULL THEN shop_id = shop_id_ AND status = status_ ELSE status = status_ END;
    RETURN bird_count_ + accessory_count_ + food_count_ + cage_count_;
END;
$$;

ALTER FUNCTION fn_get_product_count_of_btp_by_status(TEXT, BIGINT) OWNER TO btp;

