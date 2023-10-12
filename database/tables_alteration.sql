alter table product
    add column packed_width SMALLINT DEFAULT 1 NOT NULL;
alter table product
    add column packed_length SMALLINT DEFAULT 1 NOT NULL;
alter table product
    add column packed_height SMALLINT DEFAULT 1 NOT NULL;
alter table product
    add column packed_weight SMALLINT DEFAULT 1 NOT NULL;

alter table product
    add CONSTRAINT chk_product_width CHECK ( packed_width > 0 AND packed_width < 10000000 );
alter table product
    add CONSTRAINT chk_product_length CHECK ( packed_length > 0 AND packed_length < 10000000 );
alter table product
    add CONSTRAINT chk_product_height CHECK ( packed_height > 0 AND packed_height < 10000000 );
alter table product
    add CONSTRAINT chk_product_weight CHECK ( packed_weight > 0 AND packed_weight < 10000000 );