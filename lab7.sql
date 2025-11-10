/* Part 2 */

CREATE VIEW employee_details as
    SELECT emp_name , salary ,d.dept_name , d.location from employees
    JOIN departments d using(dept_id);


SELECT * FROM employee_details;
/* 4 rows returned , because Tom brown doesn't have department*/


CREATE VIEW dept_statistics as
SELECT d.dept_name , count(e.emp_id) , avg(e.salary) , max(e.salary) , min(e.salary) FROM departments d
LEFT JOIN employees e using(dept_id)
GROUP BY d.dept_name;


CREATE VIEW project_overview as
SELECT p.project_name , p.budget , d.dept_name , d.location , count(e.emp_id) as team_size from projects p
JOIN departments d using(dept_id)
JOIN employees e using(dept_id)
GROUP BY project_name , budget , d.dept_name , d.location;


CREATE VIEW high_earners as
SELECT emp_name , salary, d.dept_name from employees
JOIN departments d using(dept_id)
WHERE salary > 55000;
/* it filters all rows by salary > 55000*/





/* Part 3*/


CREATE OR REPLACE VIEW employee_details as
    SELECT emp_name , salary ,d.dept_name , d.location ,
           CASE
                WHEN salary > 60000 THEN 'High'
                WHEN salary > 50000 THEN 'Medium'
                ELSE 'Standard'
           END as salary_grade
    from employees
    JOIN departments d using(dept_id);

ALTER VIEW high_earners RENAME TO top_performers;
SELECT * FROM top_performers;


CREATE VIEW temp_view as
SELECT * From employees where salary < 50000;

DROP VIEW temp_view;



/* Part 4 */


CREATE VIEW employee_salaries as
SELECT emp_id , emp_name , dept_id , salary from employees e;

UPDATE employee_salaries SET salary = 52000 where emp_name = 'John Smith';

SELECT * FROM employees where emp_name = 'John Smith';


INSERT INTO employee_salaries VALUES
    (6 , 'Alice Johnson'  , 102, 58000);
SELECT * FROm employees;


CREATE VIEW it_employees as
SELECT * FROM employees where dept_id = 101
WITH CHECK OPTION ;

INSERT INTO it_employees(emp_id , emp_name , dept_id , salary)
VALUES(7 , 'Bob Wilson' , 103, 60000);
/* I get the error because there's restriction in view dept_id = 101 */




/* Part 5 */



DROP MATERIALIZED VIEW dept_summary_mv;
CREATE MATERIALIZED VIEW  dept_summary_mv as
SELECT dept_id , dept_name , COALESCE(count(DISTINCT e.emp_id),0) as total_employees, coalesce(sum(e.salary),0 ) as total_salaries, coalesce(count(p.project_id),0)
     as total_proejects, coalesce(sum(p.budget),0) as total_budget from departments
LEFT JOIN employees e using(dept_id)
LEFT JOIN projects p using(dept_id)
GROUP BY dept_id, dept_name
WITH DATA ;

SELECT * FROM dept_summary_mv order by total_employees desc;

INSERT INTO employees
VALUES(8 , 'Charlie Brown' , 101 , 54000);


REFRESH MATERIALIZED VIEW dept_summary_mv;

SELECT * FROM dept_summary_mv order by total_employees desc;


CREATE UNIQUE INDEX dept_summary_mv_dept_id_idx on dept_summary_mv(dept_id);

REFRESH MATERIALIZED VIEW CONCURRENTLY dept_summary_mv;
/* it doesn't block select queries */



CREATE MATERIALIZED VIEW project_stats_mv as
SELECT p.project_name , p.budget ,d.dept_name , count(e.emp_id) FROM projects p
JOIN departments d using(dept_id)
JOIN employees e using(dept_id)
GROUP BY p.project_name, d.dept_name, p.budget
WITH NO DATA;


SELECT * FROM project_stats_mv;
/* i get error because mv is empty */








/* Part 6 */


CREATE ROLE analyst;

CREATE ROLE data_viewer with login password 'viewer123';

CREATE USER report_user with password 'report456'

SELECT rolname FROM pg_roles where rolname NOT LIKE 'pg_%';


CREATE ROLE db_creator WITH CREATEDB LOGIN PASSWORD 'creator789';

CREATE ROLE user_manager WITH CREATEROLE LOGIN password 'manager101';

