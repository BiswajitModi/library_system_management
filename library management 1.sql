--Library management System Project 2

--Create branch table
drop table if exists branch;
Create Table branch
              (
				 branch_id varchar(10) primary key,
				 manager_id varchar(10),
				 branch_address varchar(15),
				 contact_no varchar(10)
			  ) ;
alter table branch
alter column contact_no type varchar(20);
select * from branch

drop table if exists employees;
Create table employees
                  (
                    emp_id varchar(20) primary key,
					emp_name	varchar(50),
					position varchar(30),	
					salary	int,
					branch_id varchar(50)--FK
				  );
select * from employees

drop table if exists books;
Create table books
                (
                  isbn	varchar(20) primary key,
				  book_title varchar(100),	
				  category	varchar(30),
				  rental_price	float,
				  status	varchar(10),
				  author	varchar(100),
				  publisher varchar(50)
				 ) ;
select * from books 


drop table if exists members;
Create table members
                ( 
				   member_id	varchar(20) primary key,
				   member_name	varchar(25),
				   member_address	varchar(75),
				   reg_date date
				 ) ;
select * from  members

drop table if exists issued_status;
Create table issued_status
               (  
			     issued_id varchar(10) primary key,
				 issued_member_id	varchar(10),
				 issued_book_name	varchar(80),--FK
				 issued_date	date,
				 issued_book_isbn	varchar(30),--FK
				 issued_emp_id    varchar(10)--FK
			   );
select * from issued_status

drop table if exists return_status;
Create table return_status
               (  
			       return_id  varchar(15) primary key,
                   issued_id	varchar(10),
				   return_book_name varchar(10),
				   return_date	 date,
				   return_book_isbn  varchar(10)
               );
select * from return_status

--Foreign key

ALTER table issued_status
add constraint fk_members
foreign key (issued_member_id)
references members(member_id);


Alter table return_status
add constraint fk_issued_status
foreign key (issued_id)
references issued_status(issued_id);
 
Alter table issued_status
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn);


Alter table issued_status
add constraint fk_employees
foreign key (issued_emp_id)
references employees(emp_id);

Alter table employees
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);














