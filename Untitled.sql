CREATE DATABASE IF NOT EXISTS universityDB;
USE universityDB;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS departments;

SET FOREIGN_KEY_CHECKS = 1;

-- Part 1: Database Schema Design
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    department_id INT,
    instructor_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) ON DELETE SET NULL
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

CREATE TABLE class_schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    day_of_week VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Part 2: Sample Data Insertion
INSERT INTO departments (department_name) VALUES 
('Computer Science'),
('Mathematics'),
('Physics'),
('Business Administration'),
('Literature');

INSERT INTO instructors (instructor_name, department_id) VALUES 
('Dr. Alan Turing', 1),
('Dr. Katherine Johnson', 2),
('Dr. Albert Einstein', 3),
('Dr. Michael Porter', 4),
('Dr. Maya Angelou', 5);

INSERT INTO courses (course_title, department_id, instructor_id) VALUES 
('Database Systems', 1, 1),
('Data Structures', 1, 1),
('Linear Algebra', 2, 2),
('Calculus I', 2, 2),
('Quantum Mechanics', 3, 3),
('Microeconomics', 4, 4),
('Strategic Management', 4, 4),
('Modern Poetry', 5, 5);

INSERT INTO students (student_name, email, phone, department_id) VALUES 
('Alice Smith', 'alice@uni.edu', '555-0101', 1),
('Bob Jones', 'bob@uni.edu', '555-0102', 1),
('Charlie Brown', 'charlie@uni.edu', '555-0103', 2),
('Diana Prince', 'diana@uni.edu', '555-0104', 2),
('Evan Wright', 'evan@uni.edu', '555-0105', 3),
('Fiona Gallagher', 'fiona@uni.edu', '555-0106', 3),
('George Clark', 'george@uni.edu', '555-0107', 4),
('Hannah Abbott', 'hannah@uni.edu', '555-0108', 4),
('Ian Malcolm', 'ian@uni.edu', '555-0109', 5),
('Julia Roberts', 'julia@uni.edu', '555-0110', 5);

INSERT INTO enrollments (student_id, course_id, grade) VALUES 
(1, 1, 92.50),
(1, 2, 88.00),
(2, 1, 76.50),
(3, 3, 95.00),
(3, 4, 89.50),
(4, 3, 84.00),
(5, 5, 91.00),
(6, 5, 78.50),
(7, 6, 88.50),
(7, 7, 92.00),
(8, 6, 79.00),
(9, 8, 94.50),
(10, 8, 85.00),
(2, 2, 90.00),
(4, 4, 82.50);

INSERT INTO class_schedule (course_id, day_of_week, start_time, end_time, room_number) VALUES 
(1, 'Monday', '09:00:00', '10:30:00', 'Hall A'),
(2, 'Wednesday', '10:45:00', '12:15:00', 'Hall B'),
(3, 'Tuesday', '09:00:00', '10:30:00', 'Hall C'),
(4, 'Thursday', '13:00:00', '14:30:00', 'Hall A'),
(5, 'Friday', '10:00:00', '12:00:00', 'Lab 1'),
(6, 'Monday', '14:00:00', '15:30:00', 'Hall D'),
(7, 'Wednesday', '14:00:00', '15:30:00', 'Hall D'),
(8, 'Tuesday', '11:00:00', '12:30:00', 'Hall E');

-- Part 3: SQL Queries – CRUD & Joins
UPDATE students 
SET phone = '555-9999', email = 'alice.new@uni.edu' 
WHERE student_id = 1;

DELETE FROM enrollments WHERE course_id = 8;
DELETE FROM class_schedule WHERE course_id = 8;
DELETE FROM courses WHERE course_id = 8;

INSERT INTO enrollments (student_id, course_id, grade) VALUES (10, 7, 88.00);

SELECT s.student_id, s.student_name, s.email, s.phone, d.department_name 
FROM students s 
LEFT JOIN departments d ON s.department_id = d.department_id;

SELECT c.* 
FROM courses c 
JOIN instructors i ON c.instructor_id = i.instructor_id 
WHERE i.instructor_name = 'Dr. Alan Turing';

SELECT s.* 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN courses c ON e.course_id = c.course_id 
WHERE c.course_title = 'Database Systems';

-- Part 4: Aggregation & Grouping
SELECT d.department_name, COUNT(s.student_id) AS student_count 
FROM departments d 
LEFT JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id, d.department_name;

SELECT i.instructor_name, COUNT(c.course_id) AS course_count 
FROM instructors i 
LEFT JOIN courses c ON i.instructor_id = c.instructor_id 
GROUP BY i.instructor_id, i.instructor_name;

SELECT c.course_title, AVG(e.grade) AS average_grade 
FROM courses c 
JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id, c.course_title;

SELECT d.department_name, COUNT(s.student_id) AS student_count 
FROM departments d 
JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id, d.department_name 
ORDER BY student_count DESC 
LIMIT 1;

-- Part 5: Subqueries & Joins
SELECT * 
FROM students 
WHERE student_id NOT IN (SELECT student_id FROM enrollments WHERE student_id IS NOT NULL);

SELECT * 
FROM instructors 
WHERE instructor_id IN (
    SELECT instructor_id 
    FROM courses 
    GROUP BY instructor_id 
    HAVING COUNT(course_id) = (
        SELECT MAX(course_count) 
        FROM (
            SELECT COUNT(course_id) AS course_count 
            FROM courses 
            GROUP BY instructor_id
        ) AS counts
    )
);

SELECT s.student_name, c.course_title, e.grade 
FROM enrollments e 
JOIN students s ON e.student_id = s.student_id 
JOIN courses c ON e.course_id = c.course_id;



CREATE INDEX idx_student_name ON students(student_name);
CREATE INDEX idx_course_title ON courses(course_title);

CREATE OR REPLACE VIEW student_performance AS 
SELECT s.student_name, c.course_title, e.grade 
FROM enrollments e 
JOIN students s ON e.student_id = s.student_id 
JOIN courses c ON e.course_id = c.course_id;