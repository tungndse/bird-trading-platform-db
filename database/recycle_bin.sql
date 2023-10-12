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
    CONSTRAINT fk_crafting_request_shape_option FOREIGN KEY (shape_option_id) REFERENCES cage_model_shape_option (id),

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



