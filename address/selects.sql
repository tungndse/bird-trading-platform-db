SELECT *
FROM ward w
         INNER JOIN public.district d ON d.code = w.district_code
         INNER JOIN public.province p ON p.code = d.province_code
WHERE p.name = 'Hồ Chí Minh';

SELECT w.full_name, d.full_name, p.full_name, CONCAT(w.full_name, ', ', d.full_name, ', ', p.full_name) AS abc
FROM ward w
         INNER JOIN public.district d ON d.code = w.district_code
         INNER JOIN public.province p ON p.code = d.province_code
WHERE w.code = '19348';
--78/32/11 Tôn Thất Thuyết, Phường 16, Quận 4, Thành phố Hồ Chí Minh 70000, Vietnam

CREATE TABLE bird
(
    id           BIGSERIAL
        PRIMARY KEY,
    bird_type_id BIGINT                                          NOT NULL
        CONSTRAINT fk_bird_type
            REFERENCES bird_type,
    origin_id    BIGINT                                          NOT NULL
        CONSTRAINT fk_bird_origin
            REFERENCES bird_origin,
    has_serial   BOOLEAN                                         NOT NULL,
    agegroup     TEXT                                            NOT NULL,
    bundle_type  TEXT                                            NOT NULL,
    description  TEXT                                            NOT NULL,
    name         TEXT                                            NOT NULL,
    status       TEXT                     DEFAULT 'HIDDEN'::TEXT NOT NULL,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP WITH TIME ZONE,
    deleted_at   TIMESTAMP WITH TIME ZONE,
    shop_id      BIGINT                                          NOT NULL
        CONSTRAINT fk_bird_account
            REFERENCES account,
    banned_by    BIGINT
        CONSTRAINT fk_bird_banned_by_account
            REFERENCES account,
    banned_at    TIMESTAMP WITH TIME ZONE,
    created_by   BIGINT
        CONSTRAINT fk_bird_shop_created_by
            REFERENCES account,
    deleted_by   BIGINT
        CONSTRAINT fk_bird_shop_deleted_by
            REFERENCES account,
    updated_by   BIGINT
        CONSTRAINT fk_bird_shop_updated_by
            REFERENCES account
);

CREATE TABLE sub_bird
(
    id              BIGSERIAL
        PRIMARY KEY,
    bird_id         BIGINT            NOT NULL
        CONSTRAINT fk_sub_bird_bird
            REFERENCES bird,
    age             SMALLINT          NOT NULL CONSTRAINT chk_sub_bird_age
        CHECK (age > 0),
    description     TEXT,
    mutation        TEXT,
    color           TEXT,
    quantity        INTEGER DEFAULT 1 NOT NULL
        CONSTRAINT chk_sub_bird_quantity
            CHECK (quantity > '-1'::INTEGER),
    price           NUMERIC DEFAULT 0 NOT NULL
        CONSTRAINT chk_sub_bird_price
            CHECK (price > ('-1'::INTEGER)::NUMERIC),
    is_domesticated BOOLEAN,
    is_male         BOOLEAN,
    sold_quantity   INTEGER DEFAULT 0 NOT NULL
);

-- bird 001
-- sub_bird 001
-- sub_bird 002


SELECT 71755000 + 969000 - 1000000;

SELECT CURRENT_TIMESTAMP;

SELECT w.code, w.full_name, d.full_name, p.full_name, CONCAT(w.full_name, ', ', d.full_name, ', ', p.full_name) AS abc
FROM ward w
         INNER JOIN public.district d ON d.code = w.district_code
         INNER JOIN public.province p ON p.code = d.province_code
WHERE w.code = '27289'
--WHERE w.full_name LIKE '%Phường 14%'
;