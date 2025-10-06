/*

    PART 1: BASIC SELECT QUERIES


    Task 1.1
 */
SELECT first_name || ' '   || last_name as full_name , department , salary from employees;


/*

    Task 1.2

 */
 SELECT DISTINCT department from employees;


/*

    Task 1.3

 */
 SELECT project_name , budget , CASE
 WHEN budget > 150000 THEN 'Large'
 WHEN budget BETWEEN 100000 and 150000 THEN 'Medium'
 ELSE 'Small'
 END as budget_category
 from projects;

/*

    Task 1.4

 */
SELECT first_name || ' ' || last_name as full_name, COALESCE(email, 'No email provided') as email from employees;



/*

    PART 2: WHERE CLAUSE AND COMPARISON OPERATORS

    Task 2.1

 */
SELECT * from employees where hire_date > '2020-01-01';


/*

    Task 2.2

 */
SELECT * FROM employees where salary between 60000 and 70000;


/*

    Task 2.3

 */
SELECT * FROM employees where last_name LIKe 'S%' or last_name LIKE 'J%';


/*

    Task 2.4

 */
SELECT * FROM employees where manager_id is not null;



/*

    PART 3: STRING AND MATHEMATICAL FUNCTIONS


    Task 3.1

 */
 SELECT UPPER(first_name) as first_name , length(last_name) as length , substring(email  FROM 1 FOR 3) as email FROM employees;



/*

    Task 3.2

 */
SELECT salary * 12 as annual_salary , ROUND(salary,2) as monthly_salary, salary*1.10 as raised_salary  from employees;



/*

    Task 3.3

 */
SELECT format('Project: %s  - Budget: $%s - Status: %s' , project_name , budget , status) from projects;



/*

    Task 3.4

 */
SELECT first_name || ' ' || last_name as full_name , extract(YEAR FROM AGE(current_date , hire_date)) as years from employees;


/*

    PART 4: AGGREGATE FUNCTIONS AND GROUP BY


    Task 4.1

 */
SELECT AVG(salary) as average_salary, department FROM employees  group by department;


/*

    Task 4.2

 */
SELECT
    project_name,
    (end_date - start_date) * 24 AS total_hours
FROM projects;


/*

    Task 4.3

 */
SELECT count(*) as num , department from employees group by department having count(*) > 1;


/*

    Task 4.4

 */
SELECT
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    SUM(salary) as sum_salary from employees;




/*

    PART 5: SET OPERATIONS

    Task 5.1

 */
 SELECT employees.employee_id , first_name || ' ' || last_name as full_name , salary from employees
WHERE salary > 65000

UNION

SELECT employees.employee_id , first_name || ' ' || last_name as full_name , salary from employees
WHERE hire_date > '2020-01-01';



/*

    Task 5.2

 */
 SELECT * from employees where department = 'IT'

INTERSECT
SELECT * FROM employees where salary > 65000;


/*

    Task 5.3

 */
SELECT employees.employee_id  from employees
EXCEPT
SELECT assignments.employee_id from assignments;


/*

    PART 6: SUBQUERIES

    Task 6.1

 */
 SELECT employee_id, first_name || ' ' || last_name as full_name from employees e
WHERE EXISTS(
    SELECT 1 FROM assignments a where e.employee_id = a.employee_id
);


/*

    Task 6.2

 */
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name
FROM employees e
WHERE e.employee_id IN (
    SELECT employee_id
    FROM assignments a
    JOIN projects p ON a.project_id = p.project_id
    WHERE p.status = 'Active'
);


/*

    Task 6.3

 */
SELECT employee_id , first_name || ' ' || last_name as full_name from employees
WHERE salary > Any (
    SELECT salary from employees where department = 'Sales'
    )



/*

    PART 7: COMPLEX QUERIES

    Task 7.1

 */
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department,
    AVG(a.hours_worked) AS avg_hours
FROM employees e
JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id;



/*

    Task 7.2

 */
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours,
    COUNT(DISTINCT a.employee_id) AS num_employees
FROM projects p
JOIN assignments a
    ON p.project_id = a.project_id
GROUP BY p.project_name
HAVING SUM(a.hours_worked) > 150;



/*

    Task 7.3
  */
SELECT
    e.department,
    COUNT(*) AS total_employees,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    CONCAT(
        MAX(e.first_name) FILTER (WHERE e.salary = (
            SELECT MAX(salary)
            FROM employees
            WHERE department = e.department
        )),
        ' ',
        MAX(e.last_name) FILTER (WHERE e.salary = (
            SELECT MAX(salary)
            FROM employees
            WHERE department = e.department
        ))
    ) AS highest_paid_employee,
    GREATEST(AVG(e.salary), MIN(e.salary)) AS salary_range_top,
    LEAST(AVG(e.salary), MAX(e.salary)) AS salary_range_bottom
FROM employees e
GROUP BY e.department;