CREATE TABLE administrative_regions
(
    id           INTEGER      NOT NULL
        PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    name_en      VARCHAR(255) NOT NULL,
    code_name    VARCHAR(255),
    code_name_en VARCHAR(255)
);

CREATE TABLE administrative_units
(
    id            INTEGER NOT NULL
        PRIMARY KEY,
    full_name     VARCHAR(255),
    full_name_en  VARCHAR(255),
    short_name    VARCHAR(255),
    short_name_en VARCHAR(255),
    code_name     VARCHAR(255),
    code_name_en  VARCHAR(255)
);

CREATE TABLE province
(
    code                     VARCHAR(20)  NOT NULL
        CONSTRAINT provinces_pkey
            PRIMARY KEY,
    name                     VARCHAR(255) NOT NULL,
    name_en                  VARCHAR(255),
    full_name                VARCHAR(255) NOT NULL,
    full_name_en             VARCHAR(255),
    code_name                VARCHAR(255),
    administrative_unit_id   INTEGER
        CONSTRAINT fk_provinces_administrative_unit
            REFERENCES administrative_units,
    administrative_region_id INTEGER
        CONSTRAINT fk_provinces_administrative_region
            REFERENCES administrative_regions
);

CREATE INDEX idx_provinces_region
    ON province (administrative_region_id);

CREATE INDEX idx_provinces_unit
    ON province (administrative_unit_id);

CREATE TABLE district
(
    code                   VARCHAR(20)  NOT NULL
        CONSTRAINT districts_pkey
            PRIMARY KEY,
    name                   VARCHAR(255) NOT NULL,
    name_en                VARCHAR(255),
    full_name              VARCHAR(255),
    full_name_en           VARCHAR(255),
    code_name              VARCHAR(255),
    province_code          VARCHAR(20)
        CONSTRAINT fk_districts_province
            REFERENCES province,
    administrative_unit_id INTEGER
        CONSTRAINT fk_districts_administrative_unit
            REFERENCES administrative_units
);

CREATE INDEX idx_districts_province
    ON district (province_code);

CREATE INDEX idx_districts_unit
    ON district (administrative_unit_id);

CREATE TABLE ward
(
    code                   VARCHAR(20)  NOT NULL
        CONSTRAINT wards_pkey
            PRIMARY KEY,
    name                   VARCHAR(255) NOT NULL,
    name_en                VARCHAR(255),
    full_name              VARCHAR(255),
    full_name_en           VARCHAR(255),
    code_name              VARCHAR(255),
    district_code          VARCHAR(20)
        CONSTRAINT fk_wards_district_code
            REFERENCES district,
    administrative_unit_id INTEGER
        CONSTRAINT fk_wards_administrative_unit
            REFERENCES administrative_units
);

CREATE INDEX idx_wards_district
    ON ward (district_code);

CREATE INDEX idx_wards_unit
    ON ward (administrative_unit_id);

CREATE TABLE favorite_product
(
    id           BIGSERIAL PRIMARY KEY NOT NULL,

    account_id   BIGINT                NOT NULL,

    accessory_id BIGINT,
    cage_id      BIGINT,
    food_id      BIGINT,
    bird_id      BIGINT,

    CONSTRAINT fk_favorite_product_account FOREIGN KEY (account_id) REFERENCES account,
    CONSTRAINT fk_favorite_product_accessory FOREIGN KEY (accessory_id) REFERENCES accessory,
    CONSTRAINT fk_favorite_product_cage FOREIGN KEY (cage_id) REFERENCES cage,
    CONSTRAINT fk_favorite_product_food FOREIGN KEY (food_id) REFERENCES food,
    CONSTRAINT fk_favorite_product_bird FOREIGN KEY (bird_id) REFERENCES bird
);



