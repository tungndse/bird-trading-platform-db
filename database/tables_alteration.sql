ALTER TABLE accessory
    DROP CONSTRAINT fk_accessory_shop_created_by;

ALTER TABLE accessory
    ADD CONSTRAINT fk_accessory_shop_created_by
        FOREIGN KEY (created_by) REFERENCES account;

ALTER TABLE accessory
    DROP CONSTRAINT fk_accessory_shop_updated_by;

ALTER TABLE accessory
    ADD CONSTRAINT fk_accessory_shop_updated_by
        FOREIGN KEY (updated_by) REFERENCES account;


ALTER TABLE accessory
    ADD CONSTRAINT fk_accessory_shop_deleted_by
        FOREIGN KEY (deleted_by) REFERENCES account;

SELECT *
FROM address;

ALTER TABLE address
    ADD COLUMN formatted_description TEXT;

ALTER TABLE address
    ALTER COLUMN ward_code DROP NOT NULL;

UPDATE address
SET description = address.formatted_description;


ALTER TABLE customer_order_item
ADD COLUMN customer_cart_item_id BIGINT;

ALTER TABLE customer_order_item
ADD CONSTRAINT fk_customer_order_item_customer_cart_item FOREIGN KEY (customer_cart_item_id)
REFERENCES customer_cart_item;


ALTER TABLE feedback
ADD COLUMN media jsonb;




