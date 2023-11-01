create table account
(
    id          bigserial
        primary key,
    username    text                                            not null
        constraint uq_account_username
            unique,
    first_name  text                                            not null,
    last_name   text                                            not null,
    role        text                                            not null
        constraint chk_account_role
            check (role = ANY (ARRAY ['ADMIN'::text, 'CUSTOMER'::text, 'SHOP'::text, 'DELIVERER'::text])),
    phone       text                                            not null,
    email       text                                            not null,
    description text,
    status      text                     default 'ACTIVE'::text not null
        constraint chk_account_status
            check (status = ANY (ARRAY ['ACTIVE'::text, 'DELETED'::text, 'BANNED'::text])),
    created_at  timestamp with time zone default CURRENT_TIMESTAMP,
    deleted_at  timestamp with time zone,
    updated_at  timestamp with time zone,
    created_by  bigint
        constraint fk_account_created_by
            references account,
    deleted_by  bigint
        constraint fk_account_deleted_by
            references account,
    updated_by  bigint
        constraint fk_account_updated_by
            references account,
    password    text                                            not null,
    banned_at   timestamp with time zone,
    banned_by   bigint
        constraint fk_account_banned_by
            references account,
    birthday    date
);

comment on column account.status is 'ACTIVE, DELETED, BANNED';

alter table account
    owner to btp;

create trigger tr_update_account_status_timestamp
    before update
        of status
    on account
    for each row
execute procedure update_status_timestamp();

create trigger tr_update_account_updated_at_timestamp
    before update
    on account
    for each row
execute procedure update_updated_at_timestamp();

create table bird_type
(
    id          bigint default nextval('bird_species_id_seq'::regclass) not null
        constraint bird_species_pkey
            primary key,
    name        text                                                    not null
        constraint uq_bird_species_name
            unique,
    description text
);

alter table bird_type
    owner to btp;

create table province
(
    code         varchar(20)  not null
        constraint provinces_pkey
            primary key,
    name         varchar(255) not null,
    name_en      varchar(255),
    full_name    varchar(255) not null,
    full_name_en varchar(255),
    code_name    varchar(255)
);

alter table province
    owner to btp;

create table district
(
    code          varchar(20)  not null
        constraint districts_pkey
            primary key,
    name          varchar(255) not null,
    name_en       varchar(255),
    full_name     varchar(255),
    full_name_en  varchar(255),
    code_name     varchar(255),
    province_code varchar(20)
        constraint fk_districts_province
            references province,
    latitude      numeric,
    longitude     numeric
);

alter table district
    owner to btp;

create index idx_districts_province
    on district (province_code);

create table ward
(
    code          varchar(20)  not null
        constraint wards_pkey
            primary key,
    name          varchar(255) not null,
    name_en       varchar(255),
    full_name     varchar(255),
    full_name_en  varchar(255),
    code_name     varchar(255),
    district_code varchar(20)
        constraint fk_wards_district_code
            references district
);

alter table ward
    owner to btp;

create table address
(
    id          bigserial
        primary key,
    description text                  not null,
    account_id  bigint                not null
        constraint fk_address_account
            references account,
    is_default  boolean default false not null,
    ward_code   varchar(20)           not null
        constraint fk_address_ward
            references ward
);

alter table address
    owner to btp;

create table customer_order
(
    id                         bigserial
        primary key,
    customer_id                bigint            not null
        constraint fk_customer_order_customer
            references account,
    shop_id                    bigint            not null
        constraint fk_customer_order_shop
            references account,
    description                text,
    total_price                numeric default 0 not null,
    final_price                numeric default 0 not null,
    status                     text    default 'PENDING'::text,
    is_paid                    boolean,
    cancelled_at               timestamp with time zone,
    confirmed_at               timestamp with time zone,
    started_delivery_at        timestamp with time zone,
    finished_delivery_at       timestamp with time zone,
    customer_reported_at       timestamp with time zone,
    customer_report_decided_at timestamp with time zone,
    started_delivery_back_at   timestamp with time zone,
    finished_delivery_back_at  timestamp with time zone,
    shop_reported_at           timestamp with time zone,
    shop_report_decided_at     timestamp with time zone,
    customer_refunded_at       timestamp with time zone,
    shop_refunded_at           timestamp with time zone,
    completed_at               timestamp with time zone,
    delivery_price             numeric,
    address_from_id            bigint            not null
        constraint fk_customer_order_address_from
            references address,
    address_to_id              bigint            not null
        constraint fk_customer_order_address_to
            references address
);

