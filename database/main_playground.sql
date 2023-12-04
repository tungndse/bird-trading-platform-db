-- 29/10/2023 REVIEW TABLE ALTERATION

ALTER TABLE cage_shape
    DROP CONSTRAINT fk_cage_shape_shop;
ALTER TABLE cage_shape
    DROP COLUMN shop_id; -- Shape will be shared among the whole system instead of for different shop

ALTER TABLE cage_material
    DROP CONSTRAINT fk_cage_material_shop;
ALTER TABLE cage_material
    DROP COLUMN shop_id; -- material will be shared among the whole system instead of for different shop

ALTER TABLE cage_vignette
    DROP CONSTRAINT fk_cage_vignette_shop;
ALTER TABLE cage_vignette
    DROP COLUMN shop_id; -- vignette will be shared among the whole system instead of for different shop

DROP TABLE cage_picket;

ALTER TABLE sub_cage
    DROP CONSTRAINT fk_sub_cage_picket_num;

ALTER TABLE sub_cage
    DROP COLUMN picket_num_id;

ALTER TABLE sub_cage
    ADD COLUMN picket_num SMALLINT NOT NULL DEFAULT 0;
-- picket table is obsolete, should only be a field
-- instead of having its own table
ALTER TABLE customer_order_item
    ADD COLUMN price NUMERIC NOT NULL DEFAULT 0;

-- 29/10/2023 REVIEW NEW TABLES

-- PRODUCT SUGGESTION RELATION, since product table is removed,
-- we have to create rel table for each relation that makes sense

-- MANY-TO-MANY
CREATE TABLE bird_cage_suggestion
( -- bird or sub_bird? cage_or_subcage? product or sub_product?
    bird_id BIGINT NOT NULL,
    cage_id BIGINT NOT NULL,

    CONSTRAINT pk_bird_cage_suggestion PRIMARY KEY (bird_id, cage_id),
    CONSTRAINT fk_bird_cage_suggestion_bird FOREIGN KEY (bird_id) REFERENCES bird,
    CONSTRAINT fk_bird_cage_suggestion_cage FOREIGN KEY (cage_id) REFERENCES cage
);

-- MANY-TO-MANY
CREATE TABLE bird_food_suggestion
(
    bird_id BIGINT NOT NULL,
    food_id BIGINT NOT NULL,

    CONSTRAINT pk_bird_food_suggestion PRIMARY KEY (bird_id, food_id),
    CONSTRAINT fk_bird_food_suggestion_bird FOREIGN KEY (bird_id) REFERENCES bird,
    CONSTRAINT fk_bird_food_suggestion_food FOREIGN KEY (food_id) REFERENCES food

);

-- MANY-TO-MANY
CREATE TABLE cage_accessory_suggestion
(
    cage_id      BIGINT NOT NULL,
    accessory_id BIGINT NOT NULL,

    CONSTRAINT pk_cage_accessory_suggestion PRIMARY KEY (cage_id, accessory_id),
    CONSTRAINT fk_cage_accessory_suggestion_cage FOREIGN KEY (cage_id) REFERENCES cage,
    CONSTRAINT fk_cage_accessory_suggestion_accessory FOREIGN KEY (accessory_id) REFERENCES accessory

);

-- MANY-TO-MANY
CREATE TABLE bird_accessory_suggestion
(
    bird_id      BIGINT NOT NULL,
    accessory_id BIGINT NOT NULL,

    CONSTRAINT pk_bird_accessory_suggestion PRIMARY KEY (bird_id, accessory_id),
    CONSTRAINT fk_bird_accessory_suggestion_bird FOREIGN KEY (bird_id) REFERENCES bird,
    CONSTRAINT fk_bird_accessory_suggestion_accessory FOREIGN KEY (accessory_id) REFERENCES accessory

);

ALTER TABLE cage_shape
    ADD CONSTRAINT fk_cage_shape_shop FOREIGN KEY (shop_id) REFERENCES account;
ALTER TABLE cage_shape
    ADD COLUMN shop_id BIGINT; -- Shape will be shared among the whole system instead of for different shop

ALTER TABLE cage_material
    ADD CONSTRAINT fk_cage_material_shop FOREIGN KEY (shop_id) REFERENCES account;
ALTER TABLE cage_material
    ADD COLUMN shop_id BIGINT; -- material will be shared among the whole system instead of for different shop

ALTER TABLE cage_vignette
    ADD CONSTRAINT fk_cage_vignette_shop FOREIGN KEY (shop_id) REFERENCES account;
ALTER TABLE cage_vignette
    ADD COLUMN shop_id BIGINT;
-- vignette will be shared among the whole system instead of for different shop

