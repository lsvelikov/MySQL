CREATE DATABASE `exam`;

#1
CREATE TABLE `pictures` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`url` VARCHAR(100) NOT NULL,
`added_on` DATETIME NOT NULL
);

CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `towns` (
`id` INT PRIMARY KEY NOT NULL,
`name` VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE `products` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE,
`best_before` DATE,
`price` DECIMAL(10,2) NOT NULL,
`description` TEXT,
`category_id` INT NOT NULL,
`picture_id` INT NOT NULL,
CONSTRAINT fk_products_categories
FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`),
CONSTRAINT fk_products_pitures
FOREIGN KEY (`picture_id`) REFERENCES `pictures`(`id`)
);

CREATE TABLE `addresses` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL UNIQUE,
`town_id` INT NOT NULL,
CONSTRAINT fk_addresses_towns
FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`)
);

CREATE TABLE `stores` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL UNIQUE,
`rating` FLOAT NOT NULL,
`has_parking` TINYINT(1),
`address_id` INT NOT NULL,
CONSTRAINT fk_stores_addresses
FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`) 
);

CREATE TABLE `products_stores` (
`product_id` INT NOT NULL,
`store_id` INT NOT NULL,
PRIMARY KEY(`product_id`, `store_id`),
CONSTRAINT fk_products_stores_products
FOREIGN KEY (`product_id`) REFERENCES `products`(`id`),
CONSTRAINT fk_products_stores_stores
FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`)
); 

CREATE TABLE `employees` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(15) NOT NULL,
`middle_name` CHAR(1),
`last_name` VARCHAR(20) NOT NULL,
`salary` DECIMAL(19,2) NOT NULL,
`hire_date` DATE NOT NULL,
`manager_id` INT,
`store_id` INT NOT NULL,
CONSTRAINT fk_employees_stores
FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`),
CONSTRAINT fk_employees_employees
FOREIGN KEY (`manager_id`) REFERENCES `employees`(`id`)
);

#2
INSERT INTO products_stores
SELECT p.id,
       (1)
FROM products AS p
LEFT JOIN products_stores AS ps ON p.id = ps.product_id
LEFT JOIN stores AS s ON ps.store_id = s.id
WHERE s.id IS NULL;

#3
UPDATE employees AS e
      JOIN stores AS s ON e.store_id = s.id
SET e.salary = e.salary - 500, e.manager_id = 3
WHERE YEAR(e.hire_date) > 2003 
AND s.id NOT IN(5, 14);

#4
DELETE 
FROM employees
WHERE salary >= 6000
AND manager_id IS NOT NULL 
AND id <> manager_id;

#5
SELECT first_name,
       middle_name,
	   last_name,
       salary,
       hire_date
FROM employees
ORDER BY hire_date DESC; 

#6
SELECT p.`name` AS `product_name`,
       p.price,
       p.best_before,
       CONCAT(LEFT(p.description, 10), '...') AS `short_description`,
       pic.url
FROM products AS p
JOIN pictures AS pic ON p.picture_id = pic.id
WHERE LENGTH(p.description) > 100 
AND YEAR(pic.added_on) < 2019
AND p.price > 20
ORDER BY p.price DESC; 

#7
SELECT s.`name`,
       COUNT(ps.product_id) AS `product_count`,
       CAST(AVG(p.price) AS DECIMAL(10,2)) AS `avg`
FROM stores AS s
LEFT JOIN products_stores AS ps ON ps.store_id = s.id
LEFT JOIN products AS p ON ps.product_id = p.id
GROUP BY s.id
ORDER BY `product_count` DESC, `avg` DESC, s.id;

#8
SELECT CONCAT(e.first_name, ' ', e.last_name) AS `Full_name`,
       s.`name` AS `Store_name`,
       a.`name` AS `address`,
       e.salary
FROM employees AS e
JOIN stores AS s ON e.store_id = s.id
JOIN addresses AS a ON s.address_id = a.id
WHERE e.salary < 4000
AND a.`name` LIKE '%5%'
AND LENGTH(s.`name`) > 8
AND e.last_name LIKE '%n';

#9
SELECT REVERSE(s.`name`) AS `reversed_name`,
       CONCAT(UPPER(t.`name`), '-', a.`name`) AS `full_address`,
       COUNT(e.id) AS `employees_count`
FROM stores AS s
LEFT JOIN employees AS e ON e.store_id = s.id
JOIN addresses AS a ON s.address_id = a.id
JOIN towns AS t ON a.town_id = t.id
GROUP BY s.id
HAVING `employees_count` >= 1
ORDER BY `full_address`;

#10
DELIMITER $$
CREATE FUNCTION udf_top_paid_employee_by_store(store_name VARCHAR(50))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
     RETURN  (SELECT 
                       CONCAT(e.first_name, ' ', e.middle_name, '. ', e.last_name,
                       ' works in store for ', 2020 - YEAR(e.hire_date), ' years')
                       FROM employees AS e
                       JOIN stores AS s ON e.store_id = s.id
                       WHERE s.`name` = store_name
                       ORDER BY e.salary DESC
                       LIMIT 1);
END$$

#11
DELIMITER $$
CREATE PROCEDURE udp_update_product_price(address_name VARCHAR(50))
BEGIN
     UPDATE products AS p
     SET price = IF(address_name LIKE '0%', price + 100, price + 200)
     WHERE p.id IN(SELECT ps.product_id
                    FROM products_stores AS ps
                    JOIN stores AS s ON s.id = ps.store_id
                    JOIN addresses AS a ON a.id = s.address_id
                    WHERE a.`name` = address_name);
END$$