alter table customer_order
    owner to btp;

create index idx_wards_district
    on ward (district_code);

create table product
(
    id          bigserial
        primary key,
    name        text                                            not null,
    description text                                            not null,
    type        text                                            not null,
    status      text                     default 'HIDDEN'::text not null,
    created_at  timestamp with time zone default CURRENT_TIMESTAMP,
    updated_at  timestamp with time zone,
    deleted_at  timestamp with time zone,
    created_by  bigint
        constraint fk_product_created_by
            references account,
    updated_by  bigint
        constraint fk_product_updated_by
            references account,
    deleted_by  bigint
        constraint fk_product_deleted_by
            references account,
    shop_id     bigint                                          not null
        constraint fk_product_account
            references account
);

alter table product
    owner to btp;

create table cage_feature
(
    id            bigserial
        primary key,
    shop_id       bigint             not null
        constraint fk_cage_feature_shop
            references account,
    type          text               not null,
    name          text               not null,
    description   text,
    picket_amount smallint default 0 not null
        constraint chk_cage_feature_picket
            check (picket_amount > '-1'::integer)
);

alter table cage_feature
    owner to btp;

create table cage
(
    id           bigserial
        primary key,
    product_id   bigint not null
        constraint fk_cage_product
            references product,
    bird_type_id bigint not null
        constraint fk_cage_bird_type
            references bird_type,
    name         text   not null,
    description  text   not null
);

alter table cage
    owner to btp;

create table sub_cage
(
    id            bigserial
        primary key,
    cage_id       bigint             not null
        constraint fk_sub_cage_cage
            references cage,
    picket_num_id bigint             not null
        constraint fk_sub_cage_picket_num
            references cage_feature,
    material_id   bigint             not null
        constraint fk_sub_cage_material
            references cage_feature,
    vignette_id   bigint             not null
        constraint fk_sub_cage_vignette
            references cage_feature,
    shape_id      bigint             not null
        constraint fk_sub_cage_shape
            references cage_feature,
    description   text               not null,
    quantity      smallint default 1 not null
        constraint chk_sub_cage_quantity
            check (quantity > '-1'::integer),
    price         numeric  default 0 not null
        constraint chk_sub_cage_price
            check (price >= (0)::numeric)
);

alter table sub_cage
    owner to btp;

create table bird_origin
(
    id          bigserial
        primary key,
    name        text not null
        constraint uq_bird_origin_name
            unique,
    description text
);

alter table bird_origin
    owner to btp;

create table bird
(
    id           bigserial
        primary key,
    product_id   bigint not null
        constraint uq_bird_product_id
            unique
        constraint fk_bird_product
            references product,
    bird_type_id bigint not null
        constraint fk_bird_type
            references bird_type,
    origin_id    bigint not null
        constraint fk_bird_origin
            references bird_origin,
    has_serial   boolean,
    agegroup     text   not null,
    bundle_type  text   not null,
    description  text   not null
);

alter table bird
    owner to btp;

create table sub_bird
(
    id            bigserial
        primary key,
    bird_id       bigint                           not null
        constraint fk_sub_bird_bird
            references bird,
    age           smallint                         not null
        constraint chk_sub_bird_age
            check (age > 0),
    gender        text     default 'UNKNOWN'::text not null,
    domestication text     default 'UNKNOWN'::text not null,
    description   text                             not null,
    mutation      text                             not null,
    color         text                             not null,
    quantity      smallint default 1               not null
        constraint chk_sub_bird_quantity
            check (quantity > '-1'::integer),
    price         numeric  default 0               not null
        constraint chk_sub_bird_price
            check (price > ('-1'::integer)::numeric)
);

alter table sub_bird
    owner to btp;

create table accessory
(
    id          bigserial
        primary key,
    product_id  bigint             not null
        constraint accessory_product
            references product,
    name        text               not null,
    quantity    smallint default 1 not null,
    price       numeric  default 0 not null,
    description text
);

alter table accessory
    owner to btp;

