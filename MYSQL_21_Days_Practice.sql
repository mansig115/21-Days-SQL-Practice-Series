SELECT * FROM practice.employees;
Update Employees SET ManagerID=2 where EmpID=1;

SELECT * FROM practice.projects;

-- LEFT JOIN
-- 1
SELECT E.Name, D.DeptName 
FROM Employees E 
LEFT JOIN Departments D ON E.DeptID = D.DeptID;

-- 2
SELECT D.DeptName, E.Name 
FROM Departments D 
LEFT JOIN Employees E ON D.DeptID = E.DeptID;

-- 3
SELECT E.Name, P.ProjName 
FROM Employees E 
LEFT JOIN Projects P ON E.DeptID = P.DeptID;

-- 4
SELECT P.ProjName, E.Name 
FROM Projects P 
LEFT JOIN Employees E ON P.DeptID = E.DeptID;


-- 5
SELECT D.DeptID, D.DeptName, COUNT(E.EmpID) AS no_of_employees 
FROM Departments D 
LEFT JOIN Employees E ON D.DeptID = E.DeptID
GROUP BY D.DeptID, D.DeptName;

-- 6
SELECT D.DeptID, D.DeptName, COUNT(E.EmpID) AS no_of_employees 
FROM Departments D 
LEFT JOIN Employees E ON D.DeptID = E.DeptID
GROUP BY D.DeptID, D.DeptName 
HAVING COUNT(E.EmpID) > 2;




-- RIGHT JOIN

-- 1
SELECT E.Name, D.DeptName 
FROM Employees E 
RIGHT JOIN Departments D ON E.DeptID = D.DeptID;

-- 2
SELECT E.Name, P.ProjName 
FROM Employees E 
RIGHT JOIN Projects P ON P.DeptID = E.DeptID;
 
 
 -- 3
 SELECT D.DeptID, D.DeptName, ROUND(AVG(E.Salary),2) AS avg_salary 
FROM Departments D 
RIGHT JOIN Employees E ON D.DeptID = E.DeptID
GROUP BY D.DeptID, D.DeptName
HAVING AVG(E.Salary) > 60000;
 
 
 -- 4
SELECT D.DeptID, D.DeptName, COALESCE(SUM(E.Salary),0) AS total_salary 
FROM Employees E 
RIGHT JOIN Departments D ON E.DeptID = D.DeptID
GROUP BY D.DeptID, D.DeptName 
HAVING SUM(E.Salary) > 200000;




-- 5
SELECT D.DeptID, D.DeptName, COALESCE(MAX(E.Salary),0) AS Highest_Salary_Department 
FROM Employees E 
RIGHT JOIN Departments D ON E.DeptID = D.DeptID
GROUP BY D.DeptID, D.DeptName;


-- Cross JOIN
-- 1
Select * from Employees CROSS JOIN Departments;

-- 2
Select * from Employees CROSS JOIN Projects;

-- 3
SELECT * 
FROM Departments 
CROSS JOIN Projects;



-- 4
SELECT E1.EmpID AS E1_EmpID, E1.Name  AS E1_Name, 
E2.EmpID AS E2_EmpID, 
E2.Name  AS E2_Name
FROM Employees E1
CROSS JOIN Employees E2
WHERE E1.EmpID < E2.EmpID;

-- Natural JOIN
-- 1
SELECT EmpID, Name, DeptName 
FROM Employees 
NATURAL JOIN Departments;


-- 2
SELECT EmpID, Name, ProjName 
FROM Employees 
NATURAL JOIN Projects;




-- SUBQUERY

SELECT * FROM practice.employees;



-- 1
SELECT EmpID, Name
FROM Employees 
WHERE Salary > (SELECT AVG(Salary) AS avg_salary FROM Employees);





-- 2
SELECT D.DeptName 
FROM Departments D
WHERE D.DeptID = (
    SELECT DeptID
    FROM Employees 
    GROUP BY DeptID
    ORDER BY COUNT(EmpID) DESC
    LIMIT 1
);

