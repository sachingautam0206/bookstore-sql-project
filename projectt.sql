-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Program Files\PostgreSQL\17\Books.csv' 
delimiter','
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Program Files\PostgreSQL\17\Customers.csv' 
delimiter ','
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Program Files\PostgreSQL\17\Orders.csv' 
delimiter ','
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books 
where Genre='Fiction';


-- 2) Find books published after the year 1950:
select * from Books
where published_year>1950;


-- 3) List all customers from the Canada:
select * from Customers
where country='Canada';


-- 4) Show orders placed in November 2023:
select * from Orders
where order_date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
select sum(stock) as total_stock from Books;

-- 6) Find the details of the most expensive book:
select max(price) as highest_price from Books;
--or
select * from Books order by price DESC;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders
where total_amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre from Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books order by stock ASC;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) as total_revenue from orders;

-- Advance Questions : 



SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve the total number of books sold for each genre:
select b.genre,sum(o.quantity) as total_book_sold
from Orders o
join Books b on o.book_id=b.book_id
group by b.genre;


-- 2) Find the average price of books in the "Fantasy" genre:
select avg(price) as average_price
from Books
where genre='Fantasy';


-- 3) List customers who have placed at least 2 orders:
SELECT
	CUSTOMER_ID,
	COUNT(ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS
GROUP BY
	CUSTOMER_ID
HAVING
	COUNT(ORDER_ID) >= 2;
--or with name
select c.customer_id,c.name,count(o.order_id) as order_count
from Orders o
join Customers c on o.customer_id=c.customer_id
group by c.customer_id
having count(order_id)>=2;

-- 4) Find the most frequently ordered book:
select ,book_id,count(order_id) as order_count
from Orders
group by book_id
order by order_count desc;

-- for book name

select b.title,b.book_id,count(o.order_id) as order_count
from Orders o
join Books b on b.book_id=o.book_id
group by b.book_id
order by order_count desc;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from Books
where genre='Fantasy'
order by price desc limit 3;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 6) Retrieve the total quantity of books sold by each author:
select b.author,sum(o.quantity) as total_books_sold
from Orders o
join Books b on o.book_id=b.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located:
select distinct c.city, o.total_amount
from Customers c
join Orders o on o.customer_id=c.customer_id
where total_amount>300;

-- 8) Find the customer who spent the most on orders:
select c.customer_id,c.name,sum(o.total_amount) as total_spent
from Orders o join Customers c on o.customer_id=c.customer_id
group by c.customer_id,c.name
order by total_spent desc;

--my querry
select c.name,sum(o.total_amount ) as total_spent
from Customers c join Orders o on o.customer_id=c.customer_id
group by c.customer_id,c.name
order by total_spent desc limit 1;




--9) Calculate the stock remaining after fulfilling all orders:

select b.book_id,b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join Orders o on b.book_id=o.book_id
group by b.book_id
order by b.book_id ;







