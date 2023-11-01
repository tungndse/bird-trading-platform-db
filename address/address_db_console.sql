CREATE TABLE address
(
    id          BIGSERIAL PRIMARY KEY,
    account_id  BIGINT      NOT NULL,

    is_default  BOOLEAN,
    description TEXT        NOT NULL,

    province_id VARCHAR(20) NOT NULL,
    district_id VARCHAR(20) NOT NULL,
    ward_id     VARCHAR(20) NULL,

    CONSTRAINT fk_address_account FOREIGN KEY (account_id) REFERENCES account,
    CONSTRAINT fk_address_ward FOREIGN KEY (ward_id) REFERENCES ward,
    CONSTRAINT fk_address_district FOREIGN KEY (district_id) REFERENCES district,
    CONSTRAINT fk_address_province FOREIGN KEY (province_id) REFERENCES province
);