-- 3
Select EmpID, Name, Salary from Employees  where Salary = 
(Select MIN(Salary) from Employees);

-- 4
Select EmpID, Name from Employees where DeptID IN (
Select DeptID From Employees where Name IN ('David','Frank'));

-- 5
Select EmpID, Name, Salary from Employees where Salary = 
ANY  (Select MIN(Salary) from Employees Group by DeptID);

-- CTE with windows function
-- 1 Q1. Rank employees by salary within each department.
With DeptRank AS (
Select  EmpID, Name, DeptID, Salary, RANK() over(partition by DeptID order by salary desc) 
as SalaryRank from Employees)
Select * from DeptRank;

-- 2 Find the top 2 highest paid employees in each department.
With top_2_highest AS (
Select EmpId, Name, DeptID, Salary, row_number() over (partition by DeptID order by 
Salary DESC)
as Rownum from Employees)
Select * from top_2_highest where Rownum <=2;


-- 3 Show cumulative salary (running total) by department.
With RunningTotal AS(
Select EmpID, Name, DeptID, Salary , 
sum(Salary) over(partition by DeptID order by Salary desc) AS CumulativeSalary
From Employees)
Select * from RunningTotal; 

-- 4 Show average salary of each department and compare it with employee’s salary.
With Salary_Comparisons AS (
Select EmpId, Name, DeptID, Salary, avg(Salary) over (partition by DeptID) as
 Department_Salary from Employees)
 Select *, Salary - Department_Salary as DifferenceSalary
 from Salary_Comparisons;
 

 -- 5 Divide employees into 3 groups based on salary within each department. 
 With SalaryGroups AS (
 Select EmpID, Name, DeptID, Salary, 
 NTILE(3) over (partition by DeptID) as Departments_group from Employees)
 Select * from SalaryGroups;
 
-- 6 Find employees with the earliest joining date in each department.
With EarliestJoiningDate AS (
Select EmpID, Name, DeptID, JoiningDate, RANK() over(partition by DeptID order by
 JoiningDate ASC) 
as JoiningRank
from employees)
Select * from EarliestJoiningDate;


-- 7 Find the top 3 highest-paid employees across the entire company 
-- using a CTE and the DENSE_RANK() function.
With Top3HighestPaidEmp AS(
Select EmpID, Name, DeptID, Salary, dense_rank() over( order by 
Salary DESC) as SalaryRank from Employees)
Select EmpID, Name, Salary from Top3HighestPaidEmp where SalaryRank <=3;


SELECT * FROM practice.employees;

-- Example to get All Employees
call get_AllEmployees(80000);

-- IN Parameters
-- Q.1 Write a procedure to display all employees from a given department ID (passed as input).
call get_Employees_By_Dept(20);

-- Q.2 Write a procedure to display employees who joined after a given date.
call get_Joining_Date_Employees('2018-09-01');

-- Q.3 Write a procedure that takes employee ID as input and returns their salary as output.

CALL GetEmployeeCountByDept(30, @Count);
SELECT @Count AS TotalEmployeesInDept30;

-- Q.4 Write a procedure that returns the maximum salary among all employees
Call get_max_salary(20, @Salary);
Select @Salary as MaxSalaryInDept8;

SELECT DeptName FROM Departments WHERE DeptID = 20;


-- Functions
-- Q.1 Function to caculate yearly salary.
Select yearly_salary(75000) AS AnuualSalary;


-- Q.2 Function to get full name
Select get_full_name('Chandler','Bing') as FullName;


-- Creating Views
-- 1 Create a simple view to show employees with salary > 70000
Select * from HighSalaryEmployees;

-- 2 Create a view to display employees who belong to a given Department (say DeptID = 30).
Select * from Dept30Employees;

-- 3 Create a view to display employees who joined after '2018-01-01'.
Select * from JoinedAfter;

-- 4 Create a view to display each department with its total number of employees.
Select * from EmployeesDeptCount;

-- 5 Create a view to get the maximum salary in each department.
Select * from maxsalarydept;

-- 6 Create a view to display employees along with their department name (joining Employees & Departments).
Select * from employeeswithdept;










