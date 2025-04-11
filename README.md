# Bookworm Oasis Database

## Project Overview

The **Bookworm Oasis Database** is a relational database designed to manage the operations of a bookstore. It stores information about books, authors, customers, orders, shipping methods, and more. The database is implemented in MySQL and supports efficient data storage, retrieval, and analysis.

---

## Features

- **Books and Authors**: Tracks books, their authors, and the many-to-many relationship between them.
- **Customers and Orders**: Manages customer information, their addresses, and orders.
- **Shipping and Order History**: Tracks shipping methods, order statuses, and order history.
- **Localization**: Supports multiple languages for books and countries for addresses.

---

## ERD Diagram

![ERD Diagram](bookstore-oasis.svg)

---

## Database Schema

The database consists of the following tables:

1. **author**: Stores information about authors.
2. **book_language**: Stores possible languages for books.
3. **publisher**: Stores publisher details.
4. **book**: Stores book details, including price, description, and foreign keys to `publisher` and `book_language`.
5. **book_author**: Manages the many-to-many relationship between books and authors.
6. **country**: Stores country information for addresses.
7. **address**: Stores customer and publisher addresses.
8. **address_status**: Tracks the status of addresses (e.g., current, old).
9. **customer**: Stores customer information.
10. **customer_address**: Links customers to their addresses and address statuses.
11. **shipping_method**: Stores available shipping methods and their costs.
12. **order_status**: Tracks possible statuses for orders (e.g., pending, shipped, delivered).
13. **order_history**: Tracks the history of orders, including status changes.
14. **customer_order**: Stores customer orders, including total amounts and shipping methods.
15. **order_line**: Tracks the books included in each order.

---

## Setup Instructions

1. **Create the Database**:
   ```sql
   CREATE DATABASE bookworm_oasisdb DEFAULT CHARACTER SET = 'utf8mb4';

## Sample Data
The database includes sample data for testing:
1. Books: Four books with varying prices and descriptions.
2. Authors: Three authors with bios.
3. Customers: Three customers with contact details.
4. Orders: Three customer orders with different statuses and shipping methods.

## Test Queries
The database includes test queries for testing
1. Retrieve books by price using **WHERE**
2. Retrieve customer names and their order dates using **JOIN**