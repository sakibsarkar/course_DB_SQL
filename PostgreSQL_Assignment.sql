-- create Db
CREATE DATABASE university_db

-- * Create tables:
--student:
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    age INTEGER NOT NULL,
    email VARCHAR(100) NOT NULL,
    frontend_marks INTEGER NOT NULL,
    backend_marks INTEGER NOT NULL,
    "status" VARCHAR(20) DEFAULT NULL
);

--courses:
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY NOT NULL,
    course_name VARCHAR(50) NOT NULL,
    credits INTEGER NOT NULL
);

-- enrollments:
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY NOT NULL,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


-- * Insert data:

-- students:
INSERT INTO students (student_name, age, email, frontend_marks, backend_marks, "status")
VALUES
('Sameer', 21, 'sameer@example.com', 48, 60, NULL),
('Zoya', 23, 'zoya@example.com', 52, 58, NULL),
('Nabil', 22, 'nabil@example.com', 37, 46, NULL),
('Rafi', 24, 'rafi@example.com', 41, 40, NULL),
('Sophia', 22, 'sophia@example.com', 50, 52, NULL),
('Hasan', 23, 'hasan@gmail.com', 43, 39, NULL);

-- courses:
INSERT INTO courses (course_name,credits)
VALUES
('Next.js', 3),
('React.js', 4),
('Databases', 3),
('Prisma', 3);


-- enrollments:
INSERT INTO enrollments (enrollment_id, student_id, course_id)
VALUES 
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 3, 2);


--* Query:

-- Insert a new student record
INSERT INTO students (student_name, age, email, frontend_marks, backend_marks, "status")
VALUES
('Majnu vai', 21, 'majnu@vai.com', 48, 60, NULL);

-- Retrieve the names of all students who are enrolled in the course titled 'Next.js'.
SELECT s.student_name
FROM students AS s
JOIN enrollments AS e ON s.student_id = e.student_id -- JOINing the students with enrollments
JOIN courses AS c ON e.course_id = c.course_id -- joining the enrollments with courses
WHERE c.course_name = 'Next.js'; -- query for next.js course


--* Update the status of the student with the highest total (frontend_mark + backend_mark) to 'Awarded'.

-- view to get the id of the student with the highest total
CREATE VIEW highest_total AS 
  SELECT student_id FROM students
  ORDER BY frontend_marks + backend_marks DESC
  LIMIT 1;

-- uptdate query
UPDATE students
SET "status" = 'Awarded'
WHERE student_id = (
 SELECT * FROM highest_total
); -- sub query to get the id of the student with the highest total

--* Delete all courses that have no students enrolled.


-- view to retrive all course ids that have students enrolled
CREATE VIEW enrolled_courses AS
  SELECT course_id FROM enrollments ;

DELETE FROM courses
WHERE course_id NOT IN (
  SELECT * FROM enrolled_courses
); -- sub query to get all course ids that have no students enrolled


--* Retrieve the names of students using a limit of 2, starting from the 3rd student.
SELECT student_name
FROM students
ORDER BY student_id
LIMIT 2 OFFSET 2


--* Retrieve the course names and the number of students enrolled in each course.
SELECT course_name, COUNT(*) AS students_enrolled 
FROM enrollments 
JOIN courses ON enrollments.course_id = courses.course_id 
GROUP BY courses.course_id;

--* Calculate and display the average age of all students
SELECT AVG(age) AS average_age FROM students;

-- *Retrieve the names of students whose email addresses contain 'example.com'.
SELECT student_name FROM students
WHERE email LIKE '%@example.com' --qury for all that have @example.com at end
ORDER BY student_id

