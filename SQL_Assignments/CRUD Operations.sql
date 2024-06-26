/*
Exercise 1 - Create Table

Create table - courses
 - course_id - sequence generated integer and primary key
 - course_name - which holds alpha numeric or string values up to 60 characters
 - course_author - which holds the name of the author up to 40 characters
 - course_status - which holds one of these values (published, draft, inactive).
 - course_published_dt - which holds date type value.
*/
CREATE TABLE courses (
    course_id int IDENTITY,
    course_name VARCHAR(60) NOT NULL,
    course_author VARCHAR(40) NOT NULL,
    course_status VARCHAR(9) NOT NULL,
    course_published_dt DATE,
)


INSERT INTO courses
(course_name, course_author, course_status, course_published_dt)
VALUES('Programming using Python', 'Bob Dillon', 'published', '2020-09-30'),
('Data Engineering using Python', 'Bob Dillon', 'published', '2020-07-15'),
('Data Engineering using Scala', 'Elvis Presley', 'draft', ''),
('Programming using Scala', 'Elvis Presley', 'published', '2020-05-12'),
('Programming using Java', 'Mike Jack', 'inactive',	'2020-08-10'),
('Web Applications - Python Flask',	'Bob Dillon', 'inactive', '2020-07-20'),
('Web Applications - Java Spring',	'Mike Jack', 'draft', ''),
('Pipeline Orchestration - Python',	'Bob Dillon', 'draft', ''),
('Streaming Pipelines - Python', 'Bob Dillon', 'published',	'2020-10-05'),
('Web Applications - Scala Play', 'Elvis Presley', 'inactive', '2020-09-30'),
('Web Applications - Python Django', 'Bob Dillon', 'published',	'2020-06-23'),
('Server Automation - Ansible', 'Uncle Sam', 'published', '2020-07-05');

UPDATE courses
Set course_published_dt = NULL
WHERE course_published_dt = '1900-01-01'



UPDATE courses
SET course_status = 'published', course_published_dt = SYSDATETIME()
WHERE course_name LIKE '%Scala%' OR course_name LIKE '%Python%';

DELETE FROM courses
WHERE course_status != 'published' AND course_status != 'draft'

SELECT course_author, COUNT(course_id) as course_count
FROM courses
WHERE course_status = 'published'
GROUP BY course_author
ORDER BY course_count DESC

SELECT * FROM courses