CREATE DATABASE `exam`;

#1
CREATE TABLE `addresses` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(100) NOT NULL
);

CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(10) NOT NULL
);

CREATE TABLE `clients` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`full_name` VARCHAR(50) NOT NULL,
`phone_number` VARCHAR(20) NOT NULL
);

CREATE TABLE `drivers` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`age` INT NOT NULL,
`rating` FLOAT
);

CREATE TABLE `cars` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`make` VARCHAR(20) NOT NULL,
`model` VARCHAR(20),
`year` INT NOT NULL,
`mileage` INT,
`condition` CHAR(1) NOT NULL,
`category_id` INT NOT NULL,
CONSTRAINT fk_cars_categories
FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`)
);

CREATE TABLE `courses` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`from_address_id` INT NOT NULL,
`start` DATETIME NOT NULL,
`bill` DECIMAL(10,2),
`car_id` INT NOT NULL,
`client_id` INT NOT NULL,
CONSTRAINT fk_courses_addresses
FOREIGN KEY (`from_address_id`) REFERENCES `addresses`(`id`),
CONSTRAINT fk_courses_cars
FOREIGN KEY (`car_id`) REFERENCES `cars`(`id`),
CONSTRAINT fk_courses_client_id
FOREIGN KEY (`client_id`) REFERENCES `clients`(`id`)
);

CREATE TABLE `cars_drivers` (
`car_id` INT,
`driver_id` INT,
PRIMARY KEY(`car_id`, `driver_id`),
CONSTRAINT fk_cars_drivers_cars
FOREIGN KEY (`car_id`) REFERENCES `cars`(`id`),
CONSTRAINT fk_cars_drivers_drivers
FOREIGN KEY (`driver_id`) REFERENCES `drivers`(`id`)
);

#2
INSERT INTO clients (full_name, phone_number)
SELECT CONCAT(d.first_name, ' ', d.last_name),
       CONCAT('(088) 9999', d.id * 2)
       FROM drivers AS d
       WHERE d.id BETWEEN 10 AND 20;
       
#3
UPDATE cars AS c
SET `condition` = 'C'
WHERE c.mileage >= 800000 AND c.mileage IS NULL 
OR c.`year` <= 2010 AND c.make != 'Mercedes-Benz'; 

#4
DELETE c
FROM clients AS c
WHERE c.id NOT IN (SELECT client_id FROM courses) AND LENGTH(full_name) > 3;

#5
SELECT c.make, c.model, c.`condition`
FROM cars AS c
ORDER BY c.id;

#6
SELECT d.first_name,
       d.last_name,
       c.make,
       c.model,
       c.mileage
      FROM drivers AS d
      JOIN cars_drivers AS cd ON d.id = cd.driver_id
      JOIN cars AS c ON cd.car_id = c.id
      WHERE c.mileage IS NOT NULL
      ORDER BY c.mileage DESC, d.first_name;
      
#7
SELECT c.id AS `car_id`,
       c.make,
       c.mileage,
       COUNT(co.car_id) AS `count_of_courses`,
       ROUND(AVG(co.bill), 2) AS `avg_bill`
       FROM cars AS c 
       LEFT JOIN courses AS co ON c.id = co.car_id
       GROUP BY c.id 
       HAVING `count_of_courses` <> 2
       ORDER BY `count_of_courses` DESC, c.id;
       
#8
SELECT c.full_name,
       COUNT(co.car_id) AS `count_of_cars`,
       SUM(co.bill) AS `total_sum`
       FROM clients AS c 
       JOIN courses AS co ON c.id = co.client_id
       GROUP BY c.full_name
       HAVING `count_of_cars` > 1 AND c.full_name LIKE'_a%'
       ORDER BY c.full_name;
       
#9
SELECT a.name,
       IF(HOUR(co.start) BETWEEN 6 AND 20, 'Day', 'Night') AS `day_time`,
       co.bill,
       cl.full_name,
       ca.make,
       ca.model,
       cat.name AS `category_name`
       FROM addresses AS a 
       JOIN courses AS co ON a.id = co.from_address_id
       JOIN clients AS cl ON co.client_id = cl.id
       JOIN cars AS ca ON co.car_id = ca.id
       JOIN categories AS cat ON ca.category_id = cat.id
       ORDER BY co.id;
       
#10
DELIMITER $$
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
     DECLARE number_count INT;
     SET number_count := (
     SELECT COUNT(c.id)
     FROM courses AS c
     JOIN clients AS cl ON c.client_id = cl.id
     WHERE cl.phone_number = phone_num
     );
     RETURN number_count;
END$$ 

#11
DELIMITER $$
CREATE PROCEDURE udp_courses_by_address (address_name VARCHAR(100))
BEGIN
     SELECT a.name,
            cl.full_name AS `full_names`,
            (CASE
            WHEN co.bill <= 20 THEN 'Low'
            WHEN co.bill <= 30 THEN 'Medium'
            ELSE 'High'
            END
            ) AS `level_of_bill`,
            ca.make,
            ca.condition,
            cat.name AS `category_name`
            FROM addresses AS a
            JOIN courses AS co ON a.id = co.from_address_id
            JOIN clients AS cl ON co.client_id = cl.id
            JOIN cars AS ca ON co.car_id = ca.id
            JOIN categories AS cat ON ca.category_id = cat.id
            WHERE a.name = address_name
            ORDER BY ca.make, cl.full_name;
            
END$$