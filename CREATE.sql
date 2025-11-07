CREATE TABLE brand (
    id_brand NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL
);

CREATE TABLE model (
    id_model NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    id_brand NUMBER NOT NULL,
    CONSTRAINT fk_model_brand FOREIGN KEY (id_brand) REFERENCES brand(id_brand)
);

CREATE TABLE category (
    id_category NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL
);

CREATE TABLE body_type (
    id_body_type NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL
);

CREATE TABLE unit (
    id_unit NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    abbreviation VARCHAR2(10) NOT NULL
);

CREATE TABLE part_category (
    id_part_category NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL
);

-- Владельцы
CREATE TABLE owner (
    id_owner NUMBER PRIMARY KEY,
    surname VARCHAR2(50) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    patronymic VARCHAR2(50),
    phone VARCHAR2(20) NOT NULL
);

-- Автомобили
CREATE TABLE car (
    id_car NUMBER PRIMARY KEY,
    license_plate VARCHAR2(15) UNIQUE NOT NULL,
    year NUMBER(4) NOT NULL,
    id_brand NUMBER NOT NULL,
    id_model NUMBER NOT NULL,
    id_category NUMBER NOT NULL,
    id_body_type NUMBER NOT NULL,
    id_owner NUMBER NOT NULL,
    CONSTRAINT fk_car_brand FOREIGN KEY (id_brand) REFERENCES brand(id_brand),
    CONSTRAINT fk_car_model FOREIGN KEY (id_model) REFERENCES model(id_model),
    CONSTRAINT fk_car_category FOREIGN KEY (id_category) REFERENCES category(id_category),
    CONSTRAINT fk_car_body_type FOREIGN KEY (id_body_type) REFERENCES body_type(id_body_type),
    CONSTRAINT fk_car_owner FOREIGN KEY (id_owner) REFERENCES owner(id_owner)
);

-- Мастера
CREATE TABLE master (
    id_master NUMBER PRIMARY KEY,
    surname VARCHAR2(50) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    patronymic VARCHAR2(50),
    phone VARCHAR2(20),
    birth_date DATE NOT NULL,
    specialization VARCHAR2(100),
    experience_years NUMBER NOT NULL,
    rate_share NUMBER(3,2) NOT NULL -- доля ставки (0.00 - 1.00)
);

-- Запчасти
CREATE TABLE part (
    id_part NUMBER PRIMARY KEY,
    code VARCHAR2(50) UNIQUE NOT NULL,
    name VARCHAR2(100) NOT NULL,
    id_part_category NUMBER NOT NULL,
    characteristics VARCHAR2(255),
    quantity_in_stock NUMBER DEFAULT 0,
    id_unit NUMBER NOT NULL,
    price NUMBER(10,2) NOT NULL, -- цена за единицу
    CONSTRAINT fk_part_category FOREIGN KEY (id_part_category) REFERENCES part_category(id_part_category),
    CONSTRAINT fk_part_unit FOREIGN KEY (id_unit) REFERENCES unit(id_unit)
);

-- Поставщики
CREATE TABLE supplier (
    id_supplier NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    address VARCHAR2(255) NOT NULL,
    phone VARCHAR2(50),
    manager_surname VARCHAR2(50),
    manager_name VARCHAR2(50),
    manager_patronymic VARCHAR2(50)
);

-- Заказы запчастей у поставщиков
CREATE TABLE supply_order (
    id_supply_order NUMBER PRIMARY KEY,
    id_supplier NUMBER NOT NULL,
    order_date DATE NOT NULL,
    planned_arrival DATE,
    actual_arrival DATE,
    CONSTRAINT fk_supply_supplier FOREIGN KEY (id_supplier) REFERENCES supplier(id_supplier)
);

CREATE TABLE supply_order_item (
    id_supply_order NUMBER NOT NULL,
    id_part NUMBER NOT NULL,
    quantity NUMBER NOT NULL,
    cost_in_order NUMBER(10,2) NOT NULL, -- общая стоимость позиции
    PRIMARY KEY (id_supply_order, id_part),
    CONSTRAINT fk_supply_order FOREIGN KEY (id_supply_order) REFERENCES supply_order(id_supply_order),
    CONSTRAINT fk_supply_part FOREIGN KEY (id_part) REFERENCES part(id_part)
);

-- Заказы на ремонт
CREATE TABLE repair_order (
    id_repair_order NUMBER PRIMARY KEY,
    id_car NUMBER NOT NULL,
    id_master NUMBER NOT NULL,
    order_date DATE NOT NULL,
    planned_completion DATE NOT NULL,
    actual_completion DATE,
    total_cost NUMBER(12,2) NOT NULL,
    comments VARCHAR2(500),
    CONSTRAINT fk_repair_car FOREIGN KEY (id_car) REFERENCES car(id_car),
    CONSTRAINT fk_repair_master FOREIGN KEY (id_master) REFERENCES master(id_master)
);

-- Неисправности (можно хранить как текст, но для гибкости — отдельная таблица)
CREATE TABLE defect (
    id_defect NUMBER PRIMARY KEY,
    description VARCHAR2(255) NOT NULL
);

CREATE TABLE repair_defect (
    id_repair_order NUMBER NOT NULL,
    id_defect NUMBER NOT NULL,
    PRIMARY KEY (id_repair_order, id_defect),
    CONSTRAINT fk_rd_order FOREIGN KEY (id_repair_order) REFERENCES repair_order(id_repair_order),
    CONSTRAINT fk_rd_defect FOREIGN KEY (id_defect) REFERENCES defect(id_defect)
);

-- Работы
CREATE TABLE work (
    id_work NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL
);

CREATE TABLE repair_work (
    id_repair_order NUMBER NOT NULL,
    id_work NUMBER NOT NULL,
    PRIMARY KEY (id_repair_order, id_work),
    CONSTRAINT fk_rw_order FOREIGN KEY (id_repair_order) REFERENCES repair_order(id_repair_order),
    CONSTRAINT fk_rw_work FOREIGN KEY (id_work) REFERENCES work(id_work)
);

-- Используемые запчасти в ремонте
CREATE TABLE repair_part (
    id_repair_order NUMBER NOT NULL,
    id_part NUMBER NOT NULL,
    quantity NUMBER NOT NULL,
    PRIMARY KEY (id_repair_order, id_part),
    CONSTRAINT fk_rp_order FOREIGN KEY (id_repair_order) REFERENCES repair_order(id_repair_order),
    CONSTRAINT fk_rp_part FOREIGN KEY (id_part) REFERENCES part(id_part)
);