/*
This file is an exercise in SQL skills and problem solving.
The reference material, questions, and a visual representation of the table's keys can be found at:
https://sqlzoo.net/wiki/Guest_House
SQL Zoo is free to use and disseminate as stated in their Terms and Conditions here:
https://sqlzoo.net/wiki/SQLZOO:About
*/

-- EASY QUESTIONS
-- 1. Guest 1183. Give the booking_date and the number of nights for guest 1183.

SELECT booking_date, nights
FROM booking
WHERE guest_id = 1183

-- 2. When do they get here? List the arrival time and the first and last names for all guests due to arrive on 2016-11-05, order the output by time of arrival.

SELECT booking.arrival_time, guest.first_name, guest.last_name
FROM booking JOIN guest
ON booking.guest_id = guest.id
WHERE booking.booking_date = '2016-11-05'
ORDER BY 1

-- 3. Look up daily rates. Give the daily rate that should be paid for bookings with ids 5152, 5165, 5154 and 5295. Include booking id, room type, number of occupants and the amount.

SELECT booking.booking_id, booking.room_type_requested, booking.occupants, rate.amount
FROM booking JOIN rate
ON booking.room_type_requested = rate.room_type
AND booking.occupants = rate.occupancy
WHERE booking.booking_id IN (5152, 5165, 5154, 5295)

-- 4. Who’s in 101? Find who is staying in room 101 on 2016-12-03, include first name, last name and address.

SELECT guest.first_name, guest.last_name, guest.address
FROM guest JOIN booking
ON guest.id = booking.guest_id
WHERE booking.room_no = 101 AND booking.booking_date = '2016-12-03'

-- 5. How many bookings, how many nights? For guests 1185 and 1270 show the number of bookings made and the total number of nights. Your output should include the guest id and the total number of bookings and the total number of nights.

SELECT guest_id, COUNT(nights), SUM(nights)
FROM booking
WHERE guest_id IN (1185, 1270)
GROUP BY guest_id

-- MEDIUM QUESTIONS
-- 6. Ruth Cadbury. Show the total amount payable by guest Ruth Cadbury for her room bookings. You should JOIN to the rate table using room_type_requested and occupants.

SELECT SUM(booking.nights*rate.amount) AS rc_total
FROM guest JOIN booking
ON guest.id = booking.guest_id
JOIN rate
ON booking.room_type_requested = rate.room_type
AND booking.occupants = rate.occupancy
WHERE guest.first_name = 'Ruth' AND guest.last_name = 'Cadbury'

-- 7. Including Extras. Calculate the total bill for booking 5346 including extras.

SELECT SUM( (booking.nights*rate.amount) + 
            (SELECT SUM(extra.amount) FROM extra WHERE extra.booking_id = 5346)
          )
FROM booking JOIN rate
ON booking.occupants = rate.occupancy
AND booking.room_type_requested = rate.room_type
WHERE booking.booking_id = 5346

-- 8. Edinburgh Residents. For every guest who has the word “Edinburgh” in their address show the total number of nights booked. Be sure to include 0 for those guests who have never had a booking. Show last name, first name, address and number of nights. Order by last name then first name.

SELECT guest.first_name, guest.last_name, guest.address,
        COALESCE(SUM(booking.nights), 0) AS nights
FROM guest LEFT JOIN booking
ON guest.id = booking.guest_id
GROUP BY 1, 2, 3
HAVING guest.address LIKE '%Edinburgh%'

-- 9. How busy are we? For each day of the week beginning 2016-11-25 show the number of bookings starting that day. Be sure to show all the days of the week in the correct order.

SELECT booking_date
FROM booking
WHERE booking_date = '20161125'

-- 10. How many guests? Show the number of guests in the hotel on the night of 2016-11-21. Include all occupants who checked in that day but not those who checked out.

SELECT SUM(occupants) AS pop
FROM booking
WHERE '2016-11-21' BETWEEN booking_date AND (booking_date + nights + -1)
