-- What are the names of projects that were not chosen by any employees?
select 
	project_name
from 
	projects
where 
	project_id not in (
		select current_project
		from employees
		where current_project IS NOT NULL
        );



-- What is the name of the project chosen by the most employees?
select 
	project_name
from 
	projects p
join 
	employees e
    on  p.project_id = e.current_project
group by 
	project_name
order by 
	count(employee_id) desc
limit 1;



-- Which projects were chosen by multiple employees?
select 
	project_name
from 
	projects p
join 
	employees e
	on p.project_id = e.current_project
group by 
	current_project
having 
	count(current_project)>1;



-- Each project needs at least 2 developers. How many available project positions are there for developers? Do we have enough developers to fill the needed positions?
select 
	(count(*) * 2) - (
		select count(*)
		from employees
		where current_project is not null 
		and position = 'Developer') as 'Count'
from 
	projects;



-- What are the names of projects chosen by employees with the most common personality type?
select 
	project_name 
from 
	projects p
join 
	employees e
	on p.project_id = e.current_project
where 
	personality = (
		select personality
		from employees          
		group by personality
		order by count(personality) desc
		limit 1);



-- For each employee, provide their name, personality, the names of any projects they’ve chosen, and the number of incompatible co-workers.
select 
	last_name, first_name, personality, project_name,
case
	when personality = 'INFP' 
	then (select count(*)
		from employees
		where personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP','ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
	when personality = 'ENFP' 
	then (select count(*)
		from employees
		where personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP','ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
	when personality = 'INFJ' 
	then (select count(*)
		from employees
		where personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP','ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
	when personality = 'ENFJ' 
	then (select count(*)
		from employees
		where personality IN ('ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
	when personality = 'ISFP' 
	then (select count(*)
		from employees
		where personality IN ('INFP', 'ENTP', 'INFJ'))
	when personality = 'ESFP' 
	then (select count(*)
		from employees
		where personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
	when personality = 'ISTP' 
	then (select count(*)
		from employees
		where personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
	when personality = 'ESTP' 
	then (select count(*)
		from employees
		where personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
	when personality = 'ISFJ' 
	then (select count(*)
		from employees
		where personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
	when personality = 'ESFJ' 
	then (select count(*)
		from employees
		where personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
	when personality = 'ISTJ' 
	then (select count(*)
		from employees
		where personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
	when personality = 'ESTJ' 
	then (select count(*)
		from employees
		where personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
	else 0
	end as 'imcompats'
from 
	employees e
left join 
	projects p
	on e.current_project = p.project_id;
