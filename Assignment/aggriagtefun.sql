SELECT * FROM hr.employees



--1.Select sum of all salaries from employees table

SELECT SUM(salary) 
FROM hr.employees

--2.Select avg of all salaries from employees table
SELECT ROUND(AVG(salary),2)
FROM hr.employees

--3.count total no of employees in employees table
SELECT COUNT(*) FROM hr.employees

--4.Select avg of  salary department wise from employees table
SELECT department_id,
       AVG(salary)
FROM hr.employees
GROUP BY department_id;

--5.department wise sum of salaries

SELECT department_id,
       SUM(salary) AS total_salary
FROM hr.employees
GROUP BY department_id
ORDER BY total_salary DESC

--6.deparment wise max salary

SELECT department_id,
       MAX(salary) AS max_salary
FROM hr.employees
GROUP BY department_id
ORDER BY max_salary DESC


SELECT emp_id, salary FROM hr.employees
WHERE salary = (SELECT MAX(salary) FROM hr.employees);

--7.deparment wise min salary

SELECT department_id,
       MIN(salary) AS min_salary
FROM hr.employees
GROUP BY department_id
ORDER BY min_salary DESC

-- 8.no of employees in each department

SELECT nvl(department_id,0) AS dept_id ,
       COUNT(*) AS total_emp
FROM hr.employees
GROUP BY department_id
ORDER BY total_emp DESC;

--9.select all departments who's having no of emp > 5.

SELECT department_id ,
       COUNT(*) AS total_emp
FROM hr.employees
GROUP BY department_id
HAVING COUNT(*) > 5
ORDER BY total_emp DESC;

--10. how to find duplicates of first name

SELECT first_name, COUNT(*)
FROM hr.employees
GROUP BY first_name
HAVING COUNT(*) > 1 ;

SELECT emp_id, COUNT(*)
FROM hr.employees
GROUP BY emp_id
HAVING COUNT(*) > 1;

--11. count no of employees who's salary is greater than 2000
SELECT COUNT(*) FROM hr.employees
WHERE salary > 2000;

--12.2nd highest salary

SELECT MAX(salary) FROM hr.employees 
WHERE salary < (SELECT MAX(salary) FROM hr.employees)

--13. use nvl function on commission_pct column

SELECT emp_id,
salary,
commission_pct,
NVL(commission_pct,0)
FROM hr.employees;

--14. use nvl2 function on commission_pct column

SELECT emp_id,
salary,
commission_pct,
NVL2(commission_pct,0,0.5)
FROM hr.employees;

--15. select department id, whos sum of salary greater than 5000 and department id is greater than equal to 100
SELECT DEPARTMENT_ID,SUM(SALARY)
FROM HR.employees
where DEPARTMENT_ID >= 100
group by DEPARTMENT_ID
having SUM(SALARY) > 5000;

SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, DATE '1996-12-22') / 12) AS age
FROM dual;

SELECT SYSDATE - TO_date('22-12-1996','DD-MM-YYYY') AS days,
extract(YEAR FROM(SYSDATE - TO_date('22-12-1996','DD-MM-YYYY'))) FROM DUAL;

--16.Find departments where average salary > 8000
SELECT department_id,
       round(AVG(salary),2) AS avg_salary
FROM hr.employees
GROUP BY department_id
HAVING ROUND(AVG(salary),2) > 8000;

--17. Find job_id with highest total salary
SELECT job_id, SUM(salary)
FROM hr.employees
GROUP BY job_id
HAVING sum(salary) = (SELECT MAX(SUM_salary)  --sum of salary should be comapred with 
                      FROM(SELECT SUM(salary) AS SUM_salary
                            FROM hr.employees
                             GROUP BY job_id));

SELECT job_id, total_salary
FROM (SELECT job_id,
           SUM(salary) AS total_salary,
           RANK() OVER (ORDER BY SUM(salary) DESC) AS rnk
           FROM hr.employees
           GROUP BY job_id )
WHERE rnk = 1;

SELECT job_id, total_sal
FROM(SELECT job_id,
            SUM(salary) AS total_sal,
            RANK() OVER(ORDER BY SUM(salary) DESC) AS rnk
            FROM hr.employees
            GROUP BY job_id)
WHERE rnk = 1;
                 
--18.Find department with maximum employees

SELECT department_id, COUNT(*) AS employees
FROM hr.employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                   FROM hr.employees
                   GROUP BY department_id);

SELECT department_id,
       COUNT(*)               
FROM hr.employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MAX(count_emp)
                        FROM(SELECT COUNT(*) AS count_emp
                              FROM hr.employees
                              GROUP BY department_id));
SELECT department_id,
       COUNT(*) AS no_of_emp
FROM hr.employees
GROUP BY department_id
ORDER BY department_id ASC;
              
--19. Display department name with minimum salary employee

SELECT d.department_name,
       e.first_name,
       salary
FROM hr.departments d
JOIN hr.employees e
ON d.department_id = e.department_id
WHERE e.salary = ( SELECT MIN(salary) FROM hr.employees);


--20. Nth salary logic--- using window function
SELECT *FROM(
             SELECT first_name,salary,
             DENSE_RANK() OVER (ORDER BY salary DESC) rnk
             FROM hr.employees)
WHERE rnk = 1;


SELECT * FROM(SELECT salary,first_name,last_name,
              dense_rank () OVER(ORDER BY salary DESC) AS rnk
              FROM hr.employees)
WHERE rnk = 2;

---View (virtual representation of table, reusable, saves no data)

CREATE VIEW empl AS
SELECT emp_id,first_name,salary
FROM hr.employees;

SELECT * FROM empl;

--CTE common table expression!!(limited to query )

--Q. find customers whos sal is greater than avg sal from hr.employee using cte.

WITH avg_sal AS (SELECT AVG(salary) AS avg_salary
                FROM hr.employees)
SELECT e.* 
FROM hr.employees e
JOIN avg_sal a
ON e.salary > a.avg_salary;

--find the total sum of customers spent.

WITH cust_total AS (
                    SELECT cid, trim(SUM(total)) AS total_spent
                    FROM ser_det
                    GROUP BY cid)
SELECT total_spent FROM cust_total;

