-- Daily Challenge: Cleaning and Transforming Employee Record Data with SQL
-- SQLite-compatible. Safe to rerun. Original input is preserved in challenge_employees.

-- 0. Create and populate the sample dataset
DROP TABLE IF EXISTS challenge_employees;
CREATE TABLE challenge_employees (
    employee_id INTEGER PRIMARY KEY,
    employee_name VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date VARCHAR(20),
    department VARCHAR(50)
);
INSERT INTO challenge_employees (employee_id, employee_name, salary, hire_date, department) VALUES
(1,'Amy West',60000.00,'2021-01-15','HR'),
(2,'Ivy Lee',75000.50,'2020-05-22','Sales'),
(3,'joe smith',80000.75,'2019-08-10','Marketing'),
(4,'John White',90000.00,'2020-11-05','Finance'),
(5,'Jane Hill',55000.25,'2022-02-28','IT'),
(6,'Dave West',72000.00,'2020-03-12','Marketing'),
(7,'Fanny Lee',85000.50,'2018-06-25','Sales'),
(8,'Amy Smith',95000.25,'2019-11-30','Finance'),
(9,'Ivy Hill',62000.75,'2021-07-18','IT'),
(10,'Joe White',78000.00,'2022-04-05','Marketing'),
(11,'John Lee',68000.50,'2018-12-10','HR'),
(12,'Jane West',89000.25,'2017-09-15','Sales'),
(13,'Dave Smith',60000.75,'2022-01-08',NULL),
(14,'Fanny White',72000.00,'2019-04-22','IT'),
(15,'Amy Hill',84000.50,'2020-08-17','Marketing'),
(16,'Ivy West',92000.25,'2021-02-03','Finance'),
(17,'Joe Lee',58000.75,'2018-05-28','IT'),
(18,'John Smith',77000.00,'2019-10-10','HR'),
(19,'Jane Hill',81000.50,'2022-03-15','Sales'),
(20,'Dave White',70000.25,'2017-12-20','Marketing');

-- 1. Profile missing values; department is NULL for employee 13.
SELECT COUNT(*) AS total_rows,
 SUM(CASE WHEN employee_name IS NULL OR TRIM(employee_name) = '' THEN 1 ELSE 0 END) AS missing_names,
 SUM(CASE WHEN salary IS NULL THEN 1 ELSE 0 END) AS missing_salaries,
 SUM(CASE WHEN hire_date IS NULL OR TRIM(hire_date) = '' THEN 1 ELSE 0 END) AS missing_dates,
 SUM(CASE WHEN department IS NULL OR TRIM(department) = '' THEN 1 ELSE 0 END) AS missing_departments
FROM challenge_employees;

-- 2. Inspect duplicates by employee_id (the primary key prevents duplicate IDs).
SELECT employee_id, COUNT(*) AS occurrences
FROM challenge_employees GROUP BY employee_id HAVING COUNT(*) > 1;
-- Names are not unique keys: two different employees are named Jane Hill.
SELECT employee_name, COUNT(*) AS occurrences
FROM challenge_employees GROUP BY LOWER(TRIM(employee_name)) HAVING COUNT(*) > 1;

-- 3/4/6. Create cleaned data without altering the original.
-- SQLite has no dedicated DATE storage class: ISO YYYY-MM-DD text is SQLite's
-- recommended sortable date representation, validated with date().
-- Unknown department is an explicit category, not an inferred department.
DROP TABLE IF EXISTS cleaned_employees;
CREATE TABLE cleaned_employees (
    employee_id INTEGER PRIMARY KEY,
    employee_name TEXT NOT NULL,
    salary NUMERIC NOT NULL CHECK (salary >= 0),
    hire_date TEXT NOT NULL CHECK (hire_date GLOB '????-??-??' AND date(hire_date) IS NOT NULL),
    department TEXT NOT NULL
);
INSERT INTO cleaned_employees (employee_id, employee_name, salary, hire_date, department)
SELECT employee_id,
       UPPER(SUBSTR(TRIM(employee_name),1,1)) || LOWER(SUBSTR(TRIM(employee_name),2,INSTR(TRIM(employee_name),' ')-2)) ||
       ' ' || UPPER(SUBSTR(TRIM(employee_name),INSTR(TRIM(employee_name),' ')+1,1)) ||
       LOWER(SUBSTR(TRIM(employee_name),INSTR(TRIM(employee_name),' ')+2)) AS employee_name,
       CAST(salary AS NUMERIC),
       date(TRIM(hire_date)),
       COALESCE(NULLIF(TRIM(department),''),'Unknown')
FROM challenge_employees;

-- 5. Outlier assessment using Tukey's 1.5 * IQR rule.
-- Compute quartiles using ordered positions (nearest-rank approximation).
WITH ranked AS (
 SELECT salary, ROW_NUMBER() OVER (ORDER BY salary) AS rn,
        COUNT(*) OVER () AS n FROM cleaned_employees
), quartiles AS (
 SELECT MAX(CASE WHEN rn = CAST((n+3)/4 AS INTEGER) THEN salary END) AS q1,
        MAX(CASE WHEN rn = CAST((3*n+3)/4 AS INTEGER) THEN salary END) AS q3
 FROM ranked
), bounds AS (
 SELECT q1, q3, q1-1.5*(q3-q1) AS lower_bound,
        q3+1.5*(q3-q1) AS upper_bound FROM quartiles
)
SELECT e.employee_id, e.employee_name, e.salary,
       ROUND(b.lower_bound,2) AS lower_bound,
       ROUND(b.upper_bound,2) AS upper_bound
FROM cleaned_employees e CROSS JOIN bounds b
WHERE e.salary < b.lower_bound OR e.salary > b.upper_bound;
-- Outliers are flagged, not deleted, absent evidence they are errors.

-- Final validation
SELECT COUNT(*) AS cleaned_rows,
       COUNT(DISTINCT employee_id) AS unique_employee_ids,
       SUM(CASE WHEN department = 'Unknown' THEN 1 ELSE 0 END) AS unknown_departments,
       MIN(salary) AS minimum_salary, MAX(salary) AS maximum_salary
FROM cleaned_employees;
SELECT * FROM cleaned_employees ORDER BY employee_id;
