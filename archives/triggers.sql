-------** TRIGGERS & FUNCTIONS **--------------------------------------------------------------

------------- TRIGGERS ----------------------
CREATE OR REPLACE TRIGGER TR_account_updated_at
    BEFORE UPDATE
    ON account
    FOR EACH ROW
EXECUTE PROCEDURE sp_save_updated_at();

CREATE OR REPLACE TRIGGER TR_account_deleted_at
    BEFORE UPDATE of is_deleted
    ON account
    FOR EACH ROW
EXECUTE PROCEDURE sp_save_deleted_at();

CREATE OR REPLACE TRIGGER TR_product_updated_at
    BEFORE UPDATE
    ON product
EXECUTE PROCEDURE sp_save_updated_at();

CREATE OR REPLACE TRIGGER TR_product_deleted_at
    BEFORE UPDATE OF is_deleted
    ON product
EXECUTE PROCEDURE sp_save_deleted_at();

CREATE OR REPLACE TRIGGER TR_product_cage_updated_at
    AFTER UPDATE
    ON cage
    REFERENCING OLD TABLE AS old_table
EXECUTE PROCEDURE sp_save_updated_at_for_referenced();

CREATE OR REPLACE TRIGGER TR_product_bird_updated_at
    AFTER UPDATE
    ON bird
    REFERENCING OLD TABLE AS old_table
EXECUTE PROCEDURE sp_save_updated_at_for_referenced();

CREATE OR REPLACE TRIGGER TR_product_food_updated_at
    AFTER UPDATE
    ON food
    REFERENCING OLD TABLE AS old_table
EXECUTE PROCEDURE sp_save_updated_at_for_referenced();

CREATE OR REPLACE TRIGGER TR_notification_read_at
    AFTER UPDATE OF is_read
    ON notification
    FOR EACH ROW
EXECUTE PROCEDURE sp_save_read_at();

CREATE OR REPLACE TRIGGER TR_message_read_at
    AFTER UPDATE OF is_read
    ON message
    FOR EACH ROW
EXECUTE PROCEDURE sp_save_read_at();


