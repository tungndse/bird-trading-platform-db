CREATE TABLE account
(
    id          BIGSERIAL
        PRIMARY KEY,
    username    TEXT                               NOT NULL
        CONSTRAINT uq_account_username
            UNIQUE,
    first_name  TEXT                               NOT NULL,
    last_name   TEXT                               NOT NULL,
    role        TEXT                               NOT NULL
        CONSTRAINT chk_account_role
            CHECK (role = ANY (ARRAY ['ADMIN'::TEXT, 'CUSTOMER'::TEXT, 'SHOP'::TEXT, 'DELIVERER'::TEXT])),
    phone       TEXT                               NOT NULL,
    email       TEXT                               NOT NULL,
    description TEXT,
    status      TEXT        DEFAULT 'ACTIVE'::TEXT NOT NULL,
    created_at  TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    deleted_at  TIMESTAMPTZ,
    updated_at  TIMESTAMPTZ,
    created_by  BIGINT
        CONSTRAINT fk_account_created_by
            REFERENCES account,
    deleted_by  BIGINT
        CONSTRAINT fk_account_deleted_by
            REFERENCES account,
    updated_by  BIGINT
        CONSTRAINT fk_account_updated_by
            REFERENCES account,
    password    TEXT                               NOT NULL,
    banned_at   TIMESTAMPTZ,
    CONSTRAINT chk_account_status CHECK ( status IN ('BANNED', 'ACTIVE', 'DELETED') )
);

CREATE TABLE accessory
(
    id          BIGSERIAL          NOT NULL PRIMARY KEY,
    product_id  BIGINT             NOT NULL,

    name        TEXT               NOT NULL,
    quantity    SMALLINT DEFAULT 1 NOT NULL,
    price       NUMERIC  DEFAULT 0 NOT NULL,
    description TEXT,

    CONSTRAINT accessory_product FOREIGN KEY (product_id) REFERENCES product
);

CREATE TABLE product
(
    id            BIGSERIAL             NOT NULL PRIMARY KEY,
    has_sub       BOOLEAN,

    name          TEXT                  NOT NULL,
    description   TEXT                  NOT NULL,
    type          TEXT                  NOT NULL,
    status        TEXT                  NOT NULL DEFAULT 'HIDDEN',

    packed_width  SMALLINT    DEFAULT 1 NOT NULL,
    packed_length SMALLINT    DEFAULT 1 NOT NULL,
    packed_height SMALLINT    DEFAULT 1 NOT NULL,
    packed_weight SMALLINT    DEFAULT 1 NOT NULL,

    created_at    TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMPTZ,
    deleted_at    TIMESTAMPTZ,

    created_by    BIGINT,
    updated_by    BIGINT,
    deleted_by    BIGINT,

    shop_id       BIGINT                NOT NULL,

    CONSTRAINT fk_product_created_by FOREIGN KEY (created_by) REFERENCES account (id),
    CONSTRAINT fk_product_deleted_by FOREIGN KEY (deleted_by) REFERENCES account (id),
    CONSTRAINT fk_product_updated_by FOREIGN KEY (updated_by) REFERENCES account (id),
    CONSTRAINT fk_product_account FOREIGN KEY (shop_id) REFERENCES account (id),

    CONSTRAINT chk_product_width CHECK ( packed_width > 0 AND packed_width < 10000000 ),
    CONSTRAINT chk_product_length CHECK ( packed_length > 0 AND packed_length < 10000000 ),
    CONSTRAINT chk_product_width CHECK ( packed_height > 0 AND packed_height < 10000000 ),
    CONSTRAINT chk_product_weight CHECK ( packed_weight > 0 AND packed_weight < 10000000 )
);

