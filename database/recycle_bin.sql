CREATE TABLE warranty
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    name        TEXT                  NOT NULL,
    duration    SMALLINT              NOT NULL DEFAULT 1, -- 0 = life
    description TEXT,

    shop_id     BIGINT                NOT NULL,

    CONSTRAINT fk_warranty_product FOREIGN KEY (shop_id) REFERENCES account (id),
    CONSTRAINT chk_duration CHECK ( duration > -1 )
);

CREATE TABLE product_has_warranty
(
    product_id  BIGINT NOT NULL PRIMARY KEY,
    warranty_id BIGINT NOT NULL,

    CONSTRAINT fk_product_has_warranty_product FOREIGN KEY (product_id) REFERENCES product (id),
    CONSTRAINT fk_product_has_warranty_warranty FOREIGN KEY (warranty_id) REFERENCES warranty (id)
);


create table cage_model
(
    id          bigserial
        primary key,
    shop_id     bigint  not null
        constraint fk_cage_model_product
            references account,
    species_id  bigint  not null
        constraint fk_cage_model_species
            references bird_type,
    name        text    not null,
    code        text    not null,
    value       numeric not null
        constraint chk_cage_model_value
            check (value >= (0)::numeric),
    description text,
    constraint uq_cage_model_code_per_shop
        unique (code, shop_id)
);

-----

create table cage_model_feature_option
(
    id              bigserial
        primary key,
    cage_model_id   bigint             not null
        constraint fk_cage_model_feature_option_cage_model
            references cage_model,
    cage_feature_id bigint             not null
        constraint fk_cage_model_feature_option_cage_feature
            references cage_feature,
    description     text,
    type            text               not null,
    value           numeric  default 0 not null,
    duration_hour   smallint default 0 not null
);


CREATE TABLE cage_model_material_option
(
    id            BIGSERIAL PRIMARY KEY NOT NULL,
    cage_model_id BIGINT                NOT NULL,
    material_id   BIGINT                NOT NULL,

    value         NUMERIC               NOT NULL DEFAULT 0,
    duration_hour SMALLINT              NOT NULL DEFAULT 0,
    description   TEXT,

    CONSTRAINT uq_cage_model_material_option UNIQUE (cage_model_id, material_id),
    CONSTRAINT fk_cmmo_cage_model FOREIGN KEY (cage_model_id) REFERENCES cage_model (id),
    CONSTRAINT fk_cmmo_material FOREIGN KEY (material_id) REFERENCES cage_material (id),
    CONSTRAINT chk_cmmo_value CHECK ( value >= 0 ),
    CONSTRAINT chk_cmmo_duration_hour CHECK ( duration_hour > -1 )
);
CREATE TABLE cage_model_vignette_option
(
    id            BIGSERIAL PRIMARY KEY NOT NULL,
    cage_model_id BIGINT                NOT NULL,
    vignette_id   BIGINT                NOT NULL,

    value         NUMERIC               NOT NULL DEFAULT 0,
    duration_hour SMALLINT              NOT NULL DEFAULT 0,
    description   TEXT,

    CONSTRAINT uq_cage_model_vignette_option UNIQUE (cage_model_id, vignette_id),
    CONSTRAINT fk_cmvo_cage_model FOREIGN KEY (cage_model_id) REFERENCES cage_model (id),
    CONSTRAINT fk_cmvo_vignette FOREIGN KEY (vignette_id) REFERENCES cage_vignette (id),
    CONSTRAINT chk_cmvo_value CHECK ( value >= 0 ),
    CONSTRAINT chk_cmvo_duration_hour CHECK ( duration_hour > -1 )
);

CREATE TABLE cage_model_picket_option
(
    id            BIGSERIAL PRIMARY KEY NOT NULL,
    cage_model_id BIGINT                NOT NULL,
    picket_num_id BIGINT                NOT NULL,

    value         NUMERIC               NOT NULL DEFAULT 0,
    duration_hour SMALLINT              NOT NULL DEFAULT 0,
    description   TEXT,

    CONSTRAINT fk_cmpo_cage_model FOREIGN KEY (cage_model_id) REFERENCES cage_model (id),
    CONSTRAINT chk_cmpo_value CHECK ( value >= 0 ),
    CONSTRAINT chk_cmpo_duration_hour CHECK ( duration_hour > -1 )
);

