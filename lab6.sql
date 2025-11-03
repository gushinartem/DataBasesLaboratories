
/* Part 1 */
CREATE TABLE employees(
    emp_id int primary key,
    emp_name varchar(50),
    dept_id int,
    salary DECIMAL(10,2)
);
CREATE TABLE departments(
    dept_id int primary key,
    dept_name varchar(50),
    location varchar(50)
);
CREATE TABLE projects(
    project_id int primary key,
    project_name varchar(50),
    dept_id int,
    budget decimal(10,2)
);


INSERT INTO employees VALUES
                          (1 , 'John Smith' , 101 , 50000),
                          (2 , 'Jane Doe' , 102 , 60000),
                          (3 , 'Mike Johnson' , 101 , 55000),
                          (4 , 'Sarah Williams' , 103 , 65000),
                          (5 , 'Tom Brown' , NULL , 45000);
INSERT INTO departments VALUES
                            (101 , 'IT'  ,'Building A'),
                            (102 , 'HR'  ,'Building B'),
                            (103 , 'Finance'  ,'Building C'),
                            (104 , 'Marketing'  ,'Building D');

INSERT INTO projects VALUES
                         (1 , 'Website Redesign' , 101 , 100000),
                         (2 , 'Employee Training' , 102 , 50000),
                         (3 , 'Budget Analysis' , 103 , 75000),
                         (4,'Cloud Migration' , 101 , 150000),
                         (5 ,'AI Research' , NULL , 200000);


/* Part 2 */

SELECT e.emp_name , d.dept_name FROM employees e CROSS JOIN departments d;


SELECT e.emp_name , d.dept_name FROM employees e , departments d;

SELECT e.emp_name , d.dept_name FROM employees e INNER JOIN departments d on TRUE;

SELECT e.emp_name , p.project_name FROM employees e CROSS JOIN projects p;





/* Part 3 */

SELECT e.emp_name , d.dept_name, d.location FROM employees e INNER JOIN departments d on e.dept_id = d.dept_id;
/* 4 rows are returned , Tom Brown not included because he doesn't have dept_id */


SELECT e.emp_name , dept_name , location FROM employees e INNER JOIN departments USING(dept_id);


SELECT e.emp_name , dept_name , location FROM employees e NATURAL INNER JOIN departments;

SELECT emp_name , dept_name , project_name FROM employees e
    INNER JOIN departments d on e.dept_id = d.dept_id
    INNER JOIN projects p on e.dept_id = p.dept_id;





/* Part 4 */

SELECT e.emp_name , e.dept_id AS emp_dept , d.dept_id AS dept_dept , d.dept_name FROM employees e LEFT JOIN departments d on e.dept_id = d.dept_id;

SELECT e.emp_name , e.dept_id AS emp_dept , d.dept_id AS dept_dept , d.dept_name FROM employees e LEFT JOIN departments d using(dept_id);

SELECT e.emp_name , d.dept_id FROM employees e LEFT JOIN departments d on e.dept_id = d.dept_id
WHERE d.dept_id is NULL;


SELECT d.dept_name , count(e.emp_id) as employees from departments d LEFT JOIN employees e on d.dept_id = e.dept_id
GROUP BY d.dept_id
ORDER BY employees DESC;






/* Part 5 */


SELECT e.emp_name , d.dept_name FROM employees e RIGHT JOIN departments d on e.dept_id = d.dept_id;


SELECT e.emp_name , d.dept_name FROM departments d LEFT JOIN employees e on e.dept_id = d.dept_id;


SELECT e.emp_name , d.dept_name FROM employees e RIGHT JOIN departments d on e.dept_id = d.dept_id
WHERE e.dept_id is NULL;





/* Part 6 */

SELECT e.emp_name , e.dept_id as emp_dept , d.dept_id as dept_dept , d.dept_name FROM employees e FULL JOIN departments d on e.dept_id = d.dept_id;

SELECT d.dept_name , p.project_name, p.budget from departments d FULL JOIN projects p on d.dept_id = p.dept_id;

SELECT e.emp_name , e.dept_id as emp_dept , d.dept_id as dept_dept , d.dept_name FROM employees e FULL JOIN departments d on e.dept_id = d.dept_id;

