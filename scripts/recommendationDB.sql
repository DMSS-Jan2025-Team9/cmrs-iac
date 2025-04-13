CREATE DATABASE recommendation_db;
USE recommendation_db;

CREATE TABLE recommendation (
    recommendation_id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    course_id INT NOT NULL
);

/* Sample data */
INSERT INTO recommendation (program_id, course_id) VALUES
(1, 1), -- Bachelor of Computer Science -> Introduction to Computer Science
(1, 2), -- Bachelor of Computer Science -> Advanced Database Systems
(1, 5), -- Bachelor of Computer Science -> Data Structures and Algorithms
(2, 4), -- Master of Data Science -> Machine Learning with Python
(2, 6), -- Master of Data Science -> Cloud Computing Basics
(3, 7); -- Bachelor of Cybersecurity -> Cybersecurity Fundamentals