-- Create Database Employee
create database employee;
use employee;
/* 3.Write a query to fetch
 EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT 
 from the employee record table, and make a list of employees 
 and details of their department. */
 SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM
    emp_record_table;
  /*
4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
●	less than two
●	greater than four 
●	between two and four
*/  
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM  emp_record_table
WHERE EMP_RATING < 2;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING > 4;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING between 2 and 4;
/* 5.	Write a query to concatenate 
the FIRST_NAME and the LAST_NAME of employees 
in the Finance department from the employee table and then give
 the resultant column alias as NAME. */
 select concat(FIRST_NAME,' ',LAST_NAME)as NAME 
 from emp_record_table where DEPT="Finance" ;
 /* 6.	Write a query to list only those employees 
 who have someone reporting to them. 
 Also, show the number of reporters (including the President).
 */
 SELECT
    m.EMP_ID,
    m.FIRST_NAME,
    m.LAST_NAME,
    COUNT(e.EMP_ID) AS total_reporters
FROM emp_record_table m
JOIN emp_record_table e
    ON m.EMP_ID = e.MANAGER_ID
GROUP BY m.EMP_ID, m.FIRST_NAME, m.LAST_NAME
ORDER BY total_reporters DESC;
 
  /* 7.	Write a query to list down all the employees 
 from the healthcare and finance departments using union. 
 Take data from the employee record table. */
 select * from emp_record_table where dept="Healthcare"
 union
 select * from emp_record_table where dept="Finance";
  /* 8.	Write a query to list down 
 employee details such as EMP_ID, FIRST_NAME, LAST_NAME, 
 ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
 Also include the respective employee 
 rating along with the max emp rating for the department. */
  select EMP_ID,FIRST_NAME,LAST_NAME,
  ROLE,DEPT,EMP_RATING, max(emp_rating) 
  over(partition by dept) as Max_Rating 
  from emp_record_table;
   /* 9.	Write a query to calculate 
 the minimum and the maximum salary of the employees in each role. 
 Take data from the employee record table.*/
 select role,min(salary),max(salary)
 from emp_record_table group by role;
 /* 10.	Write a query to assign ranks to each employee 
 based on their experience. 
 Take data from the employee record table. */
select *,rank() over(order by exp desc) as rnk 
 from emp_record_table;
 /* 11.	Write a query to create a view that 
 displays employees in various countries 
 whose salary is more than six thousand. 
 Take data from the employee record table.*/
 create view var_country as (select * from emp_record_table
 where salary>6000);
select * from var_country; 
  /*12.	Write a nested query to find employees with 
 experience of more than ten years. 
 Take data from the employee record table.*/
 select * from emp_record_table where EMP_ID in
 (select EMP_ID from emp_record_table
 where EXP>10);
 /* 13.	Write a query to create a stored procedure to 
 retrieve the details of the employees 
 whose experience is more than three years. 
 Take data from the employee record table. */
 DROP PROCEDURE IF EXISTS emp_exp;

DELIMITER //

CREATE PROCEDURE emp_exp()
BEGIN
    SELECT *
    FROM employee.emp_record_table
    WHERE EXP > 3;
END //

DELIMITER ;

CALL employee.emp_exp();
  /* 14.	Write a query using stored procedure in the project table to check
  whether the job profile assigned to each employee in the data science team 
  matches the organization’s set standard.
  The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.
*/
DROP PROCEDURE IF EXISTS verify_job_profile;
DELIMITER //
CREATE PROCEDURE verify_job_profile()
BEGIN
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    EXP,
    ROLE AS actual_role,
    CASE
        WHEN EXP <= 2 THEN 'Junior Data Scientist'
        WHEN EXP <= 5 THEN 'Associate Data Scientist'
        WHEN EXP <= 10 THEN 'Senior Data Scientist'
        WHEN EXP <= 12 THEN 'Lead Data Scientist'
        WHEN EXP <= 16 THEN 'Manager'
        ELSE 'Outside Defined Range'
    END AS expected_role,
    CASE
        WHEN EXP < 0 OR EXP IS NULL THEN 'NOT MATCHED'
        WHEN EXP <= 2 AND UPPER(TRIM(ROLE)) = 'JUNIOR DATA SCIENTIST' THEN 'MATCHED'
        WHEN EXP > 2 AND EXP <= 5 AND UPPER(TRIM(ROLE)) = 'ASSOCIATE DATA SCIENTIST' THEN 'MATCHED'
        WHEN EXP > 5 AND EXP <= 10 AND UPPER(TRIM(ROLE)) = 'SENIOR DATA SCIENTIST' THEN 'MATCHED'
        WHEN EXP > 10 AND EXP <= 12 AND UPPER(TRIM(ROLE)) = 'LEAD DATA SCIENTIST' THEN 'MATCHED'
        WHEN EXP > 12 AND EXP <= 16 AND UPPER(TRIM(ROLE)) = 'MANAGER' THEN 'MATCHED'
        ELSE 'NOT MATCHED'
    END AS job_status
FROM employee.data_science_team;
END //

DELIMITER ;

CALL employee.verify_job_profile();

/* 15.	Create an index to improve the 
cost and performance of the query to find the employee 
whose FIRST_NAME is ‘Eric’ 
in the employee table after checking the execution plan. */
describe emp_record_table;
alter table emp_record_table
 modify column first_name varchar(50);
 create index id_first_name on emp_record_table(first_name);
 show indexes from emp_record_table;
 EXPLAIN
SELECT *
FROM employee.emp_record_table
WHERE FIRST_NAME = 'Eric';
/*16. Write a query to calculate the bonus for all the employees, 
based on their ratings and salaries (Use the formula: 5% of salary * employee rating */
select *, (0.05*salary*EMP_RATING) 
as bonus from emp_record_table;
/*17. Write a query to calculate the average salary distribution based on the 
continent and country. Take data from the employee record table.*/
select * from emp_record_table;
select continent,country,round( AVG(salary),2)as Averege_salary
from  emp_record_table
group by continent,country
order by continent,country;


 
 
 
 
