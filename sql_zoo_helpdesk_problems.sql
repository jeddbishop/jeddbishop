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

-- MEDIUM QUESTIONS
-- 6. List the Company name and the number of calls for those companies with more than 18 calls.

SELECT Customer.company_name, COUNT(Issue.call_ref) AS cc
FROM Customer JOIN Caller
ON Customer.company_ref = Caller.company_ref
JOIN Issue
ON Caller.caller_id = Issue.caller_id
GROUP BY 1
HAVING cc > 18

-- 7. Find the callers who have never made a call. Show first name and last name

SELECT Caller.first_name, Caller.last_name
FROM Caller LEFT JOIN Issue
ON Caller.caller_id = Issue.caller_id
WHERE Issue.caller_id IS NULL

-- 8. For each customer show: Company name, contact name, number of calls where the number of calls is fewer than 5

SELECT Customer.company_name, Caller.first_name, Caller.last_name, COUNT(Issue.call_ref) AS calls
FROM Customer JOIN Caller
ON Customer.company_ref = Caller.company_ref
JOIN Issue
ON Caller.caller_id = Issue.caller_id
GROUP BY 1, 2, 3
HAVING calls < 5

-- 9. For each shift show the number of staff assigned. Beware that some roles may be NULL and that the same person might have been assigned to multiple roles (The roles are 'Manager', 'Operator', 'Engineer1', 'Engineer2').

SELECT shift_date, shift_type,
    COUNT(
        CASE WHEN manager IS NOT NULL AND manager != operator THEN 1 ELSE 0 END +
        CASE WHEN operator IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN engineer1 IS NOT NULL AND engineer1 != engineer2 THEN 1 ELSE 0 END +
        CASE WHEN engineer2 IS NOT NULL THEN 1 ELSE 0 END 
         ) AS cw
FROM Shift
GROUP BY 1, 2

-- 10. Caller 'Harry' claims that the operator who took his most recent call was abusive and insulting. Find out who took the call (full name) and when.

SELECT Staff.first_name, Staff.last_name, Issue.call_date
FROM Staff JOIN Issue
ON Staff.staff_code = Issue.taken_by
JOIN Caller
ON Issue.caller_id = Caller.caller_id
WHERE Caller.first_name = 'Harry'
ORDER BY call_date DESC
LIMIT 1
