DROP DATABASE IF EXISTS greenspot_grocer;
CREATE DATABASE greenspot_grocer;

USE greenspot_grocer;


CREATE TABLE unit_t (
    unit_id INT NOT NULL,
    unit_name VARCHAR(25) NOT NULL,
    CONSTRAINT Unit_PK PRIMARY KEY (unit_id)
);

CREATE TABLE item_type_t (
    item_type_id INT NOT NULL,
    item_type_name VARCHAR(25) NOT NULL,
    CONSTRAINT Item_Type_PK PRIMARY KEY (item_type_id)
);

CREATE TABLE customer_t (
    customer_id INT NOT NULL,
    CONSTRAINT Customer_PK PRIMARY KEY (customer_id)
);

CREATE TABLE location_t (
    location_name VARCHAR(10) NOT NULL,
    CONSTRAINT Location_PK PRIMARY KEY (location_name)
);

CREATE TABLE product_t (
    product_item_id INT NOT NULL,
    product_description VARCHAR(100),
    item_type_id INT NOT NULL,
    unit_id INT NOT NULL,
    CONSTRAINT Product_PK PRIMARY KEY (product_item_id),
    CONSTRAINT Product_FK1 FOREIGN KEY (item_type_id) REFERENCES item_type_t (item_type_id),
    CONSTRAINT Product_FK2 FOREIGN KEY (unit_id) REFERENCES unit_t (unit_id)
);

CREATE TABLE vendor_t (
    vendor_id   INT NOT NULL,
    vendor_name VARCHAR(50) NOT NULL,
    vendor_street VARCHAR(50),
    vendor_city VARCHAR(50),
    vendor_state CHAR(2),
    vendor_zipcode VARCHAR(10),
    CONSTRAINT Vendor_PK PRIMARY KEY (vendor_id)
);


CREATE TABLE inventory_t (
    inventory_id INT NOT NULL,
    product_item_id INT NOT NULL, 
    location_name VARCHAR(25) NOT NULL,
    CONSTRAINT Inventory_PK PRIMARY KEY (inventory_id),
    CONSTRAINT Inventory_FK1 FOREIGN KEY (product_item_id) REFERENCES product_t (product_item_id),
    CONSTRAINT Inventory_FK2 FOREIGN KEY (location_name) REFERENCES location_t (location_name)
);

CREATE TABLE inventory_transaction_t (
    transaction_id INT NOT NULL,
    inventory_id INT NOT NULL,
    transaction_date DATE,
    transaction_type ENUM('PURCHASE','SALE') NOT NULL,
    stock_quantity INT,
    quantity_changed INT,
    CONSTRAINT Inventory_Transaction_PK PRIMARY KEY (transaction_id),
    CONSTRAINT Inventory_Transaction_FK1 FOREIGN KEY (inventory_id) REFERENCES inventory_t (inventory_id)
);

CREATE TABLE purchase_t (
    purchase_id INT NOT NULL,
    product_item_id INT NOT NULL,
    vendor_id INT NOT NULL,
    transaction_id INT NOT NULL,
    wholesale_cost DECIMAL(6,2),
    CONSTRAINT Purchase_PK PRIMARY KEY (purchase_id),
    CONSTRAINT Purchase_FK1 FOREIGN KEY (product_item_id) REFERENCES product_t (product_item_id),
    CONSTRAINT Purchase_FK2 FOREIGN KEY (vendor_id) REFERENCES vendor_t (vendor_id),
    CONSTRAINT Purchase_FK3 FOREIGN KEY (transaction_id) REFERENCES inventory_transaction_t (transaction_id)
);

CREATE TABLE sale_transaction_t (
    sale_id INT NOT NULL,
    product_item_id INT NOT NULL,
    customer_id INT NOT NULL,
    transaction_id INT NOT NULL,
    sale_price DECIMAL(6,2),
    CONSTRAINT Sale_Transaction_PK PRIMARY KEY (sale_id),
    CONSTRAINT Sale_Transaction_FK1 FOREIGN KEY (product_item_id) REFERENCES product_t (product_item_id),
    CONSTRAINT Sale_Transaction_FK2 FOREIGN KEY (customer_id) REFERENCES customer_t (customer_id),
    CONSTRAINT Sale_Transaction_FK3 FOREIGN KEY (transaction_id) REFERENCES inventory_transaction_t (transaction_id)
);