--CHANGES BASED ON REVIEW2 RE-EVALUATION
-- 1. Drop all shop_id reference in cage features,
-- shop will use a shared pool of feature instead of defining their own
ALTER TABLE cage_shape
    DROP COLUMN shop_id;
ALTER TABLE cage_material
    DROP COLUMN shop_id;
ALTER TABLE cage_vignette
    DROP COLUMN shop_id;

-- 2. Product suggestion will be based on their eco system,
-- specifically the bird type (species) instead of product to product

-- 3. Delivery tariff: Create 3 tables: Delivery Package, Delivery Package Timing
-- and Bird-size Bundle Delivery Tariff
-- ** NOTE: Do not listen to the idiots who tells you to make everything Enums, such kind of idiotic design
-- is what causing the trouble from the beginning

-- DELIVERY TYPE TABLE
CREATE TABLE delivery_type
(
    id                 BIGSERIAL PRIMARY KEY,
    code_name          TEXT NOT NULL,

    name               TEXT NOT NULL,
    description        TEXT,

    preparation_hours  NUMERIC,
    kilometer_per_hour NUMERIC

);

INSERT INTO delivery_type(code_name, name, description, preparation_hours, kilometer_per_hour)
VALUES ('STD', 'Standard', 'Standard delivery package', 5, 40),
       ('ECO', 'Economy', 'Economy delivery package', 8, 30),
       ('FAST', 'Fast', 'Fast delivery package', 2, 60),
       ('DELUXE', 'Quality', 'Quality delivery package', 5, 30);


-- BIRDSIZE BATCH RATE
CREATE TABLE birdsize_batch_delivery_rate
(
    id               BIGSERIAL PRIMARY KEY,
    delivery_type_id BIGINT   NOT NULL,
    quantity_from    SMALLINT NOT NULL,
    quantity_to      SMALLINT NOT NULL,
    rate             FLOAT    NOT NULL,

    CONSTRAINT fk_birdsize_batch_delivery_rate_delivery_type
        FOREIGN KEY (delivery_type_id) REFERENCES delivery_type
);


-- UPDATE TARIFF TABLES FROM USING ENUM TEXT TO USING REFERENCE RELATION
-- package_delivery_tariff
-- -- add reference column without constraint
ALTER TABLE package_delivery_tariff
    ADD COLUMN delivery_type_id BIGINT;

-- -- updating referenced column
UPDATE package_delivery_tariff pdt
SET delivery_type_id = sub_query.id
FROM (SELECT id, code_name FROM delivery_type) AS sub_query
WHERE pdt.type = sub_query.code_name;

-- -- drop enum column
ALTER TABLE package_delivery_tariff
    DROP COLUMN type;

-- -- add foreign key constraint to newly added column
ALTER TABLE package_delivery_tariff
    ADD CONSTRAINT fk_package_delivery_tariff_delivery_type FOREIGN KEY (delivery_type_id)
        REFERENCES delivery_type;

-- -- restrict NOT NULL
ALTER TABLE package_delivery_tariff
    ALTER COLUMN delivery_type_id SET NOT NULL;

-- bird_size_delivery_tariff
ALTER TABLE birdsize_delivery_tariff
    ADD COLUMN delivery_type_id BIGINT;

UPDATE birdsize_delivery_tariff
SET delivery_type_id = sub_query.id
FROM (SELECT id, code_name FROM delivery_type) AS sub_query
WHERE type = sub_query.code_name;

ALTER TABLE birdsize_delivery_tariff
    DROP COLUMN type;

ALTER TABLE birdsize_delivery_tariff
    ADD CONSTRAINT fk_birdsize_delivery_tariff_delivery_type
        FOREIGN KEY (delivery_type_id) REFERENCES delivery_type;

ALTER TABLE birdsize_delivery_tariff
    ALTER COLUMN delivery_type_id SET NOT NULL;

-- package_delivery_saturated_step_tariff
ALTER TABLE package_delivery_saturated_step_tariff
    ADD COLUMN delivery_type_id BIGINT;

UPDATE package_delivery_saturated_step_tariff
SET delivery_type_id = sub_query.id
FROM (SELECT id, code_name FROM delivery_type) AS sub_query
WHERE delivery_type = sub_query.code_name;

ALTER TABLE package_delivery_saturated_step_tariff
    ADD CONSTRAINT fk_package_delivery_saturated_step_tariff_delivery_type FOREIGN KEY (delivery_type_id)
        REFERENCES delivery_type;

ALTER TABLE package_delivery_saturated_step_tariff
    ALTER COLUMN delivery_type_id SET NOT NULL;

ALTER TABLE package_delivery_saturated_step_tariff
    DROP COLUMN delivery_type;

--------------------------------------

-- ADDING DATA FOR DELUXE DELIVERY TYPE FOR PACKAGE_TARIFF

