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
CREATE TABLE distance_type
(
    id            BIGSERIAL PRIMARY KEY NOT NULL,
    name          TEXT                  NOT NULL,
    distance_from DECIMAL DEFAULT 0,
    distance_to   DECIMAL DEFAULT 0,

    CONSTRAINT uq_distance_type_name UNIQUE (name)
);


CREATE TABLE package_delivery_tariff
(
    id               BIGSERIAL PRIMARY KEY NOT NULL,
    type             TEXT                  NOT NULL, --STD --ECO --FAST
    weight_from      INT                   NOT NULL DEFAULT 1,
    weight_to        INT                   NOT NULL DEFAULT 1,
    distance_type_id BIGINT                NOT NULL NOT NULL,
    value            NUMERIC               NOT NULL DEFAULT 0,


    CONSTRAINT chk_package_delivery_tariff_weight
        CHECK ( weight_from > 0 AND weight_to > 0
            AND weight_from < 1000000 AND weight_to < 1000000
            AND weight_from < weight_to),

    CONSTRAINT fk_package_delivery_tariff_distance_type FOREIGN KEY (distance_type_id) REFERENCES distance_type,

    CONSTRAINT chk_package_delivery_tariff_value CHECK ( value >= 0 )

);

INSERT INTO public.package_delivery_tariff (id, type, weight_from, weight_to, distance_type_id, value)
VALUES (1, 'STD', 1, 500, 1, 23800),
       (4, 'STD', 1, 500, 4, 34500),
       (3, 'STD', 1, 500, 3, 30000),
       (2, 'STD', 1, 500, 2, 26200),
       (5, 'STD', 500, 1000, 1, 27500),
       (6, 'STD', 500, 1000, 2, 29900),
       (7, 'STD', 500, 1000, 3, 34500),
       (8, 'STD', 500, 1000, 4, 39900),
       (9, 'STD', 1000, 1500, 1, 31800),
       (10, 'STD', 1000, 1500, 2, 35600),
       (11, 'STD', 1000, 1500, 3, 41000),
       (12, 'STD', 1000, 1500, 4, 52500),
       (13, 'STD', 1500, 2000, 1, 35800),
       (14, 'STD', 1500, 2000, 2, 39400),
       (15, 'STD', 1500, 2000, 3, 45800),
       (16, 'STD', 1500, 2000, 4, 69900);


CREATE TABLE package_delivery_tariff_test
(
    id               BIGINT  DEFAULT NEXTVAL('package_delivery_tariff_id_seq1'::REGCLASS) NOT NULL
        CONSTRAINT package_delivery_tariff_pkey_test
            PRIMARY KEY,
    type             TEXT                                                                 NOT NULL,
    weight_from      INTEGER DEFAULT 1                                                    NOT NULL,
    weight_to        INTEGER DEFAULT 1                                                    NOT NULL,
    distance_type_id BIGINT                                                               NOT NULL
        CONSTRAINT fk_package_delivery_tariff_distance_type_test
            REFERENCES distance_type,
    value            NUMERIC DEFAULT 0                                                    NOT NULL
        CONSTRAINT chk_package_delivery_tariff_value_test
            CHECK (value >= (0)::NUMERIC),
    CONSTRAINT chk_package_delivery_tariff_weight_test
        CHECK ((weight_from > 0) AND (weight_to > 0) AND (weight_from < 1000000) AND (weight_to < 1000000) AND
               (weight_from < weight_to))
);


INSERT INTO package_delivery_tariff_test (id, type, weight_from, weight_to, distance_type_id, value)
VALUES (1, 'STD', 1, 500, 1, 23800),
       (4, 'STD', 1, 500, 4, 34500),
       (3, 'STD', 1, 500, 3, 30000),
       (2, 'STD', 1, 500, 2, 26200),
       (5, 'STD', 500, 1000, 1, 27500),
       (6, 'STD', 500, 1000, 2, 29900),
       (7, 'STD', 500, 1000, 3, 34500),
       (8, 'STD', 500, 1000, 4, 39900),
       (9, 'STD', 1000, 1500, 1, 31800),
       (10, 'STD', 1000, 1500, 2, 35600),
       (11, 'STD', 1000, 1500, 3, 41000),
       (12, 'STD', 1000, 1500, 4, 52500),
       (13, 'STD', 1500, 2000, 1, 35800),
       (14, 'STD', 1500, 2000, 2, 39400),
       (15, 'STD', 1500, 2000, 3, 45800),
       (16, 'STD', 1500, 2000, 4, 69900);


DO
$$
    DECLARE
        distance_entity_count_ SMALLINT;
        weight_from_temp_      INT;
        weight_to_temp_        INT;
        distance_type_id_      BIGINT;
        value_step_            NUMERIC;
        value_temp_            NUMERIC;
    BEGIN
        distance_entity_count_ := 0;

        weight_from_temp_ := 1500;
        weight_to_temp_ := 2000;

        distance_type_id_ := 1; --2,3,4

        value_temp_ := 35800; --39400, 45800, 69900

        value_step_ := 5500; --6800, 7900, 10900

        WHILE weight_to_temp_ < 1000000 -- 999500

            LOOP

                value_temp_ := value_temp_ + value_step_;

                INSERT INTO package_delivery_tariff_test (type, weight_from, weight_to, distance_type_id, value)
                VALUES ('STD', weight_from_temp_, weight_to_temp_, distance_type_id_, value_temp_);

                weight_from_temp_ := weight_from_temp_ + 500;
                weight_to_temp_ := weight_to_temp_ + 500;


                --distance_type_id_ := distance_type_id_ + 1;

            END LOOP;

    END
$$;

CREATE OR REPLACE FUNCTION auto_generate_delivery_distinct_tariff(_type TEXT, _max_weight INT)
    RETURNS VOID AS
$$
    DECLARE
        distance_entity_count_ SMALLINT;
        weight_from_temp_      INT;
        weight_to_temp_        INT;
        distance_type_id_      BIGINT;
        value_step_            NUMERIC;
        value_temp_            NUMERIC;
    BEGIN
        distance_entity_count_ := 0;

        weight_from_temp_ := 1500;
        weight_to_temp_ := 2000;

        distance_type_id_ := 1; --2,3,4

        value_temp_ := 35800; --39400, 45800, 69900

        value_step_ := 5500; --6800, 7900, 10900

        WHILE weight_to_temp_ < 1000000 -- 999500

            LOOP

                value_temp_ := value_temp_ + value_step_;

                INSERT INTO package_delivery_tariff_test (type, weight_from, weight_to, distance_type_id, value)
                VALUES ('STD', weight_from_temp_, weight_to_temp_, distance_type_id_, value_temp_);

                weight_from_temp_ := weight_from_temp_ + 500;
                weight_to_temp_ := weight_to_temp_ + 500;


                --distance_type_id_ := distance_type_id_ + 1;

            END LOOP;

    END
$$;


