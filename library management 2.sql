select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status;
select * from members;

--Project Task

-- Task 1. Create a New book Recordd -- ("978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn, book_title , category, rental_price, status, author, publisher)
values
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;

--Task 2: Update an Existing Member's Address UPDATE members
--SET member_address = '125 Oak St'
--WHERE member_id = 'C103';

UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
select * from members;


--Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

delete  from issued_status
where issued_id = 'IS121' ;
select * from issued_status ;

--Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status 
where issued_emp_id = 'E101';


--Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

select 
     issued_emp_id,
	 count(*)
from issued_status
Group by 1
having count(*)>1;


--CTAS(create table as select statements)
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

create table book_cnts
as
select 
      b.isbn,
	  b.book_title,
	  count(ist.issued_id) as no_of_times_issued
from books as b
join 
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1,2;

select * from book_cnts;

-- Retrieve All Books in a Specific Category:
-- we can use anyone from below

SELECT * 
FROM books 
WHERE category IN ('Classic', 'Mystery'); 

/*SELECT * 
FROM books 
WHERE category = 'Classic' OR category = 'Mystery';  */


--8. Task 8: Find Total Rental Income by Category: 
select 
      b.category,
	   sum(b.rental_price) as Total_Rental_income,
	   count(*)
from 
issued_status as ist
join 
books as b
ON b.isbn = ist.issued_book_isbn
group by 1

--9.List Members Who Registered in the Last 180 Days:

/*wrong  select
    extract(date from reg_date) as no_of_days,
	count(*)
from members
group by 1
having count(*)<180   */

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';


insert into members(member_id, member_name, member_address, reg_date)
values
('C120', 'Sam', '145 Main St', '2025-06-01' ),
('C125','john', '133 Main St', '2025-05-01')


--10.	List Employees with Their Branch Manager's Name and their branch details:


--select * from branch
--select * from employees
select 
     el.*,
	 b.manager_id,
	 e2.emp_name as manager
from employees as el
join
branch as b
on b.branch_id = el.branch_id
join
employees as e2
on b.manager_id = e2.emp_id

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE books_price_greater_than_seven 
as
SELECT * from books
WHERE rental_price > 7

select * from books_price_greater_than_seven ;


--Task 12: Retrieve the List of Books Not Yet Returned

select 
     distinct issue.issued_book_name
from issued_status as issue
left join
return_status as returned
on issue.issued_id = returned.issued_id
WHERE returned.return_id IS NULL;


