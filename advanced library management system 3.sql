-- Sql Project - Library Management System N2

select * from books
where isbn = '978-0-330-25864-8'
where isbn = '978-0-330-25864-8'

select * from branch;
select * from employees;
select * from members;
select * from issued_status;
select * from return_status;


-- Task 13: Identify Members with Overdue Books
--Write a query to identify members who have overdue books (assume a 30-day return period). 
--Display the member's_id, member's name, book title, issue date, and days overdue.

-- issued_status == members == books == return_status
--filter books which is returned
-- overdue > 30 days

/*select * 
from  issued_status as ist
join 
members as m
   on m.member_id = ist.issued_member_id   */


select 
      ist.issued_member_id,
	  m.member_name,
	  b.book_title,
	  ist.issued_date,
	  --return.return_date,
	  current_date - ist.issued_date as over_dues_days
	  
from  issued_status as ist
join 
members as m
   on m.member_id = ist.issued_member_id 
join 
    books as b
	on b.isbn = ist.issued_book_isbn
left join
    return_status as return
    on  ist.issued_id = return.issued_id   
where return.return_date is null
and 
 (current_date - ist.issued_date) > 30 
 order by 1
   
--Task 14: Update Book Status on Return
--Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


select * from issued_status
where issued_book_isbn = '978-0-451-52994-2'

select * from books
where  isbn = '978-0-451-52994-2'

update books
set status = 'no'
where isbn = '978-0-451-52994-2'

select * from books;

select * from return_status
where issued_id = 'IS130'

--
insert into return_status(return_id, issued_id, return_date, book_quality)
values
('RS125', 'IS130', current_date, 'Good');
select * from return_status
where issued_id = 'IS130';


update books
set status = 'yes'
where isbn = '978-0-451-52994-2'

----store procedures-----p(means parameter )
create or replace procedure add_return_records(p_return_id varchar(10), p_issued_id varchar(10),  p_book_quality varchar(10))
 language plpgsql
 as $$

declare
      v_isbn varchar(50);
	  v_book_name varchar(80);

begin
 
    -- all your logic and code
    -- inserting into returns based on users input
      INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
	  VALUES
	  (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);
	  select 
	       issued_book_isbn,
		   issued_book_name
		   into
		   v_isbn,
		   v_book_name
	 from issued_status
	 where issued_id = p_issued_id;

     update books
	 set status = 'yes'
	 where isbn = 'v-isbn';
	 Raise notice 'Thank You for returning the book: %',v_book_name ;
	 

end;
$$

call add_return_records();

--Testing Functions add_return_records();

select * from issued_status
where issued_id = 'IS135'

select * from issued_status
where issued_id = 'IS135'

select * from  books 
where isbn = '978-0-307-58837-1';

select * from issued_status
where  issued_book_isbn = '978-0-375-41398-8'
where issued_book_isbn = '978-0-307-58837-1'

select * from return_status
where issued_id = 'IS135';

-- calling functions
call add_return_records('RS138', 'IS135', 'Good');
call add_return_records('RS148', 'IS140', 'Good');

call add_return_records('RS136', 'IS134', 'Good');


update books
set status = 'no'
where isbn = '978-0-330-25864-8'

--Task 15: Branch Performance Report
--Create a query that generates a performance report for each branch, showing the number of books issued, 
--the number of books returned, and the total revenue generated from book rentals.


select * from branch

select * from issued_status

select * from employees

select * from books

select * from return_status

create table branch_reports
    as

select 
    b.branch_id,
	b.manager_id,
	count(ist.issued_id) as number_book_issued,
	count(rs.return_id) as number_of_book_return,
	sum(bk.rental_price) as total_revenue
   from issued_status as ist
   join employees as el
   on el.emp_id  = ist.issued_emp_id
   join
   branch as b
   on el.branch_id = b.branch_id
   left join 
   return_status as rs
   on rs.issued_id = ist.issued_id
   join books as bk
   on ist.issued_book_isbn = bk.isbn
   group by 1,2
   
select * from branch_reports


--Task 16: CTAS: Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members 
--who have issued at least one book in the last 2 months.
select * from members
select * from issued_status
drop table if exists Active_Members;
Create table Active_Members
as
Select 
      m.member_id,
	  m.member_name,
	  m.member_address,
	  m.reg_date,
	  ist.issued_date
 from members as m
 join issued_status as ist
 on m.member_id = ist.issued_member_id
 WHERE 
       issued_date >= CURRENT_DATE - INTERVAL '2 month'
;

select * from Active_Members

----OR we can write Alternative code as

CREATE TABLE active_member
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;

select * from active_member


--Task 17: Find Employees with the Most Book Issues Processed
--Write a query to find the top 3 employees who have processed the most book issues. 
--Display the employee name, number of books processed, and their position.

select * from branch
select * from employees
select * from books
select * from issued_status
select 
      el.emp_name,
	  b.*,
      COUNT(ist.issued_id) as no_book_issued

      from branch as b
	  join employees as el
	  on el.branch_id = b.branch_id
	  join issued_status as ist
	  on ist.issued_emp_id = el.emp_id
	  group by 1,2

/*
Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a 
library system. 

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 

The procedure should first check if the book is available (status = 'yes'). If the book is available, 
it should be issued, and the status in the books table should be updated to 'no'. If the book is 
not available (status = 'no'), 

the procedure should return an error message indicating that the book is currently not available.
*/

select * from books
select * from issued_status

create or replace procedure issue_book(p_issued_id varchar(10), p_issued_member_id varchar(30), p_issued_book_isbn varchar(30), p_issued_emp_id varchar(10))
language plpgsql
as $$


declare
--all the variables
      v_status varchar(10);


begin
-- all the code
--checking if book is available 'yes'
select 
     status
	 into 
	 v_status
from books
where isbn = p_issued_book_isbn;

if v_status = 'yes' then
  insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
  values
       (p_issued_id, p_issued_member_id, current_date, p_issued_book_isbn, p_issued_emp_id);
     
	 update books
	 set status = 'no'
	 where isbn = 'p_issued_book_isbn';  
	 
RAISE NOTICE 'Book records added successfully for book isbn: %', p_issued_book_isbn;

else
    RAISE NOTICE 'sorry to inform you the you have requeated is unavailable book_isbn  : %', p_issued_book_isbn ;

end if;

end;
$$


-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'
