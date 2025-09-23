
/*
    PART 1: MULTIPLE DATABASE MANAGEMENT

    task 1.1 database creation with parameters
*/
CREATE DATABASE university_main
    with OWNER  = postgres
    TEMPLATE  = template0
    ENCODING  = 'UTF8';
CREATE DATABASE university_archive
    CONNECTION LIMIT = 50
    TEMPLATE  = template0;
CREATE DATABASE university_test
    is_template = true
    connection limit = 10;



/*
    task 1.2 tablespace operations
*/
CREATE TABLESPACE student_data
LOCATION  'C:\Program Files\PostgreSQL\17\data\students';
CREATE TABLESPACE course_data
LOCATION  'C:\Program Files\PostgreSQL\17\data\courses';
CREATE DATABASE university_distributed
    WITH
    TABLESPACE = student_data
    ENCODING = 'LATIN9'
    LC_COLLATE = 'C'
    LC_CTYPE  = 'C'
    TEMPLATE = template0;





/*
    PART 2: COMPLEX TABLE CREATION

    task 2.1 university management system
*/
CREATE TABLE Students(
    student_id SERIAL primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    phone char(15),
    date_of_birth date,
    gpa decimal(3,2),
    is_active bool,
    graduation_year smallint
);
CREATE TABLE Professors(
    professor_id SERIAL primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    office_number varchar(20),
    hire_date date,
    salary NUMERIC(30,2),
    is_tenured bool,
    years_experience int
);
CREATE TABLE Courses(
    course_id SERIAL primary key,
    course_code char(8),
    course_title varchar(100),
    description text,
    credits smallint,
    max_enrollment int,
    course_fee decimal(10,2),
    is_online bool,
    created_at timestamp without time zone
);







/*
    task 2.2 time-based and specialized tables
*/
CREATE TABLE class_schedule (
    schedule_id SERIAL primary key,
    course_id int,
    professor_id int,
    classroom varchar(20),
    class_date date,
    start_time time without time zone,
    end_time time without time zone,
    duration interval
);
CREATE TABLE student_records(
    record_id SERIAL primary key,
    student_id int,
    course_id int,
    semester varchar(20),
    year int,
    grade char(2),
    attendance_percentage decimal(10,1),
    submission_timestamp timestamp without time zone,
    last_updated timestamp with time zone
);







/*
    PART 3: ADVANCED ALTER TABLE OPERATIONS

    task 3.1 modifying existing tables
*/
ALTER TABLE students
ADD COLUMN middle_name varchar(30),
ADD COLUMN student_status varchar(20),
ALTER COLUMN phone TYPE varchar(20),
ALTER COLUMN student_status  SET DEFAULT 'ACTIVE',
ALTER COLUMN gpa SET DEFAULT 0.00;

ALTER TABLE professors
ADD COLUMN department_code char(5),
ADD COLUMN research_area text,
ALTER COLUMN years_experience TYPE smallint,
ALTER COLUMN is_tenured SET  DEFAULT false,
ADD COLUMN last_promotion_date date;

ALTER TABLE courses
ADD COLUMN prerequisite_course_id int,
ADD COLUMN difficulty_level smallint,
ALTER COLUMN course_code TYPE varchar(10),
ALTER COLUMN credits SET DEFAULT 3,
ADD COLUMN lab_required bool DEFAULT false;








/*
    task 3.2 column management operations
*/
ALTER TABLE class_schedule
ADD COLUMN room_capacity int,
DROP COLUMN duration,
ADD COLUMN session_type varchar(15),
ALTER COLUMN classroom TYPE varchar(30),
ADD COLUMN equipment_needed text;

ALTER TABLE student_records
ADD COLUMN extra_credit_points decimal(3,1),
ALTER COLUMN grade TYPE varchar(5),
ALTER COLUMN extra_credit_points SET DEFAULT 0.0,
ADD COLUMN final_exam_date date,
DROP COLUMN last_updated;









/*
    PART 4: TABLE RELATIONSHIP AND MANAGEMENT

    task 4.1 additional supporting tables
*/

CREATE TABLE departments(
    department_id SERIAL primary key,
    department_name varchar(100),
    department_code char(5),
    building varchar(50),
    phone varchar(15),
    budget decimal(30, 2),
    established_year int
);

CREATE TABLE library_books(
    book_id SERIAL primary key,
    isbn char(13),
    title varchar(200),
    author varchar(100),
    publisher varchar(100),
    publication_date date,
    price decimal(10 ,2),
    is_available bool,
    acquisition_timestamp timestamp without time zone
);

CREATE TABLE student_book_loans(
    loan_id SERIAL primary key,
    student_id int,
    book_id int,
    loan_date date,
    due_date date,
    return_date date,
    fine_amount decimal(10, 2),
    loan_status varchar(20)
);




/*
    task 4.2 table modifications for integration


    1
*/
ALTER TABLE professors
ADD COLUMN department_id int;
ALTER TABLE students
ADD COLUMN advisor_id int;
ALTER TABLE courses
ADD COLUMN department_id int;

/*
    2
*/
CREATE TABLE grade_scale(
    grade_id SERIAL primary key,
    letter_grade char(2),
    min_percentage decimal(4 , 1),
    max_percentage decimal(4,1),
    gpa_points decimal(3,2)
);
CREATE TABLE semester_calendar(
    semester_id SERIAL primary key,
    semester_name varchar(20),
    academic_year int,
    start_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current bool
);




/*
    PART 5: TABLE DELETION AND CLEANUP

    task 5.1 conditional table operations


    1
*/
DROP TABLE IF EXISTS student_book_loans;
DROP TABLE IF EXISTS library_books;
DROP TABLE IF EXISTS grade_scale;
/*
    2
*/
CREATE TABLE grade_scale(
    grade_id SERIAL primary key,
    letter_grade char(2),
    min_percentage decimal(4,1),
    max_percentage decimal(4,1),
    gpa_points decimal(3,2),
    description text
);
/*
    3
*/
DROP TABLE semester_calendar CASCADE;
CREATE TABLE semester_calendar(
    semester_id SERIAL primary key,
    semester_name varchar(20),
    academic_year int,
    start_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current bool
);



/*
    task 5.2 database cleanup
*/
UPDATE pg_database
SET datistemplate = false
WHERE datname = 'university_test';
DROP DATABASE IF EXISTS university_test;
DROP DATABASE IF EXISTS university_distributed;

CREATE DATABASE university_backup WITH TEMPLATE = university_main;