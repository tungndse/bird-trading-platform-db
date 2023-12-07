CREATE OR REPLACE TRIGGER tr_feedback_product_rating
    AFTER INSERT
    ON feedback
    FOR EACH ROW
EXECUTE PROCEDURE fn_auto_calculate_product_avg_rating();


CREATE OR REPLACE FUNCTION fn_auto_calculate_product_avg_rating()
    RETURNS TRIGGER
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

CREATE OR REPLACE FUNCTION fn_get_product_brief_from_feedback_id(feedback_id_ BIGINT)
    RETURNS TABLE
            (
                PRODUCT_ID   BIGINT,
                PRODUCT_TYPE TEXT
            )
    LANGUAGE 'plpgsql'

AS
$body$
BEGIN

    RETURN QUERY SELECT CASE
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
$body$;

SELECT *
FROM fn_get_product_brief_from_feedback_id(1);


SELECT feedback.id,
       feedback.rating,
       customer_order_item.type,
       customer_order_item.accessory_id,
       customer_order_item.sub_bird_id,
       sub_bird.bird_id,
       customer_order_item.sub_food_id,
       sub_food.food_id,
       customer_order_item.sub_cage_id,
       sub_cage.cage_id

FROM feedback
         INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
         INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
         LEFT JOIN accessory ON accessory_id = accessory.id
         LEFT JOIN sub_bird ON sub_bird_id = sub_bird.id
         LEFT JOIN sub_food ON sub_food_id = sub_food.id
         LEFT JOIN sub_cage ON sub_cage_id = sub_cage.id;

SELECT feedback.rating,
       customer_order_item.type,
       customer_order_item.accessory_id,
       customer_order_item.sub_bird_id,
       sub_bird.bird_id,
       customer_order_item.sub_food_id,
       sub_food.food_id,
       customer_order_item.sub_cage_id,
       sub_cage.cage_id,
       feedback.id,
       feedback.content,
       customer_order_item.id,
       customer_order_item.type,
       customer_order.id,
       customer_order.customer_id,
       customer_order.shop_id,
       customer_order.status
FROM feedback
         INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
         INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
         LEFT JOIN accessory ON accessory_id = accessory.id
         LEFT JOIN sub_bird ON sub_bird_id = sub_bird.id
         LEFT JOIN sub_food ON sub_food_id = sub_food.id
         LEFT JOIN sub_cage ON sub_cage_id = sub_cage.id
;


CREATE OR REPLACE FUNCTION fn_avg_product_feedback_rating_by_product_id_and_type(product_id_ BIGINT, product_type_ TEXT)
    RETURNS DOUBLE PRECISION
    LANGUAGE 'plpgsql'
AS
$body$
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
$body$;

SELECT fn_avg_product_feedback_rating_by_product_id_and_type(4, 'BIRD');