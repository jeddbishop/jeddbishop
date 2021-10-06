/*
This file is an exercise in SQL skills and problem solving.
The reference material, questions, and a visual representation of the table's keys can be found at:
https://sqlzoo.net/wiki/Help_Desk
SQL Zoo is free to use and disseminate as stated in their Terms and Conditions here:
https://sqlzoo.net/wiki/SQLZOO:About
*/

-- EASY QUESTIONS
-- 1. There are three issues that include the words "index" and "Oracle". Find the call_date for each of them

SELECT call_date
FROM Issue
WHERE detail LIKE '%index%'
    AND detail LIKE '%Oracle%'
   
-- 2. Samantha Hall made three calls on 2017-08-14. Show the date and time for each

SELECT Issue.call_date
FROM Issue JOIN Caller
ON Issue.caller_id = Caller.caller_id
WHERE first_name = 'Samantha'
    AND last_name ='Hall'
    AND LEFT(call_date, 10) = '2017-08-14'

-- 3. There are 500 calls in the system (roughly). Write a query that shows the number that have each status.

SELECT status, COUNT(status) AS volume
FROM Issue
GROUP BY status

-- 4. Calls are not normally assigned to a manager but it does happen. How many calls have been assigned to staff who are at Manager Level?

SELECT COUNT(Issue.assigned_to) AS mlcc
FROM Issue JOIN Staff
ON Issue.assigned_to = Staff.staff_code
WHERE Staff.level_code IN (SELECT level_code FROM Level WHERE manager IS NOT NULL )

-- 5. Show the manager for each shift. Your output should include the shift date and type; also the first and last name of the manager.

SELECT Shift.shift_date, Shift.shift_type, Staff.first_name, Staff.last_name
FROM Shift JOIN Staff
ON Shift.manager = Staff.staff_code
ORDER BY shift_date