SELECT
    CASE
        WHEN e.emp_id IS NULL THEN 'Department without
            employees'
        WHEN d.dept_id IS NULL THEN 'Employee without
            department'
        ELSE 'Matched'
    END AS record_status,
    e.emp_name,
    d.dept_name
    FROM employees e
    FULL JOIN departments d ON e.dept_id = d.dept_id
    WHERE e.emp_id IS NULL OR d.dept_id IS NULL;





/* Part 7 */

SELECT e.emp_name , d.dept_name , e.salary FROM employees e LEFT JOIN departments d on e.dept_id = d.dept_id
AND d.location = 'Building A';

SELECT e.emp_name , d.dept_name , e.salary FROM employees e LEFT JOIN departments d on e.dept_id = d.dept_id
WHERE d.location = 'Building A';

/*
    the difference between these two ways is that where clause work AFTER
   join clause, so that where doesn't give rows where d.location != 'Building A'
*/


SELECT e.emp_name , d.dept_name , e.salary FROM employees e INNER JOIN departments d on e.dept_id = d.dept_id
AND d.location = 'Building A';

SELECT e.emp_name , d.dept_name , e.salary FROM employees e INNER JOIN departments d on e.dept_id = d.dept_id
WHERE d.location = 'Building A';
/* the difference is that inner join doesn't give null rows only which matched */





/* Part 8 */


SELECT d.dept_name , e.emp_name , p.project_name from departments d LEFT JOIN employees e on d.dept_id = e.dept_id
LEFT JOIN projects p on p.dept_id = d.dept_id
ORDER BY d.dept_name , e.emp_name;


ALTER TABLE employees
ADD COLUMN manager_id int;

UPDATE employees SET manager_id = 3 WHERE emp_id = 1;
UPDATE employees SET manager_id = 3 WHERE emp_id = 2;
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees SET manager_id = 3 WHERE emp_id = 4;
UPDATE employees SET manager_id = 3 WHERE emp_id = 5;


SELECT e.emp_name as employee , m.emp_name as manager FROM employees e LEFT JOIN employees m on e.manager_id = m.emp_id;



SELECT d.dept_name , avg(e.salary) as avg_salary from departments d INNER JOIN employees e on d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING avg(e.salary) > 50000;

/* Lab Questions */

/*
 1. inner join return only matched rows , when left join return all rows from left table and matched
 2. when I need to get all combinations of rows
 3. because for inner joins even if we put some on and where clause the results wil be always only matched rows,
 when in outer joins there could be not matched
 4. result is 50
 5. it finds all matched columns and compare them
 6. if some day you want to add new column in both tables , the result of old queries will change and
 it can lead to errors
 7. SELECT * FROM B RIGHT JOIN A ON A.id = B.id
 8. when I need to see ALL rows from left and right tables , even there's no math between them
 */


/*

 ADDITIONAL CHALLENGES

 */
SELECT e.emp_name, d.dept_name FRom employees e LEFT JOIN departments d on e.dept_id = d.dept_id


UNION

SELECT e.emp_name, d.dept_name From employees e RIGHT JOIN departments d on e.dept_id = d.dept_id;




SELECT e.emp_id, e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d on d.dept_id = e.dept_id
WHERE e.dept_id IN (
    SELECT p.dept_id
    FROM projects p
    GROUP BY p.dept_id
    HAVING COUNT(*) > 1
);


WITH RECURSIVE org_chart AS (
    -- top-level managers (no manager_id)
    SELECT emp_id, emp_name, manager_id, 0 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL
    -- find employees to the employee(their's manager) above
    SELECT e.emp_id, e.emp_name,e.manager_id,oc.level + 1
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.emp_id
)

SELECT
    repeat('   ', level) || emp_name AS org_structure
FROM org_chart
ORDER BY level, emp_name;


SELECT
    e1.emp_name AS employee1,
    e2.emp_name AS employee2,
    e1.dept_id
FROM employees e1
JOIN employees e2
    ON e1.dept_id = e2.dept_id
   AND e1.emp_id < e2.emp_id;