create table food_specialty
(
    id          bigserial
        primary key,
    name        text not null
        constraint uq_food_specialty_name
            unique,
    description text
);

alter table food_specialty
    owner to btp;

create table food
(
    id           bigserial
        primary key,
    product_id   bigint not null
        constraint uq_food_product_id
            unique
        constraint fk_food_product
            references product,
    bird_type_id bigint not null
        constraint fk_food_bird_type
            references bird_type,
    type         text   not null
        constraint chk_food_type
            check (type = ANY
                   (ARRAY ['NUTS'::text, 'FRUIT'::text, 'VEGETABLE'::text, 'NATURAL'::text, 'ARTIFICIAL'::text, 'VITAMIN'::text, 'MEDICINE'::text])),
    description  text   not null
);

alter table food
    owner to btp;

create table sub_food
(
    id       bigserial
        primary key,
    food_id  bigint             not null
        constraint fk_sub_food_food
            references food,
    quantity smallint default 1 not null
        constraint chk_sub_bird_quantity
            check (quantity > '-1'::integer),
    price    numeric  default 0 not null
        constraint chk_sub_bird_price
            check (price > ('-1'::integer)::numeric),
    agegroup text
);

alter table sub_food
    owner to btp;

create table sub_food_has_specialty
(
    id                bigserial
        primary key,
    sub_food_id       bigint not null
        constraint fk_sub_food_has_specialty_sub_food
            references sub_food,
    food_specialty_id bigint not null
        constraint fk_sub_food_has_specialty_food_specialty
            references food_specialty,
    constraint uq_sub_food_has_specialty_sub_food_specialty
        unique (sub_food_id, food_specialty_id)
);

alter table sub_food_has_specialty
    owner to btp;

create table product_suggestion
(
    id                   bigserial
        primary key,
    product_id           bigint not null
        constraint fk_product_suggestion_product
            references product,
    suggested_product_id bigint not null
        constraint fk_product_suggestion_suggested_product
            references product,
    constraint chk_product_suggestion_loop
        check (product_id <> suggested_product_id)
);

alter table product_suggestion
    owner to btp;

create table notification
(
    id         bigserial
        primary key,
    account_id bigint                                             not null
        constraint fk_notification_account
            references account,
    content    text                                               not null,
    is_read    boolean,
    created_at timestamp with time zone default CURRENT_TIMESTAMP not null,
    read_at    timestamp with time zone
);

alter table notification
    owner to btp;

create table feedback
(
    id                 bigserial
        primary key,
    customer_id        bigint   not null
        constraint fk_feedback_account
            references account,
    product_id         bigint   not null
        constraint fk_feedback_product
            references product,
    content            text     not null,
    shop_reply_content text,
    rating             smallint not null,
    created_at         timestamp with time zone default CURRENT_TIMESTAMP
);

alter table feedback
    owner to btp;

create table report
(
    id                           bigserial
        primary key,
    order_id                     bigint                                             not null
        constraint fk_order_report_customer_order
            references customer_order,
    name                         text                                               not null,
    description                  text                                               not null,
    judge_statement              text,
    is_valid                     boolean,
    created_at                   timestamp with time zone default CURRENT_TIMESTAMP not null,
    last_replied_by_accuser_at   timestamp with time zone,
    last_replied_by_defendant_at timestamp with time zone,
    decided_at                   timestamp with time zone                           not null
);

alter table report
    owner to btp;

create table report_reply
(
    id         bigserial
        primary key,
    report_id  bigint not null
        constraint fk_report_reply_order_report
            references report,
    account_id bigint not null
        constraint fk_report_reply_account
            references account,
    content    text   not null,
    created_at timestamp with time zone default CURRENT_TIMESTAMP
);

alter table report_reply
    owner to btp;

create table delivery
(
    id           bigserial
        primary key,
    deliverer_id bigint                                              not null
        constraint fk_delivery_account
            references account,
    order_id     bigint                                              not null
        constraint fk_delivery_order
            references customer_order,
    type         text                                                not null,
    status       text                     default 'DELIVERING'::text not null,
    started_at   timestamp with time zone default CURRENT_TIMESTAMP  not null,
    completed_at timestamp with time zone
);

alter table delivery
    owner to btp;

