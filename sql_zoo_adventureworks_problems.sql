/*
This file is an exercise in SQL skills and problem solving.
The reference material, questions, and a visual representation of the table's keys can be found at:
https://sqlzoo.net/wiki/AdventureWorks
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
-- 6. A "Single Item Order" is a customer order where only one item is ordered. Show the SalesOrderID and the UnitPrice for every Single Item Order.

SELECT salesorderid, unitprice
FROM SalesOrderDetail
WHERE orderqty = 1

-- 7. Where did the racing socks go? List the product name and the CompanyName for all Customers who ordered ProductModel 'Racing Socks'.

SELECT Product.name, Customer.companyname
FROM Product JOIN SalesOrderDetail
ON Product.productid = SalesOrderDetail.productid
JOIN SalesOrderHeader
ON SalesOrderDetail.salesorderid = SalesOrderHeader.salesorderid
JOIN Customer
ON SalesOrderHeader.customerid = Customer.customerid
JOIN ProductModel
ON Product.productmodelid = ProductModel.productmodelid
WHERE ProductModel.name = 'Racing Socks'

-- 8. Show the product description for culture 'fr' for product with ProductID 736.

SELECT ProductDescription.description
FROM ProductDescription JOIN ProductModelProductDescription
ON ProductDescription.productdescriptionid = ProductModelProductDescription.productdescriptionid
JOIN ProductModel
ON ProductModelProductDescription.productmodelid = ProductModel.productmodelid
JOIN Product
ON ProductModel.productmodelid = Product.productmodelid
WHERE ProductModelProductDescription.culture = 'fr' AND Product.productid = 736

-- 9. Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. For each order show the CompanyName and the SubTotal and the total weight of the order.

SELECT Customer.companyname, SalesOrderHeader.subtotal,
        SUM( Product.weight * SalesOrderDetail.orderqty ) AS total_weight
FROM Product JOIN SalesOrderDetail
ON Product.productid = SalesOrderDetail.productid
JOIN SalesOrderHeader
ON SalesOrderDetail.salesorderid = SalesOrderHeader.salesorderid
JOIN Customer
ON SalesOrderHeader.customerid = Customer.customerid
GROUP BY 1, 2
ORDER BY 3 DESC

-- 10. How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?

SELECT SUM(SalesOrderDetail.OrderQty) AS london_cranksets
FROM ProductCategory JOIN Product
ON ProductCategory.productcategoryid = Product.productcategoryid
JOIN SalesOrderDetail
ON Product.productid = SalesOrderDetail.productid
JOIN SalesOrderHeader
ON SalesOrderDetail.salesorderid = SalesOrderHeader.salesorderid
JOIN Address
ON SalesOrderHeader.shiptoaddressid = Address.addressid
WHERE ProductCategory.name = 'Cranksets' AND Address.city = 'London'
