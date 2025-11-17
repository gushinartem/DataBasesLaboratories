/* Part 2 */


CREATE INDEX emp_salary on employees(salary);

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees';
/* there are 2 indexes */



CREATE INDEX emp_dept_idx on employees(dept_id);
SELECT * FROM employees WHERE dept_id = 101;
/* it increases the speed of query */


SELECT
 tablename,
 indexname,
 indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
/*

1 departments    departments_pkey
2 dept_summary_mv  dept_summary_mv_dept_id_idx
3 employees emp_dept_idx
4 employees emp_salary
5 employees employees_pkey
6 projects projects_pkey

1 , 5 , 6 are created automatically
 */



/* Part 3 */


CREATE INDEX emp_dept_salary_idx on employees(dept_id , salary);

SELECT emp_name, salary
FROM employees
WHERE dept_id = 101 AND salary > 52000;
/* it becomes useless because the first column of index is dept_id */


CREATE INDEX emp_salary_dept_idx on employees(salary , dept_id);

SELECT * FROM employees WHERE dept_id = 102 AND salary > 50000;

SELECT * FROM employees WHERE salary > 50000 AND dept_id = 102;
/* yes it matters which column should be in the query */




/* Part 4 */

ALTER TABLE employees ADD COLUMN email VARCHAR(100);
UPDATE employees SET email = 'john.smith@company.com' WHERE emp_id = 1;
UPDATE employees SET email = 'jane.doe@company.com' WHERE emp_id = 2;
UPDATE employees SET email = 'mike.johnson@company.com' WHERE emp_id = 3;
UPDATE employees SET email = 'sarah.williams@company.com' WHERE emp_id = 4;
UPDATE employees SET email = 'tom.brown@company.com' WHERE emp_id = 5;



CREATE UNIQUE INDEX emp_email_unique_idx on employees(email);

INSERT INTO employees (emp_id, emp_name, dept_id, salary, email)
VALUES (7, 'New Employee', 101, 55000, 'john.smith@company.com');
/* i receive error because email column should be unique */



ALTER TABLE employees ADD COLUMN phone VARCHAR(20) UNIQUE;

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees' AND indexname LIKE '%phone%';
/* it created a new index on column phone , index of a key */





/* Part 5 */



CREATE INDEX emp_salary_desc_idx on employees(salary desc);

SELECT emp_name, salary
FROM employees
ORDER BY salary DESC;
/* postgres already has table with ordered employees rows by salary because of desc index */


CREATE INDEX proj_budget_null_first_idx on projects(budget NULLS FIRST );

SELECT project_name, budget
FROM projects
ORDER BY budget NULLS FIRST;




/* Part 6 */

CREATE INDEX emp_name_lower_idx ON employees(LOWER(emp_name));

SELECT * FROM employees WHERE LOWER(emp_name) = 'john smith';
/* it would take every row and make it lowercase  , but index helps make it more efficiently */


ALTER TABLE employees ADD COLUMN hire_date DATE;
UPDATE employees SET hire_date = '2020-01-15' WHERE emp_id = 1;
UPDATE employees SET hire_date = '2019-06-20' WHERE emp_id = 2;
UPDATE employees SET hire_date = '2021-03-10' WHERE emp_id = 3;
UPDATE employees SET hire_date = '2020-11-05' WHERE emp_id = 4;
UPDATE employees SET hire_date = '2018-08-25' WHERE emp_id = 5;

CREATE INDEX emp_hire_year_idx on employees(EXTRACT(YEAR FROM employees.hire_date));

SELECT emp_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 2020;




/* Part 7 */


ALTER INDEX emp_salary_idx RENAME TO employees_salary_index;


SELECT indexname FROM pg_indexes WHERE tablename = 'employees';



DROP INDEX emp_salary_dept_idx;
/* when you don't  need it ???? */



REINDEX INDEX employees_salary_index;




/* Part 8 */

SELECT e.emp_name, e.salary, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 50000
ORDER BY e.salary DESC;

CREATE INDEX emp_salary_filter_idx ON employees(salary) WHERE salary > 50000;


CREATE INDEX proj_high_budget_idx ON projects(budget)
WHERE budget > 80000;

SELECT project_name, budget
FROM projects
WHERE budget > 80000;
/* partial indexes are covering only a part of a table they don't store all rows */


EXPLAIN SELECT * FROM employees WHERE salary > 52000;
/* it show seq scan - it means that query will be executed as usual */



/* Part 9 */



CREATE INDEX dept_name_hash_idx on departments using hash(dept_name);
SELECT * FROM departments WHERE dept_name = 'IT';
/* on quality comparisons */


CREATE INDEX proj_name_btree_idx ON projects(project_name);
CREATE INDEX proj_name_hash_idx ON projects USING HASH (project_name);

SELECT * FROM projects WHERE project_name = 'Website Redesign';
SELECT * FROM projects WHERE project_name > 'Database';




/* Part 10 */

SELECT
 schemaname,
 tablename,
 indexname,
 pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
/* all indexes with hash , mb because you have to make for all rows its own hash */



DROP INDEX IF EXISTS proj_name_hash_idx;


CREATE VIEW index_documentation AS
SELECT
 tablename,
 indexname,
 indexdef,
 'Improves salary-based queries' as purpose
FROM pg_indexes
WHERE schemaname = 'public'
 AND indexname LIKE '%salary%';
SELECT * FROM index_documentation;