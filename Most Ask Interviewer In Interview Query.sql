-- ORDERS TABLE
CREATE TABLE orders(
	order_id INT,
	customer_id INT,
	order_date DATE,
	amount DECIMAL(10,2),
	status VARCHAR(50)
)

INSERT INTO orders VALUES
(1, 101, '2024-01-01', 500, 'completed'),
(2, 101, '2024-01-05', 300, 'completed'),
(3, 102, '2024-01-06', 700, 'cancelled'),
(4, 103, '2024-01-07', 1000, 'completed'),
(5, 101, '2024-02-01', 900, 'completed'),
(6, 102, '2024-02-03', 400, 'completed'),
(7, 104, '2024-02-05', 800, 'completed');

-- CUSTOMER EVENTS TABLE
CREATE TABLE customer_events (
    customer_id INT,
    event_type VARCHAR(50),
    event_time TIMESTAMP
);

INSERT INTO customer_events VALUES
(101, 'login',  '2024-01-01 10:00:00'),
(101, 'purchase', '2024-01-01 10:20:00'),
(101, 'logout', '2024-01-01 10:40:00'),
(102, 'login',  '2024-01-02 11:00:00'),
(102, 'logout', '2024-01-02 11:30:00'),
(103, 'login',  '2024-01-03 09:00:00'),
(103, 'purchase', '2024-01-03 09:15:00');

--EMPLOYEES TABLE
CREATE TABLE IF NOT EXISTS employees (
    emp_id INT,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT
);

INSERT INTO employees VALUES
(1, 'Amit', 10, 50000),
(2, 'Riya', 10, 70000),
(3, 'Neha', 10, 70000),
(4, 'Rahul', 20, 60000),
(5, 'Karan', 20, 90000),
(6, 'Priya', 30, 80000);

----------------------------------------------------
--Q1 Find the duplicate customer?
----------------------------------------------------
select e.emp_id,
       e.emp_name,
	   e.dept_id,
	   e.salary,
	   count(*) 
from employees as e
group by e.emp_id,e.emp_name,e.dept_id,e.salary
having count(*) > 1

----------------------------------------------------
--Q2 Find the latest order from the each customer?
----------------------------------------------------
select * 
from (
	select 
		order_id,
       	customer_id,
	   	order_date,
	   	amount,
	   	status,
	    row_number() over(
	    partition by customer_id 
	    order by order_date desc) as rnk
from orders) T
where rnk = 1
-----------------------------------------------------
--Q3 Find the second highest salary department wise?
------------------------------------------------------
select * 
from (
	select emp_id,
           emp_name,
	       dept_id,
	       salary,
	       dense_rank() over(
	       partition by dept_id
	       order by salary desc) as sec_salary
from employees) T
where sec_salary = 2
-------------------------------------------------------
--Q4 Calculate running total revenue?
------------------------------------------------------
select order_date,
	   amount,
	   sum(amount) over(
	   order by order_date
	   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
from orders
WHERE status = 'completed'
-----------------------------------------------------------
--Q5 Find the customer who purchased after login?
-----------------------------------------------------------
select distinct l.customer_id 
from customer_events l
join customer_events p
on l.customer_id = p.customer_id
where l.event_type='login'
and p.event_type='purchase'
and p.event_time>l.event_time