CREATE TABLE crafting_request
(
    id                   BIGSERIAL PRIMARY KEY NOT NULL,
    cage_model_id        BIGINT                NOT NULL,
    customer_order_id    BIGINT                NOT NULL,

    material_option_id   BIGINT                NOT NULL,
    vignette_option_id   BIGINT                NOT NULL,
    picket_set_option_id BIGINT                NOT NULL,
    shape_option_id      BIGINT                NOT NULL,

    quantity             SMALLINT              NOT NULL DEFAULT 1,
    total_price          NUMERIC               NOT NULL DEFAULT 0,

    CONSTRAINT fk_crafting_request_cage_model FOREIGN KEY (cage_model_id) REFERENCES cage_model (id),
    CONSTRAINT fk_crafting_request_customer_order FOREIGN KEY (customer_order_id) REFERENCES customer_order (id),
    CONSTRAINT fk_crafting_request_material_option FOREIGN KEY (material_option_id) REFERENCES cage_model_material_option (id),
    CONSTRAINT fk_crafting_request_vignette_option FOREIGN KEY (vignette_option_id) REFERENCES cage_model_vignette_option (id),
    CONSTRAINT fk_crafting_request_picket_option FOREIGN KEY (picket_set_option_id) REFERENCES cage_model_picket_option (id),
    --CONSTRAINT fk_crafting_request_shape_option FOREIGN KEY (shape_option_id) REFERENCES cage_model_shape_option (id),

    CONSTRAINT chk_crafting_request_quantity CHECK ( quantity > -1 ),
    CONSTRAINT chk_crafting_request_price CHECK ( total_price >= 0 )
);

CREATE TABLE cage_picket_num
(
    id     BIGSERIAL PRIMARY KEY NOT NULL,
    amount SMALLINT              NOT NULL,

    CONSTRAINT chk_cage_picket_num_amount CHECK ( amount > 0)
);

CREATE TABLE cage_shape
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,

    name        TEXT                  NOT NULL,
    description TEXT

);
----
CREATE TABLE cage_material
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,

    name        TEXT                  NOT NULL,
    description TEXT

);

CREATE TABLE cage_vignette
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,

    name        TEXT,
    description TEXT                  NOT NULL

);

CREATE TABLE cage_model_feature_option
(
    id              BIGSERIAL PRIMARY KEY NOT NULL,
    cage_model_id   BIGINT                NOT NULL,
    cage_feature_id BIGINT                NOT NULL,

    description     TEXT,
    type            TEXT                  NOT NULL,
    value           NUMERIC               NOT NULL DEFAULT 0,
    duration_hour   SMALLINT              NOT NULL DEFAULT 0,

    CONSTRAINT fk_cage_model_feature_option_cage_model FOREIGN KEY (cage_model_id) REFERENCES cage_model (id),
    CONSTRAINT fk_cage_model_feature_option_cage_feature FOREIGN KEY (cage_feature_id) REFERENCES cage_feature (id)
);

CREATE TABLE voucher_product
(
    id         BIGSERIAL PRIMARY KEY NOT NULL,
    voucher_id BIGINT                NOT NULL,
    product_id BIGINT                NOT NULL,

    CONSTRAINT fk_voucher_product_voucher FOREIGN KEY (voucher_id) REFERENCES voucher (id),
    CONSTRAINT fk_voucher_product_product FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE TABLE bird_species
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    name        TEXT                  NOT NULL,
    description TEXT,

    CONSTRAINT uq_bird_species_name UNIQUE (name)
);

CREATE TABLE bird_agegroup
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    name        TEXT                  NOT NULL,
    description TEXT,

    CONSTRAINT uq_bird_agegroup_name UNIQUE (name)
);

CREATE TABLE bird_origin
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,

    name        TEXT                  NOT NULL,
    description TEXT,

    CONSTRAINT uq_bird_origin_name UNIQUE (name)
);

CREATE TABLE bird_mutation
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    shop_id     BIGINT                NOT NULL,

    name        TEXT                  NOT NULL,
    description TEXT,

    CONSTRAINT uq_bird_mutation_name_per_shop UNIQUE (name, shop_id),
    CONSTRAINT fk_bird_mutation_account FOREIGN KEY (shop_id) REFERENCES account (id)
);

