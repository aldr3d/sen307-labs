USE sen307_11249;

-- Task 1: Count the students enrolled in each course, grouped by course. Include courses with zero students.
SELECT c.course_id, c.course_title, COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
ORDER BY total_students DESC;

-- Task 2: Find the courses with more than a given number of students, using HAVING. Try thresholds of 3, 5 and 7.
SELECT c.course_id, c.course_title, COUNT(e.student_id) AS total_students
FROM Course c
JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
HAVING COUNT(e.student_id) > 7
ORDER BY total_students DESC;

-- Task 3: Calculate the average number of courses taken per student, including students with zero courses.
-- Course per student
SELECT s.student_id, s.full_name, COUNT(e.course_id) AS course_count
FROM Student s
LEFT JOIN Enrolment e ON s.student_id = e.student_id
GROUP BY s.student_id, s.full_name;

-- Average
SELECT ROUND(AVG(course_count), 2) AS avg_courses_per_student
FROM (
  SELECT s.student_id, COUNT(e.course_id) AS course_count
  FROM Student s
  LEFT JOIN Enrolment e ON s.student_id = e.student_id
  GROUP BY s.student_id
) AS per_student;

-- Task 4: Find the students who are not enrolled in any course.
SELECT student_id, matric_no, full_name
FROM Student
WHERE student_id NOT IN (SELECT student_id FROM Enrolment)
ORDER BY full_name;

-- Task 5: For each department, find the student with the highest number of enrolments. Ties are allowed.
SELECT d.dept_name, s.full_name,
  (SELECT COUNT(*) FROM Enrolment e WHERE e.student_id = s.student_id) AS courses
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id
WHERE (SELECT COUNT(*) FROM Enrolment e WHERE e.student_id = s.student_id)
    = (SELECT MAX(per_student.cnt)
       FROM (SELECT s2.student_id, COUNT(e2.student_id) AS cnt
             FROM Student s2
             LEFT JOIN Enrolment e2 ON e2.student_id = s2.student_id
             WHERE s2.dept_id = s.dept_id
             GROUP BY s2.student_id) AS per_student)
ORDER BY d.dept_name, s.full_name;