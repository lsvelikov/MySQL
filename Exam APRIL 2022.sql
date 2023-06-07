CREATE DATABASE `exam`;
USE `exam`;

#1
CREATE TABLE `countries` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL UNIQUE,
`continent` VARCHAR(30) NOT NULL,
`currency` VARCHAR(5) NOT NULL
);

CREATE TABLE `genres` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE `actors` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50) NOT NULL,
`birthdate` DATE NOT NULL,
`height` INT,
`awards` INT,
`country_id` INT NOT NULL,
CONSTRAINT fk_actors_countries
FOREIGN KEY (`country_id`) REFERENCES `countries`(`id`)
);

CREATE TABLE `movies_additional_info` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`rating` DECIMAL(10,2) NOT NULL,
`runtime` INT NOT NULL,
`picture_url` VARCHAR(80) NOT NULL,
`budget` DECIMAL(10,2),
`release_date` DATE,
`has_subtitles` TINYINT(1),
`description` TEXT
);

CREATE TABLE `movies` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR(70) NOT NULL UNIQUE,
`country_id` INT NOT NULL,
`movie_info_id` INT NOT NULL UNIQUE,
CONSTRAINT fk_movies_movies_additional_info
FOREIGN KEY (`movie_info_id`) REFERENCES `movies_additional_info`(`id`),
CONSTRAINT fk_movies_countries
FOREIGN KEY (`country_id`) REFERENCES `countries`(`id`)
);

CREATE TABLE `movies_actors` (
`movie_id` INT,
`actor_id` INT,
CONSTRAINT fk_movies_actors_movies
FOREIGN KEY (`movie_id`) REFERENCES `movies`(`id`),
CONSTRAINT fk_movies_actors_actors
FOREIGN KEY (`actor_id`) REFERENCES `actors`(`id`)
);

CREATE TABLE `genres_movies` (
`genre_id` INT,
`movie_id` INT,
CONSTRAINT fk_genres_movies_genres
FOREIGN KEY (`genre_id`) REFERENCES `genres`(`id`),
CONSTRAINT fk_genres_movies_movies
FOREIGN KEY (`movie_id`) REFERENCES `movies`(`id`)
);

#2
INSERT INTO `actors` (`first_name`, `last_name`, `birthdate`, `height`, `awards`, `country_id`)
SELECT (REVERSE(`first_name`)),
       (REVERSE(`last_name`)),
       (DATE(`birthdate` - 2)),
       (`height` + 10),
       (`country_id`),
       (3) 
FROM `actors`
WHERE `id` <= 10;

#3
UPDATE `movies_additional_info`
SET `runtime` = `runtime` - 10
WHERE `id` BETWEEN 15 AND 25;

#4
DELETE c FROM `countries` AS c
LEFT JOIN `movies` AS m ON c.`id` = m.`country_id`
WHERE m.`country_id` IS NULL;

-- DELETE FROM countries
-- WHERE id NOT IN(SELECT country_id FROM MOVIES); 

#5
SELECT * FROM countries
ORDER BY currency DESC, id;

#6
SELECT 
      mi.id,
      m.title,
      mi.runtime,
      mi.budget,
      mi.release_date
      FROM movies_additional_info AS mi
      JOIN movies AS m ON mi.id = m.movie_info_id
      WHERE YEAR(release_date) BETWEEN 1996 AND 1999
      ORDER BY mi.runtime, mi.id
      LIMIT 20;
      
#7
SELECT
	  CONCAT(a.first_name, ' ', a.last_name) AS `full_name`,
      CONCAT(REVERSE(a.last_name),CHAR_LENGTH(a.last_name),'@cast.com') AS `email`,
      (2022 - YEAR(a.birthdate)) AS `age`,
      a.height
      FROM actors AS a
      LEFT JOIN movies_actors AS ma ON a.id = ma.actor_id
      LEFT JOIN movies AS m ON ma.movie_id = m.id
      WHERE m.id IS NULL
      ORDER BY height;
      
#8
SELECT 
	  c.name,
      COUNT(m.country_id) AS `movies_count` 
      FROM countries AS c
      JOIN movies AS m ON m.country_id = c.id
      GROUP BY c.name
      HAVING `movies_count` >= 7
      ORDER BY name DESC;
      
#9
SELECT 
      m.title,
      (CASE 
           WHEN mi.rating <= 4 THEN 'poor'
           WHEN mi.rating <= 7 THEN 'good'
           ELSE 'excellent'
      END
      ) AS `rating`,
      IF(mi.has_subtitles = 1, 'english', '-') AS `subtitles`,
      mi.budget
FROM movies AS m
JOIN movies_additional_info AS mi ON m.movie_info_id = mi.id
ORDER BY budget DESC; 

#10
DELIMITER $$
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
     DECLARE history_movies_count INT;
     SET history_movies_count := (
     SELECT COUNT(*) AS `history_movies`
     FROM actors AS a
     JOIN movies_actors AS ma ON a.id = ma.actor_id
     JOIN genres_movies AS gm USING(movie_id)
     JOIN genres AS g ON gm.genre_id = g.id
     WHERE g.name = 'History' AND `full_name` = CONCAT(a.first_name, ' ', a.last_name)
     );
     RETURN history_movies_count;

END$$ 

#11
DELIMITER $$
CREATE PROCEDURE udp_award_movie (movie_title VARCHAR(50))
BEGIN
     UPDATE actors AS a
     JOIN movies_actors AS ma ON a.id = ma.actor_id
     JOIN movies AS m ON ma.movie_id = m.id
     SET a.awards = a.awards + 1
     WHERE m.title = movie_title;
END$$    