CREATE TABLE bird_document
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    shop_id     BIGINT                NOT NULL,

    name        TEXT                  NOT NULL,
    description TEXT,

    CONSTRAINT uq_bird_document_name_per_shop UNIQUE (name, shop_id),
    CONSTRAINT fk_bird_document_account FOREIGN KEY (shop_id) REFERENCES account (id)
);

CREATE TABLE sub_bird_has_document
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    sub_bird_id BIGINT                NOT NULL,
    document_id BIGINT                NOT NULL,

    CONSTRAINT fk_bird_bird_feature_sub_bird FOREIGN KEY (sub_bird_id) REFERENCES sub_bird (id),
    CONSTRAINT fk_bird_bird_feature_bird_feature FOREIGN KEY (document_id) REFERENCES bird_document (id)

);

CREATE TABLE sub_bird_has_mutation
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    sub_bird_id BIGINT                NOT NULL,
    mutation_id BIGINT                NOT NULL,

    CONSTRAINT fk_bird_bird_feature_bird FOREIGN KEY (sub_bird_id) REFERENCES sub_bird (id),
    CONSTRAINT fk_bird_bird_feature_bird_feature FOREIGN KEY (mutation_id) REFERENCES bird_mutation (id)
);


CREATE TABLE package_delivery_distinct_tariff
(
    id          BIGINT DEFAULT NEXTVAL('package_delivery_tariff_id_seq'::REGCLASS) NOT NULL
        CONSTRAINT package_delivery_tariff_pkey
            PRIMARY KEY,
    type        TEXT                                                               NOT NULL
        CONSTRAINT chk_package_delivery_tariff_type
            CHECK (type = ANY (ARRAY ['STD'::TEXT, 'ECO'::TEXT, 'FAST'::TEXT])),
    from_weight INTEGER                                                            NOT NULL,
    to_weight   INTEGER                                                            NOT NULL,
    value       NUMERIC                                                            NOT NULL
        CONSTRAINT chk_package_delivery_tariff_value
            CHECK (value >= (0)::NUMERIC),
    CONSTRAINT chk_package_delivery_tariff_weight_range
        CHECK ((from_weight > 0) AND (from_weight < 1000000) AND (to_weight > 0) AND (to_weight < 1000000))
);

ALTER TABLE package_delivery_distinct_tariff
    OWNER TO btp;

CREATE INDEX idx_delivery_type_tariff
    ON package_delivery_distinct_tariff (type);

CREATE TABLE package_delivery_metadata
(
    type                     TEXT              NOT NULL
        CONSTRAINT uq_package_delivery_max_measure_type
            UNIQUE,
    saturated_value_step     NUMERIC DEFAULT 0 NOT NULL,
    saturated_value          NUMERIC DEFAULT 0 NOT NULL,
    max_weight               INTEGER           NOT NULL,
    max_width                INTEGER           NOT NULL,
    max_length               INTEGER           NOT NULL,
    max_height               INTEGER           NOT NULL,
    standard_cubic_cm_per_kg INTEGER           NOT NULL,
    saturated_to_weight      INTEGER,
    saturated_from_weight    INTEGER
);

insert into public.package_delivery_metadata (type, saturated_value_step, saturated_value, max_weight, max_width, max_length, max_height, standard_cubic_cm_per_kg, saturated_to_weight, saturated_from_weight)
values  ('ECO', 1350, 16200, 200000, 100000, 100000, 100000, 6000, 2004, 1005),
        ('FAST', 0, 22000, 30000, 60, 60, 60, 6000, 30000, 1),
        ('STD', 2400, 23600, 119994, 200, 200, 200, 6000, 3504, 3005);

insert into public.package_delivery_distinct_tariff (id, type, from_weight, to_weight, value)
values  (1594, 'STD', 1, 504, 16500),
        (1595, 'STD', 505, 1004, 18300),
        (1596, 'STD', 1005, 1504, 19600),
        (1597, 'STD', 1505, 2504, 20700),
        (1598, 'STD', 2505, 3004, 21200),
        (1599, 'STD', 3005, 3504, 23600),
        (1600, 'ECO', 1, 254, 13500),
        (1601, 'ECO', 255, 504, 14750),
        (1602, 'ECO', 505, 1004, 14850),
        (1603, 'ECO', 1005, 2004, 16200),
        (1604, 'FAST', 1, 30000, 22000);

