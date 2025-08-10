CREATE DATABASE IF NOT EXISTS pahanaEdu;
USE pahanaEdu;

-- 1. Author Table
CREATE TABLE IF NOT EXISTS author (
                                      author_id INT AUTO_INCREMENT PRIMARY KEY,
                                      first_name VARCHAR(100) NOT NULL,
                                      last_name VARCHAR(100) NOT NULL,
                                      nic_no VARCHAR(20) UNIQUE NOT NULL, -- Prevent duplicate NICs
                                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Book Table
CREATE TABLE IF NOT EXISTS book (
                                    book_id INT AUTO_INCREMENT PRIMARY KEY,
                                    book_name VARCHAR(150) NOT NULL UNIQUE,
                                    author_id INT,
                                    isbn_no VARCHAR(20) UNIQUE,
                                    price DECIMAL(12, 2) NOT NULL CHECK (price >= 0),
                                    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0),
                                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE SET NULL
);

-- 3. Customer Table
CREATE TABLE IF NOT EXISTS customer (
                                        customer_id INT AUTO_INCREMENT PRIMARY KEY,
                                        first_name VARCHAR(100) NOT NULL,
                                        last_name VARCHAR(100) NOT NULL,
                                        nic_no VARCHAR(20) UNIQUE NOT NULL,
                                        mobile_no VARCHAR(15),
                                        telephone_no VARCHAR(15),
                                        address TEXT,
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bank Account Table
CREATE TABLE IF NOT EXISTS bank_account (
                                            bank_account_id INT AUTO_INCREMENT PRIMARY KEY,
                                            bank_name VARCHAR(100) NOT NULL,
                                            bank_branch VARCHAR(100),
                                            account_number VARCHAR(50) NOT NULL,
                                            customer_id INT NOT NULL,
                                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                            FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
                                            UNIQUE(account_number, bank_name) -- Prevent duplicate accounts per bank
);

-- 5. User Table
CREATE TABLE IF NOT EXISTS user (
                                    user_id INT AUTO_INCREMENT PRIMARY KEY,
                                    customer_id INT,
                                    username VARCHAR(50) NOT NULL UNIQUE,
                                    password VARCHAR(255) NOT NULL,
                                    user_type ENUM('ADMIN', 'STAFF', 'CUSTOMER') NOT NULL DEFAULT 'STAFF',
                                    nic_no VARCHAR(20) UNIQUE NOT NULL,
                                    is_active BOOLEAN DEFAULT TRUE,
                                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- 6. Invoice Header Table
CREATE TABLE IF NOT EXISTS invoice (
                                       invoice_id INT AUTO_INCREMENT PRIMARY KEY,
                                       customer_id INT NOT NULL,
                                       invoice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       discount DECIMAL(5,2) DEFAULT 0.00,
                                       total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
                                       status ENUM('PENDING','PAID','CANCELLED') DEFAULT 'PENDING',
                                       created_by INT,
                                       FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
                                       FOREIGN KEY (created_by) REFERENCES user(user_id) ON DELETE SET NULL
);


-- 7. Invoice Item Table
CREATE TABLE IF NOT EXISTS invoice_item (
                                            invoice_item_id INT AUTO_INCREMENT PRIMARY KEY,
                                            invoice_id INT NOT NULL,
                                            book_id INT NOT NULL,
                                            quantity INT NOT NULL CHECK (quantity > 0),
                                            unit_price DECIMAL(12, 2) NOT NULL,
                                            line_total DECIMAL(12, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
                                            FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id) ON DELETE CASCADE,
                                            FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE RESTRICT
);

