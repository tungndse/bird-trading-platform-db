CREATE TABLE bird_species_delivery_tariff
(
    id         BIGSERIAL PRIMARY KEY NOT NULL,
    species_id BIGINT                NOT NULL,
    value      NUMERIC               NOT NULL DEFAULT 0,
    size_type  TEXT                  NOT NULL,

    CONSTRAINT fk_bird_species_delivery_tariff_species FOREIGN KEY (species_id) REFERENCES bird_type (id),
    CONSTRAINT chk_va
);

CREATE TABLE sub_food_for_agegroup
(
    id          BIGSERIAL PRIMARY KEY NOT NULL,
    sub_food_id BIGINT                NOT NULL,
    agegroup_id BIGINT                NOT NULL,

    CONSTRAINT fk_sub_food_for_agegroup_sub_food FOREIGN KEY (sub_food_id) REFERENCES sub_food,
    CONSTRAINT fk_sub_food_for_agegroup_agegroup FOREIGN KEY (agegroup_id) REFERENCES bird_agegroup

);

CREATE TABLE bird_agegroup
(
    id   BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,

    CONSTRAINT uq_bird_agegroup_name UNIQUE (name)
);

---- DELIVERY -------------------------

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