create table customer_order_item
(
    id          bigserial
        primary key,
    order_id    bigint             not null
        constraint fk_order_item_customer_order
            references customer_order,
    product_id  bigint             not null
        constraint fk_order_item_product
            references product,
    sub_cage_id bigint
        constraint fk_customer_order_item_sub_cage
            references sub_cage,
    sub_food_id bigint
        constraint fk_customer_order_item_sub_food
            references sub_food,
    quantity    smallint default 1 not null
);

alter table customer_order_item
    owner to btp;

create table payment
(
    id            bigserial
        primary key,
    to_account_id bigint
        constraint fk_payment_to_account
            references account,
    by_account_id bigint                                             not null
        constraint fk_payment_by_account
            references account,
    on_order      bigint
        constraint fk_payment_on_order
            references customer_order,
    description   text,
    total         numeric                                            not null,
    status        text                     default 'PENDING'::text   not null,
    created_at    timestamp with time zone default CURRENT_TIMESTAMP not null,
    completed_at  timestamp with time zone,
    failed_at     timestamp with time zone,
    type          text                                               not null
);

alter table payment
    owner to btp;

create table voucher
(
    id                   bigserial
        primary key,
    created_by           bigint
        constraint fk_voucher_created_by
            references account,
    code                 text                                               not null,
    is_delivery_voucher  boolean,
    is_percent           boolean,
    valid_from           timestamp with time zone                           not null,
    valid_until          timestamp with time zone                           not null,
    min_order_value      numeric                  default 0                 not null
        constraint chk_voucher_min_order_value
            check (min_order_value >= (0)::numeric),
    percent_discount     double precision         default 0
        constraint chk_voucher_percent_discount
            check ((percent_discount >= (0)::double precision) AND (percent_discount < (1)::double precision)),
    max_discounted_value numeric
        constraint chk_voucher_max_discounted_value
            check (max_discounted_value >= (0)::numeric),
    value_discount       numeric                  default 0,
    quantity             smallint                                           not null
        constraint chk_voucher_available_item_count
            check (quantity > 0),
    is_deleted           boolean,
    created_at           timestamp with time zone default CURRENT_TIMESTAMP not null,
    deleted_at           timestamp with time zone,
    constraint chk_voucher_value_discount
        check ((value_discount >= (0)::numeric) AND (value_discount <= min_order_value))
);

alter table voucher
    owner to btp;

create table voucher_item
(
    id                bigserial
        primary key,
    voucher_id        bigint not null
        constraint fk_voucher_item_voucher
            references voucher,
    is_used           boolean,
    used_at           timestamp with time zone,
    customer_order_id bigint
        constraint fk_voucher_item_customer_order
            references customer_order
);

alter table voucher_item
    owner to btp;

create table incurred_cost
(
    id          bigserial
        primary key,
    order_id    bigint            not null
        constraint fk_incurred_cost_order
            references customer_order,
    name        text              not null,
    value       numeric default 0 not null
        constraint chk_incurred_cost_value
            check (value >= (0)::numeric),
    description text
);

alter table incurred_cost
    owner to btp;

create table bird_document
(
    id          bigserial
        primary key,
    name        text   not null,
    sub_bird_id bigint not null
        constraint fk_bird_document_sub_bird
            references sub_bird
);

alter table bird_document
    owner to btp;

create table distance_type
(
    id            bigserial
        primary key,
    name          text not null
        constraint uq_distance_type_name
            unique,
    distance_from numeric,
    distance_to   numeric
);

alter table distance_type
    owner to btp;

create table package_delivery_tariff
(
    id               bigint  default nextval('package_delivery_tariff_id_seq1'::regclass) not null
        primary key,
    type             text                                                                 not null,
    weight_from      integer default 1                                                    not null,
    weight_to        integer default 1                                                    not null,
    distance_type_id bigint                                                               not null
        constraint fk_package_delivery_tariff_distance_type
            references distance_type,
    value            numeric default 0                                                    not null
        constraint chk_package_delivery_tariff_value
            check (value >= (0)::numeric),
    constraint chk_package_delivery_tariff_weight
        check ((weight_from > '-1'::integer) AND (weight_to > 0) AND (weight_from < 1000000) AND
               (weight_to < 1000000) AND (weight_from < weight_to))
);

alter table package_delivery_tariff
    owner to btp;

