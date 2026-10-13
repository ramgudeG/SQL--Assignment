--Q1: Write a query to display the Full name only those employees whose first name start with ‘S’ character.

SELECT emp_id,(substr(first_name,1,1))||'.'||last_name Full_Name,salary,hire_date
FROM hr.employees
WHERE first_name like 'S%';

--Q2. Find the highest, lowest, sum, and average salary of all employees. Label the columns Maximum
--,Minimum, Sum, and Average, respectively. Round your results to the nearest whole number. 

SELECT round(max(salary)) max_highest,
       round(min(salary)) lowest,
       round(sum(salary)) SUM_sal,
       round(avg(salary)) avg_sal
FROM hr.employees;

--Q3. Display following output .
Employee Details
--------------------------------------------------------------------------------------
King earns $24,000.00 monthly but wants $72,000.00.
Kochhar earns $20,000.00 monthly but wants $60,000.00.
De Haan earns $17,000.00 monthly but wants $51,000.00.
Hunold earns $9,000.00 monthly but wants $27,000.00.
Ernst earns $6,000.00 monthly but wants $18,000.00.
Austin earns $4,800.00 monthly but wants $14,400.00.

SELECT last_name||' '||'earns'||to_char(salary,'$99999.00')||' '||'but wants'||' '||
(to_char(salary*3,'$99999.00'))
FROM hr.employees;
--99999 is a format model, not a value.“How many digits should I reserve space for when displaying the number.”

--Q4. Determine the number of managers without listing them. Label the column  Number of Managers Hint: Use the MANAGER_ID column to determine the number of managers. 
SELECT COUNT(manager_id) number_of_managers
FROM hr.employees;

--Q5. Find the difference between the highest and lowest salaries. Label the column DIFFERENCE
SELECT max(salary) - min(salary) difference
FROM hr.employees;

--Q6. Display how many employees joined in each month
Hint: Grouping by month and count the employees .use TO_CHAR functions also

SELECT to_char(hire_date,'Month')month, COUNT(emp_id)
FROM hr.employees
GROUP BY to_char(hire_date,'Month')
ORDER BY month;

--Q7. Display employee id , full name of employees and their hire date only those 
--employees that has greater than 10 year experience in company.

SELECT emp_id,first_name||' '||last_name Full_name,hire_date
FROM hr.employees
WHERE (to_char(hire_date) < SYSDATE - 365*10);

SELECT 'My age is' || (SYSDATE - to_date('01-01-1997','dd-mm-yyyy'))|| 'days' 
FROM dual;

SELECT 'My age is ' || (SYSDATE - TO_DATE('01-01-1997','DD-MM-YYYY')) || ' days'
FROM dual;

SELECT 'My age is ' ||
       FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE('01-01-1997','DD-MM-YYYY')) / 12)
       || ' years'
FROM dual;

--Q8. Write a query to multipley  salary to commission and calculate the average salary of employees.

SELECT AVG(salary * NVL(commission_pct,1)) FROM hr.employees

--Q9.Write a query to display department_id and number of manager under the 
--particular department exclude the null department.

SELECT department_id,
       count(manager_id)
FROM hr.departments
WHERE department_id IS NOT NULL
group by department_id;


--Q10.Display job title and number of employees working those job and number of 
--manager they perform job.

SELECT COUNT(emp_id),
       COUNT(manager_id),j.job_title
FROM hr.employees e, hr.jobs j
WHERE e.job_id = j.job_id 
AND  manager_id IS NOT NULL
GROUP BY j.job_title;

--Q11. Display employee full name and pad both side asterisk sing 10 time . Example 

SELECT 
  RPAD(LPAD(first_name || ' ' || last_name,
           LENGTH(first_name || ' ' || last_name) + 10, '*'),
      LENGTH(first_name || ' ' || last_name) + 20,'*' ) AS padded_full_name
FROM hr.employees;

--Q12. Display following output. (Hint: Use Months_between Function)
--Employee Id Last _name  Weeks Months  Year

SELECT emp_id,last_name,
       hire_date,
       ROUND(months_between(sysdate,hire_date)/7) weeks,
       ROUND(months_between(sysdate,hire_date)) MONTHS,
       ROUND(months_between(sysdate,hire_date)/12) years
FROM hr.employees;


                               --Assignment 5--
                               ----------------
--Q1. Write a query to generate following output.
--Employee_id Full_Name Email Salary

SELECT emp_id,
       first_name||' '||last_name AS Full_name,
       email,
       salary
FROM hr.employees;

--Q2.Write a query to display job_id and number of manager under particular job. 
--Show only those jobs that have more than one manager.

SELECT job_id,
       COUNT(manager_id)
FROM hr.employees 
GROUP BY job_id
HAVING COUNT(manager_id) > 1;

--Q3. Display the country name and number of employees those working in particular
-- city that count of employee is greater than 30.
(Hint: Using Equijoin and Group by )

SELECT COUNT(emp_id) AS employee_count,
       c.country_name
FROM hr.employees e, hr.departments d, hr.locations l, hr.countries c
WHERE e.department_id = d.department_id 
AND d.location_id = l.location_id
AND l.country_id = c.country_id
GROUP BY  c.country_name
HAVING COUNT(emp_id) > 30;

--Q4. Display cities name and number of departments present those cities. And exculde departments there are no any employees.

SELECT l.city,
       COUNT(d.department_id)
from HR.employees e, hr.departments d, hr.locations l
WHERE e.department_id = d.department_id 
AND d.location_id = l.location_id
AND emp_id IS NOT NULL
GROUP BY l.city

--Q5. Display the salary range and number of employees how are salary in 
--between of range. 

SELECT emp_id,salary,
      CASE 
       WHEN salary >= 20000 THEN 'HIGH SALARY'
            WHEN SAlary >= 15000 THEN 'MEDIUM SALARY'
                 ELSE 'LOW SALARY'
                      END AS RESULT
FROM hr.employees
      


--Q6. Display Year list and number of Employees join in particular year.
(Hint: Group by and To_Char Function)

SELECT to_char(hire_date,'YYYY'),
       COUNT(emp_id)
FROM hr.employees
GROUP BY to_char(hire_date,'YYYY')
ORDER BY 1;


SELECT to_char(hire_date,'MM'),
      COUNT(emp_id)
FROM hr.employees
GROUP BY to_char(hire_date,'MM')
ORDER BY 1;

--Q7. Display Manager_id , Manager Full Name and Under number of employees 
--only those managers how have more than 5 employees under working.
-- Result sort by manager_ID

SELECT m.emp_id AS manager_id,
       m.first_name||' '||m.last_name AS full_name, 
       COUNT(e.emp_id) AS no_of_emloyees
FROM hr.employees e
JOIN hr.employees m
ON e.manager_id = m.emp_id
GROUP BY m.emp_id, m.first_name , m.last_name 
HAVING COUNT(e.emp_id) > 5
ORDER BY manager_id;
