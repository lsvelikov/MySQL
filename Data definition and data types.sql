#1
CREATE TABLE `minions` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `age` INT NOT NULL
);

CREATE TABLE `towns` (
    `town_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

#2
ALTER TABLE `minions`
ADD COLUMN `town_id` INT,
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (town_id)
REFERENCES `towns`(`id`);

#3
INSERT INTO `towns`
VALUES (1,'Sofia'),
       (2,'Plovdiv'),
       (3,'Varna');

INSERT INTO `minions`
VALUES (1,'Kevin',22,1),
       (2,'Bob',15,3),
       (3,'Steward',NULL,2);
       
#4
TRUNCATE `minions`;

#5
DROP TABLE `minions`;
DROP TABLE `towns`;

#6
CREATE TABLE `people` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL ,
    `picture` BLOB,
    `height` FLOAT(10,2),
    `weight` FLOAT(10,2),
    `gender` CHAR NOT NULL ,
    `birthdate` DATE NOT NULL ,
    `biography` TEXT
);

INSERT INTO `people`
VALUES (1,'Jo',NULL,160,64,'m','2003-03-02','something'),
       (2,'Jo',NULL,160,64,'m','2003-03-02','something'),
       (3,'Jo',NULL,160,64,'m','2003-03-02','something'),
       (4,'Jo',NULL,160,64,'m','2003-03-02','something'),
       (5,'Jo',NULL,160,64,'m','2003-03-02','something');
       
#7
CREATE TABLE `users` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) UNIQUE NOT NULL ,
    `password` VARCHAR(26) NOT NULL ,
    `profile_picture` BLOB,
    `last_login_time` DATETIME,
    `is_deleted` BOOL
);
INSERT INTO `users`
VALUES (1,'shn32','hjuy',NULL,'2002-01-02 00:01:10',0),
       (2,'shn33','hjuy',NULL,'2002-01-02 00:01:10',0),
       (3,'shn34','hjuy',NULL,'2002-01-02 00:01:10',0),
       (4,'shn35','hjuy',NULL,'2002-01-02 00:01:10',0),
       (5,'shn36','hjuy',NULL,'2002-01-02 00:01:10',0);
       
#8
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (id, username);

#9
ALTER TABLE `users`
CHANGE COLUMN `last_login_time` `last_login_time` DATETIME NULL DEFAULT NOW();

#10
ALTER TABLE `users`
DROP PRIMARY KEY ,
ADD CONSTRAINT pk_users
PRIMARY KEY `users`(`id`),
MODIFY COLUMN `username` VARCHAR(30) UNIQUE;

#11
CREATE TABLE `directors`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`director_name` VARCHAR(40) NOT NULL,
`notes` TEXT
);
INSERT INTO `directors`
VALUES
(1, 'Oliver Stone', 'some text'),
(2, 'Oliver Stone', 'some text'),
(3, 'Oliver Stone', 'some text'),
(4, 'Oliver Stone', 'some text'),
(5, 'Oliver Stone', 'some text');

CREATE TABLE `genres`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`genre_name` VARCHAR(30) NOT NULL,
`notes` TEXT);

INSERT INTO `genres`
VALUES
(1, 'action', 'some text'),
(2, 'animation', 'some text'),
(3, 'action', 'some text'),
(4, 'action', 'some text'),
(5, 'action', 'some text');

CREATE TABLE `categories`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`category_name` VARCHAR(30) NOT NULL,
`notes` TEXT
);
INSERT INTO `categories`
VALUES
(1, 'kids', 'some text'),
(2, 'kids', 'some text'),
(3, 'kids', 'some text'),
(4, 'kids', 'some text'),
(5, 'kids', 'some text');

CREATE TABLE `movies`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR(50) NOT NULL, 
`director_id` INT NOT NULL, 
`copyright_year` YEAR,
`length` FLOAT NOT NULL,
`genre_id` INT NOT NULL,
`category_id` INT NOT NULL,
`rating` INT NOT NULL,
`notes` TEXT
);
INSERT INTO `movies`
VALUES
(1, 'RANGO', 1, 2003, 1.36, 1, 1, 100, 'some text'),
(2, 'RANGO', 1, 2003, 1.36, 1, 1, 100, 'some text'),
(3, 'RANGO', 1, 2003, 1.36, 1, 1, 100, 'some text'),
(4, 'RANGO', 1, 2003, 1.36, 1, 1, 100, 'some text'),
(5, 'RANGO', 1, 2003, 1.36, 1, 1, 100, 'some text');

#12
CREATE TABLE `categories` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `category` VARCHAR(50) NOT NULL ,
    `daily_rate` INT NOT NULL ,
    `weekly_rate` INT NOT NULL ,
    `monthly_rate` INT NOT NULL ,
    `weekend_rate` INT NOT NULL
);

INSERT INTO `categories`
VALUES (1,'car',1,2,3,4),
       (2,'bus',1,2,3,4),
       (3,'truck',1,2,3,4);

CREATE TABLE `cars` (
    `id` INT AUTO_INCREMENT PRIMARY KEY ,
    `plate_number` VARCHAR(30) NOT NULL ,
    `make` VARCHAR(30) NOT NULL ,
    `model` VARCHAR(30) NOT NULL ,
    `car_year` YEAR NOT NULL ,
    `category_id` INT NOT NULL ,
    `doors` INT NOT NULL ,
    `picture` BLOB,
    `car_condition` VARCHAR(20) NOT NULL ,
    `available` BOOL
);

INSERT INTO `cars`
VALUES (1,'S7880','Audi','A4',2006,2,5,NULL,'used',1),
       (2,'S7880','Audi','A4',2006,2,5,NULL,'used',1),
       (3,'S7880','Audi','A4',2006,2,5,NULL,'used',1);

CREATE TABLE `employees` (
    `id` INT AUTO_INCREMENT PRIMARY KEY ,
    `first_name` VARCHAR(30) NOT NULL ,
    `last_name` VARCHAR(30) NOT NULL ,
    `title` VARCHAR(30) NOT NULL ,
    `notes` TEXT
);

INSERT INTO `employees`
VALUES (1,'Jo','Jo','manager','text'),
       (2,'Jo','Jo','manager','text'),
       (3,'Jo','Jo','manager','text');

CREATE TABLE `customers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY ,
    `driver_licence_number` VARCHAR(50) NOT NULL ,
    `full_name` VARCHAR(50) NOT NULL ,
    `address` VARCHAR(100) NOT NULL ,
    `city` VARCHAR(50) NOT NULL ,
    `zip_code` VARCHAR(30) NOT NULL,
    `notes` TEXT
);

