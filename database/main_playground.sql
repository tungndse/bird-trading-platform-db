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
    drop COLUMN picket_num_id;

ALTER TABLE sub_cage
    ADD COLUMN picket_num SMALLINT NOT NULL DEFAULT 0;  -- picket table is obsolete, should only be a field
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
    add CONSTRAINT fk_cage_material_shop FOREIGN KEY (shop_id) REFERENCES account;
ALTER TABLE cage_material
    add COLUMN shop_id bigint; -- material will be shared among the whole system instead of for different shop

ALTER TABLE cage_vignette
    add CONSTRAINT fk_cage_vignette_shop FOREIGN KEY (shop_id) REFERENCES account;
ALTER TABLE cage_vignette
    add COLUMN shop_id bigint; -- vignette will be shared among the whole system instead of for different shop










