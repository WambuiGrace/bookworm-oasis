--Create the database bookworm_oasisdb
CREATE DATABASE bookworm_oasisdb
    DEFAULT CHARACTER SET = 'utf8mb4';


--Create tables in the bookworm_oasisdb database
-- 1. author
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    names VARCHAR(100),
    bio TEXT
);

-- 2. book_language
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100),
    language_code VARCHAR(10)
);

-- 3. publisher
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    address_id INT
);

-- 4. book
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    book_image BLOB,
    price DECIMAL(10,2),
    description TEXT,
    publisher_id INT,
    language_id INT
);

-- 5. book_author (many-to-many)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- 6. country
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100),
    country_code VARCHAR(10)
);

-- 7. address
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    county VARCHAR(100),
    city_town VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT
);

-- 8. address_status
CREATE TABLE address_status (
    address_status_id INT AUTO_INCREMENT PRIMARY KEY,
    address_status VARCHAR(100)
);

-- 9. customer
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    password VARCHAR(255)
);

-- 10. customer_address
CREATE TABLE customer_address (
    customer_address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    address_id INT,
    address_status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

-- 11. shipping_method
CREATE TABLE shipping_method (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100),
    cost DECIMAL(10,2)
);

-- 12. order_status
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    order_status VARCHAR(100)
);

-- 13. order_history
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    date DATETIME,
    notes TEXT,
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- 14. customer_order
CREATE TABLE customer_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME,
    method_id INT,
    order_status VARCHAR(100),
    total_amount DECIMAL(10,2),
    history_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (method_id) REFERENCES shipping_method(method_id),
    FOREIGN KEY (history_id) REFERENCES order_history(history_id)
);

-- 15. order_line
CREATE TABLE order_line (
    orderline_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES customer_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- book table foreign keys
ALTER TABLE book
ADD CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
ADD CONSTRAINT fk_book_language FOREIGN KEY (language_id) REFERENCES book_language(language_id);

-- publisher table foreign key
ALTER TABLE publisher
ADD CONSTRAINT fk_publisher_address FOREIGN KEY (address_id) REFERENCES address(address_id);

-- address table foreign key
ALTER TABLE address
ADD CONSTRAINT fk_address_country FOREIGN KEY (country_id) REFERENCES country(country_id);

-- order_history table foreign keys
ALTER TABLE order_history
ADD CONSTRAINT fk_order_history_order FOREIGN KEY (order_id) REFERENCES customer_order(order_id);