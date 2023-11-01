ALTER TABLE voucher_item
    RENAME is_used
        TO status;

ALTER TABLE voucher_item
    ALTER COLUMN status TYPE TEXT; --using is_used::text

ALTER TABLE voucher_item
    ALTER COLUMN status SET NOT NULL;

ALTER TABLE voucher_item
ALTER column status set DEFAULT 'PENDING';