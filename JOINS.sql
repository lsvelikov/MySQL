#1
SELECT 
    e.`employee_id`,
    e.`job_title`,
    a.`address_id`,
    a.`address_text`
FROM
    `employees` AS e
        JOIN
    `addresses` AS a ON e.`address_id` = a.`address_id`
ORDER BY a.`address_id`
LIMIT 5;

#2
SELECT 
    e.`first_name`, e.`last_name`, t.`name`, a.`address_text`
FROM
    `employees` AS e
        JOIN
    `addresses` AS a ON e.`address_id` = a.`address_id`
        JOIN
    `towns` AS t ON a.`town_id` = t.`town_id`
ORDER BY e.`first_name` , e.`last_name`
LIMIT 5;

#3
SELECT 
    e.`employee_id`,
    e.`first_name`,
    e.`last_name`,
    d.`name` AS `department_name`
FROM
    `employees` AS e
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
WHERE
    d.`name` = 'Sales'
ORDER BY e.`employee_id` DESC;

#4
SELECT 
    e.`employee_id`,
    e.`first_name`,
    e.`salary`,
    d.`name` AS `department_name`
FROM
    `employees` AS e
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
WHERE
    e.`salary` > 15000
ORDER BY d.`department_id` DESC
LIMIT 5;

#5
SELECT 
    e.`employee_id`, e.`first_name`
FROM
    `employees` AS e
        LEFT JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
WHERE
    ep.`project_id` IS NULL
ORDER BY e.`employee_id` DESC
LIMIT 3;

#6
SELECT 
    e.`first_name`,
    e.last_name,
    e.hire_date,
    d.name AS `dept_name`
FROM
    `employees` AS e
        JOIN
    `departments` AS d ON e.department_id = d.department_id
WHERE
    d.name IN ('Sales' , 'Finance')
        AND DATE(e.`hire_date`) > '1999-01-01'
ORDER BY e.hire_date;

#7
SELECT 
    e.employee_id, e.first_name, p.`name` AS `project_name`
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep ON e.employee_id = ep.employee_id
        JOIN
    `projects` AS p ON ep.project_id = p.project_id
WHERE
    DATE(p.`start_date`) > '2002-08-13 00:00:00.000000'
        AND p.`end_date` IS NULL
ORDER BY e.first_name , p.name
LIMIT 5;

#8
SELECT 
    e.employee_id,
    e.first_name,
    IF(YEAR(p.`start_date`) >= 2005,
        ' ',
        p.name) AS `project_name`
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep ON ep.employee_id = e.employee_id
        JOIN
    `projects` AS p ON ep.project_id = p.project_id
WHERE
    e.employee_id = 24
ORDER BY project_name;

#9
SELECT 
    e.employee_id,
    e.first_name,
    e.manager_id,
    emp.first_name AS `manager_name`
FROM
    `employees` AS e
        JOIN
    `employees` AS emp ON emp.employee_id = e.manager_id
WHERE
    e.`manager_id` IN (3 , 7)
ORDER BY e.first_name; 

#10
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS `employee_name`,
    CONCAT(emp.first_name, ' ', emp.last_name) AS `manager_name`,
    d.name AS `department_name`
FROM
    `employees` AS e
        JOIN
    `employees` AS emp ON emp.employee_id = e.manager_id
        JOIN
    `departments` AS d ON d.department_id = e.department_id
WHERE
    e.manager_id IS NOT NULL
ORDER BY e.employee_id
LIMIT 5;

#11
SELECT 
    AVG(salary) AS min_average_salary
FROM
    departments AS d
        JOIN
    employees AS e ON e.department_id = d.department_id
GROUP BY e.department_id
ORDER BY min_average_salary
LIMIT 1;

#12
SELECT 
    c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM
    peaks p
        JOIN
    mountains AS m ON m.id = p.mountain_id
        JOIN
    mountains_countries AS mc ON mc.mountain_id = m.id
        JOIN
    countries AS c ON c.country_code = mc.country_code
WHERE
    mc.country_code = 'BG'
        AND p.elevation > 2835
ORDER BY p.elevation DESC;

#13
SELECT 
    mc.country_code, COUNT(m.mountain_range) AS mountain_range
FROM
    mountains AS m
        JOIN
    mountains_countries AS mc ON m.id = mc.mountain_id
WHERE
    mc.country_code IN ('BG' , 'RU', 'US')
GROUP BY mc.country_code
ORDER BY mountain_range DESC;

#14
SELECT 
    c.country_name, r.river_name
FROM
    countries AS c
        LEFT JOIN
    countries_rivers AS cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers AS r ON cr.river_id = r.id
WHERE
    c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

#16
SELECT 
    COUNT(*)
FROM
    countries AS c
        LEFT JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
        LEFT JOIN
    mountains AS m ON mc.mountain_id = m.id
WHERE
    m.mountain_range IS NULL;
    
#17
SELECT 
    c.country_name,
    MAX(p.elevation) AS highest_peak_elevation,
    MAX(r.length) AS longest_river_length
FROM
    countries AS c
        LEFT JOIN
    mountains_countries AS mc USING (country_code)
        LEFT JOIN
    peaks AS p USING (mountain_id)
        LEFT JOIN
    countries_rivers AS cr USING (country_code)
        LEFT JOIN
    rivers AS r ON r.id = cr.river_id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC , longest_river_length DESC , c.country_name
LIMIT 5;