INSERT INTO `customers`
VALUES (1,'de23jn21','Jo Jo','Alen rd','Lom','23de','text'),
       (2,'de23jn21','Jo Jo','Alen rd','Lom','23de','text'),
       (3,'de23jn21','Jo Jo','Alen rd','Lom','23de','text');

CREATE TABLE `rental_orders` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `employee_id` INT NOT NULL ,
    `customer_id` INT NOT NULL ,
    `car_id` INT NOT NULL ,
    `car_condition` VARCHAR(30) NOT NULL ,
    `tank_level` VARCHAR(20) NOT NULL ,
    `kilometrage_start` INT NOT NULL ,
    `kilometrage_end` INT NOT NULL ,
    `total_kilometrage` INT NOT NULL ,
    `start_date` DATE NOT NULL ,
    `end_date` DATE NOT NULL ,
    `total_days` INT NOT NULL ,
    `rate_applied` FLOAT NOT NULL ,
    `tax_rate` FLOAT NOT NULL ,
    `order_status` VARCHAR(20) NOT NULL ,
    `notes` TEXT
);

INSERT INTO `rental_orders`
VALUES
    (1, 1, 1,1, 'NEW', 'FULL',1000, 1000, 200000,'2023-01-01','2023-10-01', 10, 100,100,'rent', NULL),
    (2, 1, 1,1, 'NEW', 'FULL',1000, 1000, 200000,'2023-01-01','2023-10-01', 10, 100,100,'rent', NULL),
    (3, 1, 1,1, 'NEW', 'FULL',1000, 1000, 200000,'2023-01-01','2023-10-01', 10, 100,100,'rent', NULL);

#13
INSERT INTO `towns`(`name`)
VALUES
    ('Sofia'),
    ('Plovdiv'),
    ('Varna'),
    ('Burgas');

INSERT INTO  `departments`(`name`)
VALUES
    ('Engineering'),
    ('Sales'),
    ('Marketing'),
    ('Software Development'),
    ('Quality Assurance');

INSERT INTO  `employees`
VALUES
    (1, 'Ivan', 'Ivanov', 'Ivanov',	'.NET Developer',	4, '2013-02-01', 3500.00, null),
    (2, 'Petar', 'Petrov', 'Petrov',	'Senior Engineer',	1,'2004-03-02', 4000.00, null),
    (3, 'Maria', 'Petrova', 'Ivanova',	'Intern',	5,	'2016-08-28', 525.25, null),
    (4, 'Georgi', 'Terziev', 'Ivanov', 'CEO',	2,'2007-12-09', 3000.00, null),
    (5, 'Peter', 'Pan', 'Pan',	'Intern',	3,'2016-08-28',	599.88, null);

#14
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

#15
SELECT * FROM `towns`
ORDER BY `name`;

SELECT * FROM `departments`
ORDER BY `name`;

SELECT * FROM `employees`
ORDER BY `salary` DESC;

#16
SELECT `name` FROM `towns`
ORDER BY `name`;

SELECT `name` FROM `departments`
ORDER BY `name`;

SELECT `first_name`, `last_name`,`job_title`, `salary` FROM employees
ORDER BY `salary` DESC ;

#17
UPDATE `employees`
SET `salary` = `salary` * 1.1;
SELECT `salary` FROM `employees`;
       