CREATE ROLE admin_user WITH SUPERUSER LOGIN PASSWORD 'admin990';



GRANT SELECT ON employees TO analyst;
GRANT ALL ON employee_details to data_viewer;
GRANT SELECT, INSERT on employees to report_user;



CREATE GROUP hr_team;
CREATE GROUP finance_team;
CREATE GROUP it_team;

CREATE ROLE hr_user1 with password 'hr001';
CREATE ROLE hr_user2 password 'hr002';
CREATE ROLE finance_user1 password 'fin001';

GRANT hr_user1 to hr_team;
GRANT hr_user2 to hr_team;
GRANT finance_user1 to finance_team;
GRANT SELECT ,UPDATE on employees to hr_team;
GRANT SELECT on dept_statistics to finance_team;



REVOKE UPDATE on employees from hr_team;
REVOKE hr_team from hr_user2;
REVOKE ALL on employees from data_viewer;


ALTER ROLE analyst WITH LOGIN PASSWORD 'analyst123';
ALTER ROLE user_manager WITH SUPERUSER ;
ALTER ROLE analyst WITH PASSWORD NULL;
ALTER ROLE data_viewer WITH CONNECTION LIMIT 5;






/* Part 7 */


CREATE ROLE read_onl;
GRANT SELECT on all tables in schema public to read_onl;

CREATE ROLE junior_analyst with PASSWORD 'junior123';
CREATE ROLE senior_analyst with password 'senior123';

GRANT read_onl to junior_analyst , senior_analyst;

GRANT INSERT , UPDATE on employees to senior_analyst;


CREATE ROLE project_manager with login password 'pm123';
ALTER VIEW dept_statistics owner to project_manager;
ALTER TABLE projects owner to project_manager;

SELECT  tablename , tableowner FROM pg_tables WHERE schemaname = 'public';


CREATE ROLE temp_owner with login;
CREATE TABLE temp_table (
    table_id int
);
ALTER TABLE temp_table owner to temp_owner;
REASSIGN OWNED BY temp_owner to postgres;
DROP OWNED BY temp_owner;
DROP ROLE temp_owner;


CREATE VIEW hr_employee_view as
SELECT * FROM employees where dept_id = 102;

GRANT SELECT on hr_employee_view to hr_team;

CREATE VIEW finance_employee_view as
SELECT emp_id , emp_name , salary FROM employees;

GRANT SELECT on finance_employee_view to finance_team;





/* Part 8 */



CREATE VIEW dept_dashboard as
SELECT d.dept_name , d.location , count(DISTINCT e.emp_id) as employee_count ,
       avg(e.salary) as avg_salary,
       count(DISTINCT p.project_id) as number_of_projects,
       sum(p.budget),
       sum(p.budget) / count(DISTINCT e.emp_id) as budget_per_employee from departments d
JOIN employees e using(dept_id)
JOIN projects p using(dept_id)
GROUP By dept_id , dept_name, d.location;




ALTER TABLE projects
ADD COLUMN created_date date DEFAULT CURRENT_TIMESTAMP;


CREATE VIEW high_budget_projects as
SELECT project_name , budget, d.dept_name , created_date FROM projects
JOIN departments d using(dept_id)
where budget > 75000;

ALTER TABLE projects
ADD COLUMN approval_status varchar(60);

UPDATE  projects
SET approval_status =
    CASE
        WHEN budget > 150000 THEN 'Critical Review Required'
        WHEN budget > 100000 THEN 'Management Approval Needed'
        ELSE 'Standard Process'
    END;


CREATE ROLE viewer_role;

GRANT SElECT on All Tables In Schema public to viewer_role;


CREATE ROLE entry_role;
GRANT entry_role to viewer_role;
GRANT INSERT on employees to entry_role;
GRANT INSERT on projects to entry_role;


CREATE ROLE analyst_role;
GRANT analyst_role to entry_role;
GRANT UPDATE on employees to analyst_role;
GRANT UPDATE on projects to analyst_role;


CREATE ROLE manager_role;
GRANT manager_role to analyst_role;
GRANT DELETE on employees to manager_role;
GRANT DELETE ON projects to manager_role;



CREATE ROLE alice with login password 'alice123';
CREATE ROLE bob with login password 'bob123';
CREATE ROLE charlie with login password 'charlie123';
GRANT alice to viewer_role;
GRANT bob to analyst_role;
GRANT charlie to manager_role;