CREATE TABLE cage_feature
(
    id            BIGSERIAL PRIMARY KEY,
    shop_id       BIGINT   NOT NULL,

    type          TEXT     NOT NULL,
    name          TEXT     NOT NULL,
    description   TEXT,
    picket_amount SMALLINT NOT NULL DEFAULT 0,

    CONSTRAINT fk_cage_feature_shop FOREIGN KEY (shop_id) REFERENCES account,
    CONSTRAINT chk_cage_feature_picket CHECK ( picket_amount > -1 )
);

CREATE TABLE cage
(
    id           BIGSERIAL PRIMARY KEY,
    product_id   BIGINT NOT NULL,
    bird_type_id BIGINT NOT NULL,

    name         TEXT   NOT NULL,
    description  TEXT   NOT NULL,

    CONSTRAINT fk_cage_bird_type FOREIGN KEY (bird_type_id) REFERENCES bird_type,
    CONSTRAINT fk_cage_product FOREIGN KEY (product_id) REFERENCES product
);

CREATE TABLE sub_cage
(
    id            BIGSERIAL PRIMARY KEY,
    product_id    BIGINT             NOT NULL,

    cage_id       BIGINT             NOT NULL,
    picket_num_id BIGINT             NOT NULL,
    material_id   BIGINT             NOT NULL,
    vignette_id   BIGINT             NOT NULL,
    shape_id      BIGINT             NOT NULL,

    description   TEXT               NOT NULL,
    quantity      SMALLINT DEFAULT 1 NOT NULL,
    price         NUMERIC  DEFAULT 0 NOT NULL,

    CONSTRAINT fk_sub_cage_cage FOREIGN KEY (cage_id) REFERENCES cage,
    CONSTRAINT fk_sub_cage_picket_num FOREIGN KEY (picket_num_id) REFERENCES cage_feature,
    CONSTRAINT fk_sub_cage_material FOREIGN KEY (material_id) REFERENCES cage_feature,
    CONSTRAINT fk_sub_cage_vignette FOREIGN KEY (vignette_id) REFERENCES cage_feature,
    CONSTRAINT fk_sub_cage_shape FOREIGN KEY (shape_id) REFERENCES cage_feature,

    CONSTRAINT chk_sub_cage_quantity CHECK (quantity > '-1'::INTEGER),
    CONSTRAINT chk_sub_cage_price CHECK (price >= (0)::NUMERIC)

);

CREATE TABLE bird
(
    id           BIGSERIAL PRIMARY KEY NOT NULL,
    product_id   BIGINT                NOT NULL,
    bird_type_id BIGINT                NOT NULL,
    origin_id    BIGINT                NOT NULL,

    has_serial   BOOLEAN,
    agegroup     TEXT                  NOT NULL,
    bundle_type  TEXT                  NOT NULL, -- BATCH, SOLO, NEST
    size_type    TEXT                  NOT NULL,
    description  TEXT                  NOT NULL,

    CONSTRAINT uq_bird_product_id UNIQUE (product_id),
    CONSTRAINT fk_bird_product FOREIGN KEY (product_id) REFERENCES product (id),
    CONSTRAINT fk_bird_bird_type FOREIGN KEY (bird_type_id) REFERENCES bird_type (id)

);

CREATE TABLE sub_bird
(
    id            BIGSERIAL PRIMARY KEY         NOT NULL,
    bird_id       BIGINT                        NOT NULL,
    origin_id     BIGINT                        NOT NULL,
    product_id    BIGINT                        NOT NULL,

    age           SMALLINT                      NOT NULL,
    gender        TEXT     DEFAULT 'NO_SPECIFY' NOT NULL,
    domestication TEXT     DEFAULT 'NO_SPECIFY' NOT NULL,
    description   TEXT                          NOT NULL,
    mutation      TEXT                          NOT NULL,
    color         TEXT                          NOT NULL,
    quantity      SMALLINT DEFAULT 1            NOT NULL,
    price         NUMERIC  DEFAULT 0            NOT NULL,

    CONSTRAINT fk_sub_bird_bird FOREIGN KEY (bird_id) REFERENCES bird (id),
    CONSTRAINT fk_sub_bird_origin FOREIGN KEY (origin_id) REFERENCES bird_origin (id),
    CONSTRAINT fk_sub_bird_product FOREIGN KEY (product_id) REFERENCES product,
    CONSTRAINT chk_sub_bird_age CHECK ( age > 0 ),
    CONSTRAINT chk_sub_bird_quantity CHECK ( quantity > -1 ),
    CONSTRAINT chk_sub_bird_price CHECK ( price > -1 )
);

