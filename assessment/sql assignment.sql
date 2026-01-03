CREATE DATABASE DataScienceDB;
USE DataScienceDB;




CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT
);

CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(5,2)
);

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2)
);



CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);


CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    job_id VARCHAR(20),
    salary DECIMAL(10,2),
    commission_pct DECIMAL(5,2),
    manager_id INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


INSERT INTO salesman VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5007, 'Paul Adam', 'Rome', 0.13);


INSERT INTO customers VALUES
(3001, 'Brad Guzan', 'London', 100, 5005),
(3002, 'Nick Rimando', 'New York', 200, 5001),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3006, 'Julian Green', 'New York', 100, 5001),
(3007, 'Geoff Cameron', 'Berlin', NULL, 5005);


INSERT INTO orders VALUES
(70001, 150.50, '2023-10-05', 3005, 5002),
(70002, 2700.65, '2023-10-05', 3001, 5005),
(70003, 5760.00, '2023-10-06', 3002, 5001),
(70004, 3000.00, '2023-10-06', 3004, 5006),
(70005, 7200.00, '2023-10-07', 3003, 5007);


INSERT INTO products VALUES
(1, 'Laptop', 55000),
(2, 'Mobile', 25000),
(3, 'Tablet', 18000),
(4, 'Monitor', 12000),
(5, 'Keyboard', 1500);


INSERT INTO departments VALUES
(10, 'Administration', 'Toronto'),
(20, 'Marketing', 'New York'),
(30, 'Finance', 'Chicago'),
(40, 'Human Resources', 'London'),
(80, 'Sales', 'Toronto');


INSERT INTO employees VALUES
(101, 'Neena', 'Kochhar', 'AD_VP', 17000, NULL, NULL, 10),
(102, 'Lex', 'De Haan', 'AD_VP', 15000, NULL, 101, 10),
(103, 'Alexander', 'Hunold', 'IT_PROG', 9000, NULL, 102, 20),
(104, 'Bruce', 'Ernst', 'MK_MAN', 6000, 0.20, 102, 20),
(169, 'Steven', 'King', 'SA_REP', 8000, 0.15, 101, 80),
(182, 'Laura', 'Gianni', 'FI_ACCOUNT', 7000, NULL, 101, 30),
(185, 'David', 'Austin', 'SA_REP', 7500, 0.10, 169, 80);


-- Write a SQL query to find customers who are either from the city ‘New York’ OR who do not have a grade greater than 100.
SELECT customer_id, cust_name, city, grade, salesman_id
FROM customers
WHERE city = 'New York'
   OR grade <= 100
   OR grade IS NULL;
-- Write a SQL query to find all the customers in ‘New York’ city who have a grade value above 100
SELECT customer_id, cust_name, city, grade, salesman_id
FROM customers
WHERE city = 'New York'
  AND grade > 100;
  
  -- Write a SQL query that displays order number, purchase amount, achieved percentage (%) and unachieved percentage (%)
-- for those orders that exceed 50% of the target value of 6000.

SELECT ord_no,
       purch_amt,
       (purch_amt / 6000) * 100 AS achieved_percentage,
       100 - ((purch_amt / 6000) * 100) AS unachieved_percentage
FROM orders
WHERE purch_amt > 3000;

-- Write a SQL query to calculate the total purchase amount of all orders.Return: total purchase amount.
SELECT SUM(purch_amt) AS total_purchase_amount
FROM orders;

-- Write a SQL query to find the highest purchase amount ordered by each customer.Return: customer ID and maximum purchase amount.
SELECT customer_id, MAX(purch_amt) AS max_purchase_amount
FROM orders
GROUP BY customer_id;

-- Write a SQL query to calculate the average product price.Return: average product price.
SELECT AVG(price) AS average_product_price
FROM products;

-- Write a SQL query to find those employees whose department is located at ‘Toronto’.Return: first name, last name, employee ID, job ID.
SELECT e.first_name, e.last_name, e.employee_id, e.job_id
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.location = 'Toronto';

-- Write a SQL query to find the employees whose salary is less than the salary of employees whose job title is MK_MAN.
SELECT employee_id, first_name, salary
FROM employees
WHERE job_id = 'MK_MAN';

-- Write a SQL query to find employees who are working in department 80 or 40.Return: first name, last name, department ID and department name.
SELECT e.first_name,
       e.last_name,
       e.department_id,
       d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IN (80, 40);


