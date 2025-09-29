



/*
    PART A: DATABASE AND TABLE SETUP

    1.Create database and tables

*/
CREATE DATABASE "advanced_Lab";
CREATE TABLE employees(
    emp_id SERIAL primary key,
    first_name varchar(60),
    last_name varchar(60),
    department varchar(60),
    salary int,
    hire_date date,
    status varchar(60) DEFAULT 'Active'
);
CREATE TABLE departments(
    dept_id SERIAL primary key,
    dept_name varchar(60),
    budget int,
    manager_id int
);
CREATE table projects(
    project_id SERIAL primary key,
    project_name varchar(60),
    dept_id int,
    start_date date,
    end_date date,
    budget int
);





/*
    PART B: ADVANCED OPERATIONS

    2.Insert with column specification
*/
INSERT INTO employees (emp_id , first_name , last_name, department)
VALUES (1 , 'John' , 'Smith' , 'IT');

/*

    3.Insert with DEFAULT value

*/
INSERT INTO employees (emp_id ,first_name, last_name, department, salary, hire_date, status)
VALUES (3 , 'Max' , 'Smith'  ,'Management' ,DEFAULT ,current_date , DEFAULT);

/*

    4.Insert multiple rows in single statement

*/
INSERT INTO departments
VALUES (1 , 'Management',20000, 1),
       (2 , 'Marketing' , 40000 , 2),
       (3 , 'Testing' , 10000 , 3);


/*

    5.Insert with expressions

*/
INSERT INTO employees
VALUES (4 , 'Sam' , 'God' , 'Marketing' , 50000*1.1 , current_date , DEFAULT);


/*

    6.Insert from SELECT (subquery)

*/
CREATE TABLE  temp_employees (LIKE employees INCLUDING ALL);
INSERT INTO temp_employees SELECT * FROM employees WHERE department = 'IT';









/*
    PART C: COMPLEX UPDATE OPERATIONS

    7.Update with arithmetic expressions

*/
UPDATE employees SET salary = salary * 1.1;



/*

    8.UPDATE with WHERE clause multiple conditions

*/
UPDATE employees SET status = 'Senior' WHERE salary > 60000 and hire_date < '2020-01-01';


/*

    9.UPDATE using CASE expression

*/
UPDATE employees SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 and 80000 THEN 'Senior'
    ELSE 'Junior'
END;

/*

    10.Update with DEFAULT

*/
UPDATE employees SET department = DEFAULT where  status = 'Inactive';


/*

    11.Update with subquery

*/
UPDATE departments d set budget = avg_salaries.avg_salary * 1.20
FROM (
    SELECT department , AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) AS avg_salaries
WHERE d.dept_name = avg_salaries.department;


/*

    12.UPDATE multiple columns

*/
UPDATE employees SET salary = salary*1.15 , status = 'Promoted' WHERE department = 'Sales';















/*

    PART D: Advanced DELETE Operations

    13.DELETE with simple WHERE condition

*/
DELETE FROM employees WHERE status = 'Terminated';


/*

    14.DELETE with complex WHERE CLAUSE

*/
DELETE FROM employees Where salary < 40000 AND hire_date > '2023-01-01' and department is NULL;


/*

    15.DELETE with subquery

 */
 DELETE FROM departments WHERE dept_name not IN (SELECT DISTINCT department FROM employees WHERE department is NOT NULL);

/*

    16.DELETE with RETURNING clause

 */
 DELETE FROM projects WHERE end_date < '2023-01-01' RETURNING *;












/*
    PART E:OPERATIONS WITH NULL VALUES


    17.INSERT with NULL values

 */
INSERT INTO employees (emp_id , first_name , last_name, department, salary)
VALUES (6 , 'John' , 'Smith' , NULL , NULL);


/*

    18.UPDATE NULL handling

 */
 UPDATE employees SET department = 'Unassigned' where department is null;


/*

    19.DELETE with NULL conditions

 */
 DELETE FROM employees where salary is null or department is null;











/*
    PART F:RETURNING CLAUSE OPERATIONS

    20.INSERT with RETURNING

 */
INSERT INTO employees (first_name , last_name)
VALUES ('Max' , 'Verstappen') RETURNING emp_id , first_name || ' ' || last_name AS full_name;


/*

    21.UPDATE with RETURNING

 */
 UPDATE employees SET salary = salary + 5000 WHERE department = 'IT' RETURNING emp_id , salary-5000 AS old_salary , salary AS new_salary;


/*

    22.DELETE with RETURNING all columns

 */
 DELETE FROM employees WhERE hire_date < '2020-01-01' RETURNING  *;












/*

    PART G: ADVANCED DML PATTERNS

    23.Conditional INSERT

 */
INSERT INTO employees(first_name, last_name, department, salary)
 SELECT 'Eugene' , 'Guchshin' , 'IT' , 15000
 WHERE NOT exists(
     SELECT 1
     FROM employees
     WHERE first_name = 'Eugene'
     AND last_name = 'Guchshin'
 );


/*

    24.UPDATE with JOIN logic using subqueries

 */
 UPDATE employees e SET salary = salary *
    CASE
        WHEN d.budget > 100000 THEN 1.1
        ELSE 1.05
    END
 FROM departments d
 WHERE e.department = d.dept_name;


/*

    25.Bulk operations

 */
WITH inserted as (
    INSERT INTO employees (first_name, last_name, department, salary) VALUES ('John', 'Doe', 'IT', 60000),
                                                                             ('Alice', 'Smith', 'Finance', 55000),
                                                                             ('Bob', 'Johnson', 'HR', 50000),
                                                                             ('Emily', 'Davis', 'Marketing', 58000),
                                                                             ('Michael', 'Brown', 'IT', 62000)
    RETURNING  emp_id , first_name || ' ' || last_name AS full_name
)
UPDATE employees e
SET salary = e.salary * 1.10
WHERE e.first_name || ' ' || e.last_name IN( SELECT full_name FROM inserted) AND e.emp_id IN (SELECT emp_id FROM inserted)
RETURNING e.emp_id , e.first_name , e.last_name , e.salary;

/*

    26.Data migration simulation

 */
 CREATE TABLE employee_archive AS
     SELECT first_name , last_name , department, salary , status
 FROM employees
 WHERE status = 'Inactive';

/*

    27.Complex business logic

 */
UPDATE projects p SET end_date = end_date + INTERVAL '30 days'
                  WHERE budget > 50000 AND
(
SELECT COUNT(*)
FROM employees e
WHERE department = (
    SELECT dept_name
    FROM departments d
    WHERE dept_id = p.dept_id
    ) ) > 3;