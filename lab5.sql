--- ARTEM GUCHSHIN
--- 24B031011


/*
    Part 1


 */


CREATE TABLE employees(
    employee_id SERIAL primary key,
    first_name text,
    last_name text,
    age int CHECK (age BETWEEN 18 AND 25),
    salary numeric CHECK (salary > 0)
);

CREATE TABLE products_catalog(
    product_id SERIAL primary key,
    product_name text,
    regular_price numeric,
    discount_price numeric,
    CONSTRAINT valid_discount CHECK(
        regular_price > 0 AND
        discount_price > 0 AND
        discount_price < regular_price
    )
);

CREATE TABLE bookings(
    booking_id SERIAL primary key ,
    check_in_date date,
    check_out_date date CHECK( check_out_date > check_in_date),
    num_guests int CHECK ( num_guests BETWEEN  1 AND 10)
);

INSERT INTO employees (first_name, last_name, age, salary)
VALUES
    ('John' ,'Smith' , 20 , 20000 ),
    ('Rick' , 'Sanchez' , 25 , 1000000);

INSERT INTO products_catalog (product_name, regular_price, discount_price)
VALUES
    ('Apple' , 20 , 15),
    ('Banana' , 15 , 13);

INSERT INTO  bookings (check_in_date, check_out_date, num_guests)
VALUES
    ('2020-01-01' , '2020-01-02' , 2),
    ('2020-01-03' , '2020-01-04' , 1);


INSERT INTO employees (first_name, last_name, age, salary)
VALUES ('Bob' , 'Trump' , 30 , 0);
/* age is not between 18 and 25 , and salary is zero */

INSERT INTO products_catalog (product_name, regular_price, discount_price)
VALUES ('Melon' , -2 , -1);
/*  regular and discount price are below zero and discount is not less than regular */

INSERT INTO bookings (check_in_date, check_out_date, num_guests)
VALUES ('2020-05-02' , '2019-05-02' , 0);
/* check in date is after check out date , and num of guests is not between 1 and 10 */


/*

    Part 2

 */


CREATE TABLE customers(
    customer_id SERIAL primary key CHECK (customer_id is not NULL),
    email text CHECK(email is not NULL),
    phone text,
    registration_date date CHECK (registration_date is not NULL)
);

CREATE TABLE inventory(
    item_id int CHECK (item_id is not NULL),
    item_name text CHECK (item_name is NOT NULL),
    quantity int CHECK (quantity is not null and quantity >= 0),
    unit_price numeric CHECK (unit_price is NOT NULL and unit_price > 0),
    last_updated timestamp CHECK (last_updated is NOT NULL)
);


INSERT INTO customers (email, phone, registration_date)
VALUES ('adcd@mail.ru' , '87769394' , '2020-01-01')

INSERT INTO inventory (item_id, item_name, quantity, unit_price, last_updated)
VALUES (1 , 'Table' , '1 ' , 100 , '2020-01-01');


INSERT INTO customers (email, phone, registration_date) VALUES
(NULL , '858473740' , NULL);

INSERT INTO inventory (item_id, item_name, quantity, unit_price, last_updated) VALUES
(NULL , NULL, NULL , NULL, NULL);


INSERT INTO customers (email, phone, registration_date)
VALUES ('adcd@mail.ru' , NULL , '2020-01-01')

INSERT INTO inventory (item_id, item_name, quantity, unit_price, last_updated)
VALUES (1 , 'Table' , '1 ' , 100 , '2020-01-01');



/*

    Part 3

 */

 CREATE TABLE users(
     user_id SERIAL primary key,
     user_name text UNIQUE,
     email text UNIQUE ,
     created_at timestamp
 );
CREATE TABLE course_enrollments(
    enrollment_id SERIAL primary key,
    student_id int,
    course_code text,
    semester text,
    CONSTRAINT unique_vars UNIQUE (student_id , course_code , semester)
);


ALTER TABLE users
ADD CONSTRAINT unique_user_names UNIQUE (user_name),
ADD CONSTRAINT unique_email UNIQUE (email);

INSERT INTO users (user_name, email, created_at)
VALUES ('JOhn' , 'adcd@gmail.com' , '2020-01-01');

INSERT INTO users (user_name, email, created_at)
VALUES ('Rick' , 'adcd@gmail.com' , '2020-01-01');

INSERT INTO users (user_name, email, created_at)
VALUES ('JOhn' , 'adc@gmail.com' , '2020-01-01');



/*

    Part 4

 */

CREATE TABLE departments(
    dept_id int primary key ,
    dept_name text NOT NULL,
    location text
);

INSERT INTO departments (dept_id ,dept_name, location)
VALUES (1 , 'Marketing' , 'New York');

INSERT INTO departments (dept_id ,dept_name, location)
VALUES (1 , 'Social' , 'New York');

INSERT INTO departments (dept_id ,dept_name, location)
VALUES (NULL , 'Marketing' , 'New York');


CREATE TABLE student_courses(
    student_id int,
    course_id int,
    enrollment_date date,
    grade text,
    PRIMARY KEY (student_id , course_id)
);


/*

 1.The difference between UNIQUE and PRIMARY KEY is
 UNIQUE on a collumn means that all values are unique ,
 when PRIMARY KEY is idenifying each row in a table.
 ALso primary key does not accept NULL value when unique do
 2. Use single column when this one attirubute can idenify the row
 in the table and use composite otherwise
 3. UNIQUE on a collumn means that all values are unique ,
 when PRIMARY KEY is idenifying each row in a table.
 */


 /*

    Part 5

  */


CREATE TABLE employees_dept(
    emp_id int primary key ,
    emp_name text NOT NULL,
    dept_id int REFERENCES departments,
    hire_date date
);

