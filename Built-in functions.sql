#1
SELECT `first_name`, `last_name`
FROM `employees`
WHERE `first_name` LIKE 'Sa%'
ORDER BY `employee_id`;

#2
SELECT `first_name`, `last_name`
FROM `employees`
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id`; 

#3
SELECT `first_name` FROM `employees`
WHERE `department_id` IN(3,10) AND YEAR(`hire_date`) BETWEEN 1995 AND 2005
ORDER BY `employee_id`;

#4
SELECT `first_name`, `last_name` FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%'
ORDER BY `employee_id`;

#5
SELECT `name` FROM `towns`
WHERE CHAR_LENGTH(`name`) = 5 OR CHAR_LENGTH(`name`) = 6
ORDER BY `name`;

#6
SELECT * FROM `towns`
WHERE `name`LIKE 'm%'
OR `name` LIKE 'b%'
OR `name` LIKE 'k%'
OR `name` LIKE 'e%'
ORDER BY `name`;

#7
SELECT * FROM`towns`
WHERE`name` NOT REGEXP '^[RrBbDd]'
ORDER BY `name`;

#8
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name`
FROM `employees`
WHERE YEAR(`hire_date`) > 2000; 

SELECT * FROM `v_employees_hired_after_2000`;

#9
SELECT `first_name`, `last_name` FROM `employees`
WHERE char_length(`last_name`) = 5;

#10
SELECT `country_name`, `iso_code` FROM `countries`
WHERE `country_name` LIKE '%a%a%a%'
ORDER BY `iso_code`;

#11
SELECT `peak_name`, `river_name`, CONCAT(LOWER(`peak_name`), SUBSTRING(LOWER(`river_name`), 2)) 
AS `mix` FROM `peaks`, `rivers`
WHERE RIGHT(`peak_name`, 1) = LEFT(`river_name`, 1)
ORDER BY `mix`;

#12
SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') AS `start` 
FROM `games`
WHERE YEAR(`start`) = 2011 OR YEAR(`start`) = 2012
ORDER BY `start`, `name`
LIMIT 50;

#13
SELECT `user_name`, SUBSTRING(`email`,locate('@', `email`) +1) AS `email provider` 
FROM `users`
ORDER BY `email provider`, `user_name`;

#14
SELECT `user_name`, `ip_address` 
FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

#15
SELECT `name` AS `game`, 
CASE
WHEN HOUR(`start`) BETWEEN 0 AND 11 THEN 'Morning'
WHEN HOUR(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS `Part of the Day`,
CASE
WHEN `duration` <= 3 THEN 'Extra Short'
WHEN `duration` BETWEEN 4 AND 6 THEN 'Short'
WHEN `duration` BETWEEN 7 AND 10 THEN'Long'
ELSE 'Extra Long'
END AS 'Duration'
FROM `games`
ORDER BY `name`; 

#16
SELECT `product_name`,
`order_date`,
ADDDATE(`order_date`, interval 3 day) AS 'pay_deu',
ADDDATE(`order_date`, interval 1 month) AS `deliver_due` 
FROM `orders`;