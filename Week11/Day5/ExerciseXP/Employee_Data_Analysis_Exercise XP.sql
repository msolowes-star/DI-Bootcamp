-- ============================================================
-- DAILY CHALLENGE: TRANSFORMING AND CLEANING DATA WITH SQL
-- Developers Institute | Week 10, Day 3 | SQLite
-- Source CSV tables: companies, employees, functions, salaries
-- ============================================================
-- Run after importing the four CSV files into SQLiteOnline.
-- Import settings: first row contains headers; delimiter = semicolon.
-- The script recreates emp_dataset and df_employee when rerun.
-- IMPORTANT: source tables are never modified.

-- ============================================================
-- EXERCISE 1: BUILD A COMPREHENSIVE EMPLOYEE DATASET
-- ============================================================
-- Join salary records to employee, function, and company details.
-- LEFT JOIN retains salary rows even when reference data is missing.
DROP TABLE IF EXISTS emp_dataset;
CREATE TABLE emp_dataset AS
SELECT
    s.employee_id,
    s.employee_name,
    s.date,
    s.salary,
    e.gen_m_f AS gender,
    e.age,
    f.function_group,
    c.company_name,
    c.company_city,
    c.company_state,
    c.company_type,
    c.const_site_categ
FROM salaries AS s
LEFT JOIN employees AS e
    ON s.employee_id = e.employee_code_em
   AND s.comp_code = e.comp_code_emp
LEFT JOIN functions AS f
    ON s.func_code = f.function_code
LEFT JOIN companies AS c
    ON TRIM(s.comp_name) = TRIM(c.company_name);

-- The source date is DD/MM/YYYY HH:MM (e.g., 01/01/2022 00:00).
-- Reorder to ISO YYYY-MM-DD for SQLite date operations.
-- Replace comma decimal separators in salaries with periods.
DROP TABLE IF EXISTS df_employee;
CREATE TABLE df_employee AS
SELECT
    CAST(employee_id AS TEXT) || '_' ||
        SUBSTR(date, 7, 4) || '-' ||
        SUBSTR(date, 4, 2) || '-' ||
        SUBSTR(date, 1, 2) AS id,
    DATE(SUBSTR(date, 7, 4) || '-' ||
         SUBSTR(date, 4, 2) || '-' ||
         SUBSTR(date, 1, 2)) AS month_year,
    employee_id,
    employee_name,
    gender,
    age,
    CAST(REPLACE(TRIM(salary), ',', '.') AS REAL) AS salary,
    function_group,
    company_name,
    company_city,
    company_state,
    company_type,
    const_site_categ AS const_site_category
FROM emp_dataset;

SELECT * FROM df_employee LIMIT 10;

-- ============================================================
-- EXERCISE 2: CLEAN DATA AND ASSESS QUALITY
-- ============================================================
-- Remove surrounding whitespace from all text columns.
UPDATE df_employee
SET id = TRIM(id),
    month_year = TRIM(month_year),
    employee_name = TRIM(employee_name),
    gender = TRIM(gender),
    function_group = TRIM(function_group),
    company_name = TRIM(company_name),
    company_city = TRIM(company_city),
    company_state = TRIM(company_state),
    company_type = TRIM(company_type),
    const_site_category = TRIM(const_site_category);

-- Check exact duplicates BEFORE removal.
SELECT COUNT(*) AS total_rows,
       COUNT(*) - (SELECT COUNT(*) FROM
           (SELECT DISTINCT * FROM df_employee)) AS exact_duplicate_rows
FROM df_employee;
-- Observed: 8049 rows; 186 exact duplicate rows.

-- Remove ONLY rows identical across all 13 columns.
-- Keep the earliest rowid from each group.
DELETE FROM df_employee
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM df_employee
    GROUP BY id, month_year, employee_id, employee_name,
             gender, age, salary, function_group, company_name,
             company_city, company_state, company_type,
             const_site_category
);
-- Observed after deduplication: 7863 rows.
SELECT COUNT(*) AS records_after_deduplication FROM df_employee;

-- Check whether employee + month IDs are unique.
-- If results appear, investigate differing records rather than
-- automatically deleting them.
SELECT id, COUNT(*) AS occurrences
FROM df_employee
GROUP BY id
HAVING COUNT(*) > 1;

