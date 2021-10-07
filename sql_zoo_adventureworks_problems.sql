/*
This file is an exercise in SQL skills and problem solving.
The reference material, questions, and a visual representation of the table's keys can be found at:
https://sqlzoo.net/wiki/Guest_House
SQL Zoo is free to use and disseminate as stated in their Terms and Conditions here:
https://sqlzoo.net/wiki/SQLZOO:About
*/

-- EASY QUESTIONS
-- 1. Show the first name and the email address of customer with CompanyName 'Bike World'

SELECT Customer.firstname, Customer.emailaddress
FROM Customer
WHERE companyname = 'Bike World'

-- 2. Show the CompanyName for all customers with an address in City 'Dallas'.

SELECT Customer.companyname
FROM Customer JOIN CustomerAddress
ON Customer.customerid = CustomerAddress.customerid
JOIN Address
ON CustomerAddress.addressid = Address.addressid
WHERE Address.city = 'Dallas'

-- 3. How many items with ListPrice more than $1000 have been sold?

SELECT SUM(SalesOrderDetail.orderqty) AS over_thousand
FROM SalesOrderDetail JOIN Product
ON SalesOrderDetail.productid = Product.productid
WHERE Product.listprice > 1000

-- 4. Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight.

SELECT Customer.companyname
FROM Customer JOIN SalesOrderHeader
ON Customer.customerid = SalesOrderHeader.customerid
GROUP BY 1
HAVING SUM(SalesOrderHeader.subtotal + SalesOrderHeader.taxamt + SalesOrderHeader.freight) > 100000

-- 5. Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'

SELECT SUM(SalesOrderDetail.orderqty) AS qty
FROM SalesOrderDetail JOIN Product
ON SalesOrderDetail.productid = Product.productid
JOIN SalesOrderHeader
ON SalesOrderDetail.salesorderid = SalesOrderHeader.salesorderid
JOIN Customer
ON SalesOrderHeader.customerid = Customer.customerid
WHERE Product.Name = 'Racing Socks, L' AND Customer.companyname = 'Riding Cycles'

-- MEDIUM QUESTIONS
-- 6. 