INSERT INTO package_delivery_tariff (weight_from, weight_to, value, distance_type_id, delivery_type_id)
SELECT weight_from, weight_to, value, distance_type_id, 4
FROM package_delivery_tariff
WHERE delivery_type_id = 1;

-- TEST

SELECT delivery_type_id, COUNT(id)
FROM package_delivery_tariff
GROUP BY delivery_type_id;

-- ALTERING NEWLY CREATED DATA TO LOOK MORE REAL

-- -- package_delivery_tariff
UPDATE package_delivery_tariff
SET value = CASE distance_type_id
                WHEN 1 THEN value + 200
                WHEN 2 THEN value + 250
                WHEN 3 THEN value + 300
                WHEN 4 THEN value + 350
                ELSE value END
WHERE delivery_type_id = 4;

-- -- birdsize_delivery_tariff
INSERT INTO birdsize_delivery_tariff (bird_size_group, distance_type_id, value, delivery_type_id)
SELECT bird_size_group, distance_type_id, value * 1.2, 4
FROM birdsize_delivery_tariff
WHERE delivery_type_id = 1;

-- -- TEST
SELECT delivery_type_id, COUNT(id)
FROM birdsize_delivery_tariff
GROUP BY delivery_type_id;


ALTER TABLE cage
    ADD CONSTRAINT fk_cage_shop_created_by FOREIGN KEY (created_by) REFERENCES cage;


ALTER TABLE food
    ADD COLUMN created_by BIGINT;

ALTER TABLE food
    ADD CONSTRAINT fk_food_shop_created_by FOREIGN KEY (created_by) REFERENCES food;
ALTER TABLE food
    ADD COLUMN updated_by BIGINT;

ALTER TABLE food
    ADD CONSTRAINT fk_cage_food_updated_by FOREIGN KEY (updated_by) REFERENCES food;

ALTER TABLE food
    ADD COLUMN deleted_by BIGINT;

ALTER TABLE food
    ADD CONSTRAINT fk_cage_food_deleted_by FOREIGN KEY (deleted_by) REFERENCES food;

ALTER TABLE cage
    ADD CONSTRAINT fk_cage_shop_created_by FOREIGN KEY (created_by) REFERENCES cage;

ALTER TABLE bird
    ADD CONSTRAINT fk_cage_shop_updated_by FOREIGN KEY (updated_by) REFERENCES cage;

ALTER TABLE bird
    ADD CONSTRAINT fk_cage_shop_deleted_by FOREIGN KEY (deleted_by) REFERENCES cage;

DELETE
FROM voucher_item
WHERE customer_order_id IN (85, 86, 87, 88, 89);

UPDATE customer_order
SET payment_type = 'COD';


ALTER TABLE product_favorite
    ADD CONSTRAINT uq_product_favorite_accountid_foodid UNIQUE (account_id, food_id);
ALTER TABLE product_favorite
    ADD CONSTRAINT uq_product_favorite_accountid_cageid UNIQUE (account_id, cage_id);
ALTER TABLE product_favorite
    ADD CONSTRAINT uq_product_favorite_accountid_accessoryid UNIQUE (account_id, accessory_id);
ALTER TABLE product_favorite
    ADD CONSTRAINT uq_product_favorite_accountid_birdid UNIQUE (account_id, bird_id);

-- TEST

INSERT INTO product_favorite
VALUES (DEFAULT, 3, NULL, NULL, NULL, 4, 'BIRD');


SELECT *
FROM customer_order;


CREATE TABLE account_creation_request
(
    id                  BIGSERIAL PRIMARY KEY,
    name                TEXT   NOT NULL,
    description         TEXT   NOT NULL,
    media               JSONB,
    status              TEXT        DEFAULT 'PENDING',
    reply               TEXT,

    account_id          BIGINT NOT NULL,

    created_at          TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMPTZ,
    approved_at         TIMESTAMPTZ,
    disapproved_at      TIMESTAMPTZ,
    requested_update_at TIMESTAMPTZ,

    CONSTRAINT fk_account_creation_request_account FOREIGN KEY (account_id) REFERENCES account

);

UPDATE bird
SET origin =
SELECT a.name
FROM (SELECT bird.id, bird_origin.name
    FROM bird
    INNER JOIN bird_origin ON bird.origin_id = bird_origin.id) AS a;

UPDATE bird AS b
SET origin = c.column_a
FROM bird
         INNER JOIN bird_origin ON bird.origin_id = bird_origin.id
WHERE c.column_b = t.column_b;

UPDATE train
SET var1 = (SELECT cars.var1
            FROM cars
            WHERE train.var2 LIKE cars.var2
            ORDER BY train.user_id = cars.user_id DESC
            LIMIT 1);

UPDATE food
SET origin = bird_origin.name
FROM bird_origin
WHERE food.origin_id= bird_origin.id;