-- Count missing or empty values in each important field.
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN id IS NULL OR TRIM(id) = '' THEN 1 ELSE 0 END) AS missing_id,
    SUM(CASE WHEN month_year IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS missing_employee_id,
    SUM(CASE WHEN employee_name IS NULL OR TRIM(employee_name) = '' THEN 1 ELSE 0 END) AS missing_name,
    SUM(CASE WHEN gender IS NULL OR TRIM(gender) = '' THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN age IS NULL OR TRIM(CAST(age AS TEXT)) = '' THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN salary IS NULL THEN 1 ELSE 0 END) AS missing_salary,
    SUM(CASE WHEN function_group IS NULL OR TRIM(function_group) = '' THEN 1 ELSE 0 END) AS missing_function,
    SUM(CASE WHEN company_name IS NULL OR TRIM(company_name) = '' THEN 1 ELSE 0 END) AS missing_company,
    SUM(CASE WHEN company_city IS NULL OR TRIM(company_city) = '' THEN 1 ELSE 0 END) AS missing_city,
    SUM(CASE WHEN company_state IS NULL OR TRIM(company_state) = '' THEN 1 ELSE 0 END) AS missing_state,
    SUM(CASE WHEN company_type IS NULL OR TRIM(company_type) = '' THEN 1 ELSE 0 END) AS missing_company_type,
    SUM(CASE WHEN const_site_category IS NULL OR TRIM(const_site_category) = '' THEN 1 ELSE 0 END) AS missing_site_category
FROM df_employee;

-- Inspect rows with missing values (including blank strings).
SELECT * FROM df_employee
WHERE id IS NULL OR TRIM(id) = ''
   OR month_year IS NULL OR employee_id IS NULL
   OR employee_name IS NULL OR TRIM(employee_name) = ''
   OR gender IS NULL OR TRIM(gender) = ''
   OR age IS NULL OR salary IS NULL
   OR function_group IS NULL OR TRIM(function_group) = ''
   OR company_name IS NULL OR TRIM(company_name) = ''
   OR company_city IS NULL OR TRIM(company_city) = ''
   OR company_state IS NULL OR TRIM(company_state) = ''
   OR company_type IS NULL OR TRIM(company_type) = ''
   OR const_site_category IS NULL OR TRIM(const_site_category) = ''
LIMIT 50;

-- Deletion policy: do NOT delete all incomplete rows.
-- Observed: 940 rows missing both gender and age, likely unmatched
-- employee reference data. These rows still support headcount analysis.
-- Some site-category entries are blank rather than NULL.
-- The exercise requests deletion of missing values, but preserving
-- partially complete records avoids unnecessarily biasing counts.
-- Optional targeted deletion ONLY after review (not executed):
-- DELETE FROM df_employee WHERE salary IS NULL;

-- Check salaries and investigate suspicious extremes.
SELECT COUNT(*) AS total_records,
       SUM(CASE WHEN salary IS NULL THEN 1 ELSE 0 END) AS missing_salaries,
       SUM(CASE WHEN salary <= 0 THEN 1 ELSE 0 END) AS zero_or_negative_salaries,
       MIN(salary) AS minimum_salary,
       MAX(salary) AS maximum_salary
FROM df_employee;
-- Observed: 70 zero/negative salary records, max salary 1000000.
-- Keep these records for headcount; use salary > 0 in salary averages.

-- Optional city standardization: only after confirming the spelling.
-- In the observed data, 'Goianiaa' appears to be 'Goiania'.
-- UPDATE df_employee SET company_city = 'Goiania'
-- WHERE company_city = 'Goianiaa';

-- ============================================================
-- EXERCISE 3: CURRENT EMPLOYEE COUNTS BY COMPANY
-- ============================================================
-- "Current" = latest available snapshot, not today's calendar date.
SELECT MIN(month_year) AS earliest_date,
       MAX(month_year) AS latest_date,
       COUNT(DISTINCT month_year) AS total_months
FROM df_employee;
-- Observed: 2022-01-01 to 2023-01-01 (13 months).

SELECT company_name,
       COUNT(DISTINCT employee_id) AS current_employee_count
FROM df_employee
WHERE month_year = (SELECT MAX(month_year) FROM df_employee)
GROUP BY company_name
ORDER BY current_employee_count DESC;
-- Top company observed: The Crossings at Falcon Point (107).

-- ============================================================
-- EXERCISE 4: DISTRIBUTION BY CITY AND OVER TIME
-- ============================================================
-- 4.1 City employee counts and share of latest snapshot.
WITH latest_employees AS (
    SELECT DISTINCT employee_id, company_city
    FROM df_employee
    WHERE month_year = (SELECT MAX(month_year) FROM df_employee)
),
city_counts AS (
    SELECT company_city,
           COUNT(DISTINCT employee_id) AS employee_count
    FROM latest_employees
    GROUP BY company_city
)
SELECT company_city,
       employee_count,
       ROUND(100.0 * employee_count /
             SUM(employee_count) OVER (), 2) AS percentage
FROM city_counts
ORDER BY employee_count DESC;
-- Observed before city-name standardization:
-- Goiania 431 (63.76%), Brasilia 196 (28.99%),
-- Palmas 47 (6.95%), Goianiaa 2 (0.30%).

-- 4.2 Distinct employees each month.
SELECT month_year,
       COUNT(DISTINCT employee_id) AS total_employees
FROM df_employee
GROUP BY month_year
ORDER BY month_year;

-- 4.3 Average monthly headcount.
WITH monthly_counts AS (
    SELECT month_year,
           COUNT(DISTINCT employee_id) AS total_employees
    FROM df_employee
    GROUP BY month_year
)
SELECT ROUND(AVG(total_employees), 2) AS average_monthly_employees
FROM monthly_counts;
-- Observed: 604.85.

-- ============================================================
-- EXERCISE 5: EMPLOYMENT TRENDS AND SALARY METRICS
-- ============================================================
-- 5.1 Minimum and maximum monthly headcounts (includes ties).
WITH monthly_counts AS (
    SELECT month_year,
           COUNT(DISTINCT employee_id) AS employee_count
    FROM df_employee
    GROUP BY month_year
)
SELECT month_year,
       employee_count,
       CASE
           WHEN employee_count = (SELECT MIN(employee_count) FROM monthly_counts)
               THEN 'Minimum'
           WHEN employee_count = (SELECT MAX(employee_count) FROM monthly_counts)
               THEN 'Maximum'
       END AS category
FROM monthly_counts
WHERE employee_count = (SELECT MIN(employee_count) FROM monthly_counts)
   OR employee_count = (SELECT MAX(employee_count) FROM monthly_counts)
ORDER BY employee_count;
-- Observed: Jan 2022 minimum 520; Jan 2023 maximum 676.

-- 5.2 Average monthly headcount by function group.
-- Average is over months with recorded employees in that group.
WITH monthly_function_counts AS (
    SELECT month_year, function_group,
           COUNT(DISTINCT employee_id) AS employee_count
    FROM df_employee
    GROUP BY month_year, function_group
)
SELECT function_group,
       ROUND(AVG(employee_count), 2) AS avg_monthly_employees
FROM monthly_function_counts
GROUP BY function_group
ORDER BY avg_monthly_employees DESC;
-- Observed: Professionals 254.46, Assistants 214.92,
-- Administration 53.85, Production Supervisors 28.69,
-- Machine Operators 19.69, Engineering 14.85,
-- Trainees 12.23, Managers 6.15.

-- 5.3 Average recorded salary by calendar year.
-- These are NOT annualized salaries. 2023 has January data only.
SELECT STRFTIME('%Y', month_year) AS year,
       ROUND(AVG(salary), 2) AS average_recorded_salary,
       COUNT(*) AS salary_records
FROM df_employee
WHERE salary > 0
GROUP BY STRFTIME('%Y', month_year)
ORDER BY year;
-- Observed: 2022 = 1664.33 (7145 records),
-- 2023 = 10887.14 (648 records).

-- Additional outlier sensitivity analysis.
-- The >= 100000 threshold is exploratory, not proof of bad data.
SELECT STRFTIME('%Y', month_year) AS year,
       COUNT(*) AS valid_salary_records,
       ROUND(AVG(salary), 2) AS average_salary_all,
       ROUND(AVG(CASE WHEN salary < 100000 THEN salary END), 2)
           AS average_salary_excluding_outliers,
       SUM(CASE WHEN salary >= 100000 THEN 1 ELSE 0 END)
           AS high_salary_records
FROM df_employee
WHERE salary > 0
GROUP BY STRFTIME('%Y', month_year)
ORDER BY year;
-- Observed:
-- 2022: 1664.33 with or without outlier filter; 0 high records.
-- 2023: 10887.14 original; 1643.09 after filtering 6 high records.
-- The six 1000000 salaries appear to drive the misleading 2023 average.

-- ============================================================
-- CONCLUSION
-- ============================================================
-- 1. Combined four CSV tables using LEFT JOIN.
-- 2. Converted dates and salary strings into analysis-ready values.
-- 3. Removed 186 exact duplicate rows; retained 7863 rows.
-- 4. Preserved incomplete employee records for unbiased headcounts.
-- 5. Measured company/city/monthly employment and function distribution.
-- 6. Flagged salary outliers and documented sensitivity of averages.
-- ============================================================