-- Write a SQL query to display department name, average salary, and number of employees receiving commission for each department.
SELECT d.department_name,
       AVG(e.salary) AS average_salary,
       COUNT(e.commission_pct) AS commission_count
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name;

-- .write a SQL query to find out which employees have the same designation as theemployee whose ID is 169. Return first name, last name, department ID and jobID.
SELECT first_name, last_name, department_id, job_id
FROM employees
WHERE job_id = (
    SELECT job_id
    FROM employees
    WHERE employee_id = 169
);
-- .write a SQL query to find those employees who earn more than the average salary.Return employee ID, first name, last name.
SELECT employee_id, first_name, last_name
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- write a SQL query to find all those employees who work in the Finance department. Return department ID, name (first), job ID and department name.
SELECT e.department_id,
       e.first_name,
       e.job_id,
       d.department_name
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';

--  From the following table, write a SQL query to find the employees who earn less than the employee of ID 182. Return first name, last name and salary.
SELECT first_name, last_name, salary
FROM employees
WHERE salary < (
    SELECT salary
    FROM employees
    WHERE employee_id = 182
);
-- Create a stored procedure CountEmployeesByDept that returns the number of employees in each department.
SELECT first_name, last_name, salary
FROM employees
WHERE salary < (
    SELECT salary
    FROM employees
    WHERE employee_id = 182
);

INSERT INTO departments (department_id, department_name)
VALUES (60, 'IT Department');
-- Create a stored procedure AddNewEmployee that adds a new employee to the database.
DELIMITER $$

CREATE PROCEDURE AddNewEmployee (
    IN p_employee_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_job_id VARCHAR(10),
    IN p_salary DECIMAL(10,2),
    IN p_department_id INT
)
BEGIN
    IF EXISTS (SELECT 1 
               FROM departments 
               WHERE department_id = p_department_id) THEN
        INSERT INTO employees (employee_id, first_name, last_name, job_id, salary, department_id)
        VALUES (p_employee_id, p_first_name, p_last_name, p_job_id, p_salary, p_department_id);
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Department does not exist';
    END IF;
END $$

DELIMITER ;

call AddNewEmployee(11,"preet","patel","p105",85000,10);

select * from employees;

-- Create a stored procedure DeleteEmployeesByDept that removes all employees from a specific department

DROP PROCEDURE IF EXISTS DeleteEmployeesByDept;
DELIMITER //
CREATE PROCEDURE DeleteEmployeesByDept(IN p_DeptID INT)
BEGIN
    DELETE FROM Employees 
    WHERE DepartmentID = p_DeptID; 
END //
DELIMITER ;


SHOW CREATE PROCEDURE DeleteEmployeesByDept;


-- Create a stored procedure GetTopPaidEmployees that retrieves the highest-paid employee in each department.

DROP PROCEDURE IF EXISTS GetTopPaidEmployees;
DELIMITER //
CREATE PROCEDURE GetTopPaidEmployees(IN p_DeptID INT)
BEGIN
    SELECT * FROM Employees
    
    WHERE department_id = p_DeptID 
    ORDER BY Salary DESC
    LIMIT 1;
END //

DELIMITER ;

CALL GetTopPaidEmployees(10);

-- Create a stored procedure PromoteEmployee that increases an employee’s salary and changes their job role.

DROP PROCEDURE IF EXISTS PromoteEmployee;

DELIMITER //

CREATE PROCEDURE PromoteEmployee(
    IN p_EmpID INT, 
    IN p_Salary DECIMAL(10,2), 
    IN p_Role VARCHAR(10) 
)
BEGIN
    UPDATE Employees 
    SET salary = p_Salary, 
        job_id = p_Role  
    WHERE employee_id = p_EmpID; 
    
    
    SELECT employee_id, first_name, last_name, salary, job_id 
    FROM Employees 
    WHERE employee_id = p_EmpID;
END //

DELIMITER ;

CALL PromoteEmployee(103, 12000.00, 'SR_PROG');


-- Create a stored procedure AssignManagerToDepartment that assigns a new manager to all employees in a specific department.
DROP PROCEDURE IF EXISTS AssignManagerToDepartment;

DELIMITER //


DROP PROCEDURE IF EXISTS AssignManagerToDepartment;

DELIMITER //

CREATE PROCEDURE AssignManagerToDepartment(
     IN p_NewManagerID INT,
     IN p_DeptID INT 
) 
BEGIN
     
     UPDATE Employees
     SET manager_id = p_NewManagerID
     WHERE department_id = p_DeptID;
END //

DELIMITER ;

CALL AssignManagerToDepartment(102, 25);