INSERT INTO employees_dept (emp_id, emp_name, dept_id, hire_date) VALUES
(1 , 'JOhn' , 1 , current_date);

INSERT INTO employees_dept (emp_id, emp_name, dept_id, hire_date) VALUES
(1 , 'JOhn' , 2 , current_date);



CREATE TABLE authors(
    author_id int primary key,
    author_name text NOT NULL,
    country text
);

CREATE TABLE publishers(
    publisher_id int primary key ,
    publisher_name text NOT NULL,
    city text
);
CREATE TABLE books(
    book_id int primary key ,
    title text NOT NULL,
    author_id int REFERENCES  authors,
    publisher_id int REFERENCES publishers,
    publication_year int,
    isbn text UNIQUE
);


INSERT INTO authors (author_id, author_name, country) VALUES
(1 , 'Julian' , 'UK');

INSERT INTO publishers (publisher_id, publisher_name, city) VALUES
(1 , 'DK' , 'New York');

INSERT INTO books (book_id, title, author_id, publisher_id, publication_year, isbn) VALUES
(1 , 'Harry Potter' , 1 , 1 , 2000 , '01001');





CREATE TABLE categories(
    category_id int primary key ,
    category_name text NOT NULL
);

CREATE TABLE products_fk(
    product_Id int primary key ,
    product_name text NOT NULL,
    category_id int REFERENCES categories ON DELETE RESTRICT
);

CREATE TABLE orders(
    order_id int primary key ,
    order_date date NOT NULL
);

CREATE TABLE  order_items(
    item_id int primary key ,
    order_id int REFERENCES orders ON DELETE CASCADE ,
    product_id int REFERENCES products_fk,
    quantity int CHECK (quantity > 0)
);


/* INSERTING DATA INTO TABLES  TO CHECK THEIR CONDITONIS */
INSERT INTO categories (category_id, category_name) VALUES
        (1 , 'Fruits');
INSERT INTO products_fk (product_Id, product_name, category_id) VALUES
        (1 , 'Banana' , 1);

/* deleting category with id = 1 ( it won't work) */
DELETE FROM categories WHERE category_id = 1;


/* inserting data to check on delete conditions */
INSERT INTO orders (order_id, order_date) VALUES
        (1 , current_date);
INSERT INTO order_items (item_id, order_id, product_id, quantity) VALUES
        (1 , 1 ,1 , 1);

/* deleting order */
DELETE FROM orders where order_id = 1;

/* checking if order_item is still in table */
SELECT * FROM order_items;


/*

    Part 6

 */
DROP TABLE customers;
CREATE TABLE customers(
     customer_id SERIAL primary key ,
     name varchar(60) NOT NULL,
     email varchar(60) UNIQUE ,
     phone varchar(60),
     registration_date date
 );
CREATE TABLE products(
    product_id SERIAL primary key ,
    name varchar(60) NOT NULL,
    description text,
    price int CHECK ( price > 0),
    stock_quantity int CHECK (stock_quantity > 0)
);
CREATE TABLE orders_5(
    order_Id SERIAL primary key ,
    customer_id int REFERENCES customers ON DELETE CASCADE,
    order_date date,
    total_amount int,
    status varchar(20) CHECK (status in ('pending' , 'processing' ,'shipped' , 'delivered' , 'cancelled'))
);
CREATE TABLE order_details(
    order_detail_id SERIAL primary key ,
    order_id int REFERENCES orders_5 ON DELETE CASCADE ,
    product_id int REFERENCES products ON DELETE CASCADE ,
    quantity int CHECK (quantity > 0),
    unit_price int
);

-- Customers
INSERT INTO customers (name, email, phone, registration_date) VALUES
('Alice Johnson', 'alice@example.com', '+77010000001', '2025-01-01'),
('Bob Smith', 'bob@example.com', '+77010000002', '2025-01-03'),
('Charlie Brown', 'charlie@example.com', '+77010000003', '2025-02-10'),
('Diana Lee', 'diana@example.com', '+77010000004', '2025-02-12'),
('Ethan Miller', 'ethan@example.com', '+77010000005', '2025-03-01');

-- Products
INSERT INTO products (name, description, price, stock_quantity) VALUES
('Laptop', '15-inch lightweight laptop', 1200.00, 10),
('Mouse', 'Wireless optical mouse', 25.00, 50),
('Keyboard', 'Mechanical keyboard', 70.00, 30),
('Monitor', '24-inch HD monitor', 200.00, 20),
('Headphones', 'Noise-cancelling headphones', 150.00, 15);

-- Orders
INSERT INTO orders_5 (customer_id, order_date, total_amount, status) VALUES
(1, '2025-03-10', 1275.00, 'pending'),
(2, '2025-03-11', 200.00, 'processing'),
(3, '2025-03-12', 150.00, 'shipped'),
(4, '2025-03-13', 1270.00, 'delivered'),
(5, '2025-03-14', 25.00, 'cancelled');

-- Order Details
INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00),
(1, 2, 3, 25.00),
(2, 4, 1, 200.00),
(3, 5, 1, 150.00),
(4, 3, 1, 70.00);



-- Check
INSERT INTO customers (name, email, phone) VALUES
('Duplicate Email', 'alice@example.com', '+77019999999');

INSERT INTO products (name, description, price, stock_quantity) VALUES
('Invalid Price Product', 'Negative price test', -5, 10);

INSERT INTO products (name, description, price, stock_quantity) VALUES
('Invalid Stock', 'Negative stock test', 50, -3);

INSERT INTO orders_5 (customer_id, total_amount, status) VALUES
(1, 100.00, 'waiting');

INSERT INTO orders_5 (customer_id, total_amount, status) VALUES
(1, -50.00, 'pending');

INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 0, 25.00);

INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 2, -10.00);









