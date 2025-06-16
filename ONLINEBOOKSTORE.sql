-- create table 
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (

	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR (100),
	Author VARCHAR (100),
	Genre VARCHAR (50),
	Published_Year INT ,
	Price NUMERIC (10,2),
	Stock INT
	
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR (100),
	Email VARCHAR (100),
	Phone VARCHAR (15),
	City Varchar (50),
	Country VARCHAR (150)
	
);

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

select* from Books;
select* from Customers;
select* from Orders;


-- 	 IMPORT DATA INTO BOOKS TABLE
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\Program Files\PostgreSQL\17\SQL_Resume_Project-main\SQL_Resume_Project-main\Books.csv'
DELIMITER ','	
CSV HEADER;

-- IMPORT DATA INTO CUSTOMERS  TABLE
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\Users\Akshit Hari\Downloads\SQL_Resume_Project-main\SQL_Resume_Project-main\Customers.csv'
CSV HEADER;

---- IMPORT DATA INTO  ORDERS TABLE
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\Users\Akshit Hari\Downloads\SQL_Resume_Project-main\SQL_Resume_Project-main\Orders.csv'
CSV HEADER;

--select column_name , data_type is_nullable from information_schema.columns where table_name='Books'
ALTER TABLE Books alter column Book_ID drop default;

-----RETRIVE ALL THE BOOKS 'FICTION' GENRE
SELECT * FROM Books 
where genre='Fiction';


-----FIND THE BOOKS PUBLISHED AFTER YEAR 1950 

select*from Books 
where published_year >1950;


-----list all the customers from canada:
select * from Customers
where country='Canada';


-----show order place in november 2023
select * from Orders
where order_date between '2023-11-01'
and '2023-11-30';


--- retrive total stocks of avilable books:
select sum(stock)as total_stock from Books;



---- find the details of most expensive book
select * from Books order by price desc;


---show all the customers  who orderd more than 1 quantity of book
select * from  Orders 
where quantity>1;

----retrive all the orders where total ammount exceds $20
select*from Orders 
where total_amount >20;
----list all the genres avilavle in the books table
select distinct genre from Books;


----- find the books with lowest stock
select *from Books order by stock asc;

--- calculate the total revenue generate from orders;
select sum(total_amount)as revenue from Orders;
   ------


-------------------------ADVANCE QUESTIONS-------------------



---- RETRIVE THE TOTAL NUMBER OF OF BOKS SOLD FOR EACH GENRE 

SELECT b.Genre , sum (o.Quantity)as Total_Books_sold
from Orders o
join Books b on o.book_id=b.book_id
group by b.Genre;


------- find the average price of books in the "fantacy" genre
select avg(price)as avg_price from Books where genre='Fantasy';


----list customers who have placed at least 2 orders:
	select customer_id , count(order_id) as order_count from Orders group by customer_id	
	having count(order_id)>=2;
				

	select o.customer_id , c.name, count(o.order_id) as order_count from Orders o
	join customers c on o.customer_id	= c.customer_id
	group by o.customer_id	,c.name
	having count(order_id)>=2;


---- find the most frequently ordered book:

select Book_id , count(order_id) as order_count
	from Orders
	group by Book_id
	order by order_count desc limit 1 ;


select o.Book_id , b.title , count(order_id) as order_count
	from Orders o
	join books b on o.book_id=b.book_id
	group by o.Book_id , b.title
	order by order_count desc limit 1 ;

----show the top three expensive books of  fantasy genre:

select* from Books where  genre='Fantasy'
	 order by 	price  desc  limit 3;

---- retrive the total quantity of books ssold by each auther :

select b.author , sum(o.quantity) as total_books_sold
from orders o
join books b on o.book_id=b.book_id
group by b.author;


------list the citites where customers who spent over 30$ are located

select distinct c.city , total_amount
from orders o
join customers c on o.customer_id=c.customer_id
where o.total_amount>30;

----- find the customeer who spent the most orders

select c.customer_id , c.name , sum(o.total_amount)as total_spent
from orders o
join customers c on o.customer_id=c.customer_id
group by  c.customer_id  , c.name
order by total_spent desc ;


----- calculate the stock remaining after fulfilling all orders

select b.book_id , b.title , b.stock, coalesce (sum(o.quantity),0) as order_quantity , 
	b.stock - coalesce (sum(o.quantity),0) as remaining_quantity
from books b 
left join orders o on b.book_id = o.book_id
group by b.book_id;


