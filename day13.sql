use day13sql;



CREATE TABLE departments (
    dept_id INT,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    dept_id INT,
    manager_id INT,
    salary INT
);

CREATE TABLE projects (
    project_id INT,
    project_name VARCHAR(50),
    dept_id INT
);

CREATE TABLE emp_projects (
    emp_id INT,
    project_id INT
);

CREATE TABLE locations (
    location_id INT,
    dept_id INT,
    city VARCHAR(50)
);



INSERT INTO departments VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Sales');

INSERT INTO employees VALUES
(1, 'Alice', 1, NULL, 80000),
(2, 'Bob', 1, 1, 60000),
(3, 'Charlie', 2, 1, 50000),
(4, 'David', 3, 2, 70000),
(5, 'Eva', NULL, 2, 45000);

INSERT INTO projects VALUES
(101, 'Website', 1),
(102, 'Payroll', 3),
(103, 'Recruitment', 2);

INSERT INTO emp_projects VALUES
(1, 101),
(2, 101),
(3, 103),
(4, 102);

INSERT INTO locations VALUES
(1, 1, 'New York'),
(2, 2, 'London'),
(3, 3, 'Tokyo');



-- 1 Employees earning more than average
SELECT e.*
FROM employees e
JOIN (SELECT AVG(salary) avg_sal FROM employees) a
ON e.salary > a.avg_sal;

-- 2 Employees in IT
SELECT e.*
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'IT';

-- 3 Highest salary
SELECT e.*
FROM employees e
JOIN (SELECT MAX(salary) max_sal FROM employees) m
ON e.salary = m.max_sal;

-- 4 Employees with no department
SELECT e.*
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

-- 5 Employees working on at least one project
SELECT DISTINCT e.*
FROM employees e
JOIN emp_projects ep ON e.emp_id = ep.emp_id;

-- 6 Employees NOT working on any project
SELECT e.*
FROM employees e
LEFT JOIN emp_projects ep ON e.emp_id = ep.emp_id
WHERE ep.project_id IS NULL;

-- 7 Departments with at least one employee
SELECT DISTINCT d.*
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id;

-- 8 Departments with no employees
SELECT d.*
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;

-- 9 Employees earning more than their manager
SELECT e.*
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- 10 Employees in departments located in Tokyo
SELECT e.*
FROM employees e
JOIN locations l ON e.dept_id = l.dept_id
WHERE l.city = 'Tokyo';

-- 11 Employees working on Website project
SELECT e.*
FROM employees e
JOIN emp_projects ep ON e.emp_id = ep.emp_id
JOIN projects p ON ep.project_id = p.project_id
WHERE p.project_name = 'Website';

-- 12 Projects assigned to IT employees
SELECT DISTINCT p.*
FROM projects p
JOIN emp_projects ep ON p.project_id = ep.project_id
JOIN employees e ON ep.emp_id = e.emp_id
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'IT';

-- 13 Employees who are managers
SELECT DISTINCT m.*
FROM employees m
JOIN employees e ON m.emp_id = e.manager_id;

-- 14 Employees who are NOT managers
SELECT e.*
FROM employees e
LEFT JOIN employees m ON e.emp_id = m.manager_id
WHERE m.emp_id IS NULL;

-- 15 Departments that have projects
SELECT DISTINCT d.*
FROM departments d
JOIN projects p ON d.dept_id = p.dept_id;

-- 16 Departments without projects
SELECT d.*
FROM departments d
LEFT JOIN projects p ON d.dept_id = p.dept_id
WHERE p.project_id IS NULL;

-- 17 Employees earning more than department average
SELECT e.*
FROM employees e
JOIN (
    SELECT dept_id, AVG(salary) avg_sal
    FROM employees
    GROUP BY dept_id
) a ON e.dept_id = a.dept_id
WHERE e.salary > a.avg_sal;

-- 18 Second highest salary
SELECT MAX(e1.salary) AS second_highest_salary
FROM employees e1
LEFT JOIN employees e2
ON e1.salary < e2.salary
WHERE e2.salary IS NOT NULL;

-- 19 Employees in departments with more than one employee
SELECT e.*
FROM employees e
JOIN (
    SELECT dept_id
    FROM employees
    GROUP BY dept_id
    HAVING COUNT(*) > 1
) x ON e.dept_id = x.dept_id;

-- 20 Employees whose department has a location
SELECT DISTINCT e.*
FROM employees e
JOIN locations l ON e.dept_id = l.dept_id;

-- 21 Employees whose department does NOT have location
SELECT e.*
FROM employees e
LEFT JOIN locations l ON e.dept_id = l.dept_id
WHERE l.location_id IS NULL;

-- 22 Projects belonging to departments with employees
SELECT DISTINCT p.*
FROM projects p
JOIN employees e ON p.dept_id = e.dept_id;

-- 23 Employees working on projects from their own department
SELECT DISTINCT e.*
FROM employees e
JOIN emp_projects ep ON e.emp_id = ep.emp_id
JOIN projects p ON ep.project_id = p.project_id
WHERE e.dept_id = p.dept_id;

-- 24 Employees working on projects outside their department
SELECT DISTINCT e.*
FROM employees e
JOIN emp_projects ep ON e.emp_id = ep.emp_id
JOIN projects p ON ep.project_id = p.project_id
WHERE e.dept_id <> p.dept_id;

-- 25 Departments where all employees earn more than 50000
SELECT d.*
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING MIN(e.salary) > 50000;