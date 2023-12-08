SELECT COUNT(customer_order.customer_id)
FROM feedback
         INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
         INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
WHERE customer_id = 3;
;

CREATE OR REPLACE TRIGGER tr_feedback_count_for_account
    AFTER INSERT
    ON feedback
    FOR EACH ROW
EXECUTE PROCEDURE fn_auto_update_feedback_count();

CREATE OR REPLACE FUNCTION fn_auto_update_feedback_count()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_count_  BIGINT;
    account_id_ BIGINT;
BEGIN

    SELECT COUNT(customer_order.customer_id)
    INTO new_count_
    FROM feedback
             INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
             INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
    WHERE customer_id = 3;

    SELECT customer_id
    INTO account_id_
    FROM feedback
             INNER JOIN customer_order_item ON feedback.customer_order_item_id = customer_order_item.id
             INNER JOIN customer_order ON customer_order_item.order_id = customer_order.id
    WHERE feedback.id = new.id;

    update account SET feedback_count = new_count_ WHERE account.id = account_id_;

    RETURN new;
END;
$$;