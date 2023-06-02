-- Find the longest ongoing project for each department.
select
     p.name as Project_name,
     d.name as Department_name,
     p.start_date,
     p.end_date,
     datediff(p.end_date,p.start_date) as no_days
from projects p
join 
    departments d on p.department_id=d.id
order by
     no_days desc;
     
     
-- Find all employees who are not managers.
select
   name,
   job_title
from 
    employees
where 
    job_title not like '%manager%'  ;


-- Find all employees who have been hired after the start of a project in their department.

select
    e.name as employee_name,
    p.name as Projet_name,
    d.name as department_name
from 
   employees e 
join 
   projects p on p.department_id=e.department_id
join 
departments d on d.id=p.department_id
where
   e.hire_date > p.start_date;


-- Rank employees within each department based on their hire date (earliest hire gets the highest rank).
select
    e.name as employee_name,
    e.hire_date,
    d.name as department_name,
    dense_rank() over(partition by d.name order by e.hire_date desc) as rnk
from 
  employees e
join   
   departments d on e.department_id=d.id;
  
  
-- Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department.

with cte as(select
    e.name as employee_name,
    e.hire_date,
    d.name as department_name,
    lag(e.hire_date) over(partition by d.name order by e.hire_date desc) as pre_date
from 
  employees e
join   
   departments d on e.department_id=d.id)
select
    employee_name,
    department_name,
    datediff(pre_date,hire_date) as Duration_day
from cte
where pre_date is not null;