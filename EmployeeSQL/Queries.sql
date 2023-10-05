-- Create Titles Table
CREATE TABLE Titles (
	title_id VARCHAR NOT NULL,
	title VARCHAR NOT NULL,
	PRIMARY KEY (title_id)
);

-- Create Employees Table
CREATE TABLE Employees (
	emp_no INTEGER NOT NULL,
	emp_title_id VARCHAR NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES Titles(title_id),
	PRIMARY KEY (emp_no)
);

-- Create Departments Table
CREATE TABLE Departments (
	dept_no VARCHAR NOT NULL,
	dept_name VARCHAR NOT NULL,
	PRIMARY KEY (dept_no)
);

-- Create Department Managers Table
CREATE TABLE Department_Managers (
	dept_no VARCHAR NOT NULL,
	emp_no INTEGER NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES Departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	PRIMARY KEY (dept_no, emp_no)
);

-- Create Department Employees Table
CREATE TABLE Department_Employees (
	emp_no INTEGER NOT NULL,
	dept_no VARCHAR NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES Departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
	
	
-- Create Salaries Table
CREATE TABLE Salaries (
	emp_no INTEGER NOT NULL,
	salary INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	PRIMARY KEY (emp_no)
);
	

-- Imported each csv file to each table
-- Query each table to verify import was successful
SELECT * FROM Department_Managers;
SELECT * FROM Department_Employees;
SELECT * FROM Departments;
SELECT * FROM Employees;
SELECT * FROM Salaries;
SELECT * FROM Titles;

-- List the employee number, last name, first name, sex, and salary of each employee
SELECT E.emp_no, E.last_name, E.first_name, E.sex, S.salary
FROM Employees AS E
	JOIN Salaries AS S
	ON (E.emp_no = S.emp_no)
ORDER BY E.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986
SELECT E.first_name, E.last_name, E.hire_date
FROM Employees AS E
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

-- List the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT DM.dept_no, D.dept_name, E.emp_no, E.last_name, E.first_name
FROM Employees AS E
	JOIN Department_Managers AS DM
	ON (E.emp_no = DM.emp_no)
		JOIN Departments as D
		ON (DM.dept_no = D.dept_no);
		
-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name
SELECT DE.dept_no, D.dept_name, E.emp_no, E.last_name, E.first_name
FROM Employees AS E
	JOIN Department_Employees AS DE
	ON (E.emp_no = DE.emp_no)
		JOIN Departments as D
		ON (DE.dept_no = D.dept_no)
ORDER BY E.emp_no;
		
-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM Employees 
WHERE first_name = 'Hercules' 
AND last_name ILIKE 'B%';

-- List each employee in the Sales department, including their employee number, last name, and first name
SELECT E.emp_no, E.last_name, E.first_name
FROM Employees AS E
	JOIN Department_Employees AS DE
	ON (E.emp_no = DE.emp_no)
		JOIN Departments as D
		ON (DE.dept_no = D.dept_no)
WHERE D.dept_name = 'Sales'
ORDER BY E.emp_no;

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
SELECT E.emp_no, E.last_name, E.first_name, D.dept_name
FROM Employees AS E
	JOIN Department_Employees AS DE
	ON (E.emp_no = DE.emp_no)
		JOIN Departments as D
		ON (DE.dept_no = D.dept_no)
WHERE D.dept_name = 'Sales' 
OR D.dept_name = 'Development'
ORDER BY E.emp_no;

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
SELECT last_name, COUNT(last_name) AS "Frequency Count"
FROM Employees
GROUP BY last_name
ORDER BY "Frequency Count" DESC;
