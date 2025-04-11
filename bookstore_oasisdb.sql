-- Create the database bookworm_oasisdb
CREATE DATABASE bookworm_oasisdb
    DEFAULT CHARACTER SET = 'utf8mb4';

-- Add user management privileges to the bookworm_oasisdb database
CREATE USER 'bookstore'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON bookworm_oasisdb.* TO 'bookstore'@'localhost';

-- Create tables in the bookworm_oasisdb database
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


-- Insert sample data into the tables
-- author table 
INSERT INTO author (names, bio) VALUES
('John Doe', 'An acclaimed author known for his thrilling novels.'),
('Jane Smith', 'A bestselling author with a passion for storytelling.'),
('Emily Johnson', 'An award-winning author with a unique writing style.');

-- book table 
INSERT INTO book (title, book_image, price, description, publisher_id, language_id) VALUES
('The Great Adventure', NULL, 25.99, 'An epic tale of adventure and discovery.', 1, 1),
('Mystery of the Lost Island', NULL, 15.50, 'A thrilling mystery set on a remote island.', 2, 2),
('Cooking Made Easy', NULL, 30.00, 'A comprehensive guide to cooking delicious meals.', 3, 1),
('The Art of Programming', NULL, 45.00, 'A deep dive into programming concepts and techniques.', 1, 3);

-- customer table 
INSERT INTO customer (name, email, phone, password) VALUES
('Alice Johnson', 'alice.johnson@example.com', '123-456-7890', 'password123'),
('Bob Smith', 'bob.smith@example.com', '987-654-3210', 'securepassword'),
('Charlie Brown', 'charlie.brown@example.com', '555-555-5555', 'mypassword');

-- customer_order table 
INSERT INTO customer_order (customer_id, order_date, method_id, order_status, total_amount, history_id) VALUES
(1, '2025-04-01 10:30:00', 1, 'Pending', 55.99, NULL),
(2, '2025-04-05 14:45:00', 2, 'Shipped', 30.00, NULL),
(3, '2025-04-08 09:15:00', 1, 'Delivered', 45.00, NULL);

-- shipping_method table
INSERT INTO shipping_method (method_name, cost) VALUES
('Standard Shipping', 5.99),
('Express Shipping', 15.99);

-- book_language table
INSERT INTO book_language (language_name, language_code) VALUES
('English', 'EN'),
('Spanish', 'ES'),
('French', 'FR');

-- publisher table
INSERT INTO publisher (name, email, address_id) VALUES
('Adventure Books', 'contact@adventurebooks.com', NULL),
('Mystery Publishers', 'info@mysterypublishers.com', NULL),
('Cooking World', 'support@cookingworld.com', NULL);


-- Test queries to verify the database structure and data
SELECT * FROM book WHERE price > 20.00;
SELECT customer.name, customer_order.order_date 
FROM customer 
JOIN customer_order ON customer.customer_id = customer_order.customer_id;

-- Retrieve customer orders with a status of 'Delivered'
SELECT customer_order.order_id AS order_id, 
       customer.name AS customer_name, 
       customer_order.order_date AS order_date, 
       customer_order.total_amount AS total_amount
FROM customer_order
JOIN customer ON customer_order.customer_id = customer.customer_id
WHERE customer_order.order_status = 'Delivered';