CREATE TABLE bird_type
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    name        TEXT                  NOT NULL,
    description TEXT,

    CONSTRAINT uq_bird_type_name UNIQUE (name)
);

CREATE TABLE bird_origin
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,

    name        TEXT                  NOT NULL,
    description TEXT,

    CONSTRAINT uq_bird_origin_name UNIQUE (name)
);



CREATE TABLE food
(
    id           BIGSERIAL PRIMARY KEY NOT NULL,
    product_id   BIGINT                NOT NULL,
    bird_type_id BIGINT                NOT NULL,

    type         TEXT                  NOT NULL,
    description  TEXT                  NOT NULL,

    CONSTRAINT uq_food_product_id UNIQUE (product_id),
    CONSTRAINT fk_food_product FOREIGN KEY (product_id) REFERENCES product (id),
    CONSTRAINT fk_food_bird_type FOREIGN KEY (bird_type_id) REFERENCES bird_type,
    CONSTRAINT chk_food_type CHECK ( type IN
                                     ('NUTS', 'FRUIT', 'VEGETABLE', 'NATURAL', 'ARTIFICIAL', 'VITAMIN', 'MEDICINE') )
);

CREATE TABLE sub_food
(
    id         BIGSERIAL PRIMARY KEY NOT NULL,
    food_id    BIGINT                NOT NULL,
    product_id BIGINT                NOT NULL,

    --??

    agegroup   TEXT,
    quantity   SMALLINT DEFAULT 1    NOT NULL,
    price      NUMERIC  DEFAULT 0    NOT NULL,

    CONSTRAINT fk_sub_food_food FOREIGN KEY (food_id) REFERENCES food,
    CONSTRAINT fk_sub_food_product FOREIGN KEY (product_id) REFERENCES product,
    CONSTRAINT chk_sub_bird_quantity CHECK ( quantity > -1 ),
    CONSTRAINT chk_sub_bird_price CHECK ( price > -1 )
);

CREATE TABLE food_specialty
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,

    name        TEXT                  NOT NULL,
    description TEXT,

    CONSTRAINT uq_food_specialty_name UNIQUE (name)
);

CREATE TABLE sub_food_has_specialty
(
    id                BIGSERIAL PRIMARY KEY NOT NULL,
    sub_food_id       BIGINT                NOT NULL,
    food_specialty_id BIGINT                NOT NULL,

    CONSTRAINT fk_sub_food_has_specialty_sub_food FOREIGN KEY (sub_food_id) REFERENCES sub_food,
    CONSTRAINT fk_sub_food_has_specialty_food_specialty FOREIGN KEY (food_specialty_id) REFERENCES food_specialty
);


CREATE TABLE product_suggestion
(
    id                   BIGSERIAL PRIMARY KEY NOT NULL,
    product_id           BIGINT                NOT NULL,
    suggested_product_id BIGINT                NOT NULL,

    CONSTRAINT fk_product_suggestion_product FOREIGN KEY (product_id) REFERENCES product (id),
    CONSTRAINT fk_product_suggestion_suggested_product FOREIGN KEY (suggested_product_id) REFERENCES product (id),
    CONSTRAINT chk_product_suggestion_loop CHECK ( product_id != suggested_product_id )
);

SELECT COUNT(code) FROM district;


SELECT * FROM district WHERE code = '0016';














