/* Automatically selects master unless you specifically tell it not to */

/*
create table student
(
student_id [int] not null primary key,
first_name [varchar](20) not null,
surname [varchar](20) not null,
gender [char](1) not null,
dob [date] not null,
phone [varchar](10) null,
email [varchar](50) null,
height [numeric](3,2) null
);
*/

/*
Use master
drop table student;
*/

if exists(select name = 'practice_db')
begin
	use master /* add this because can't drop db if it is in use, so switch temporarily to master */
	drop database [practice_db]
	print 'practice_db dropped'
end
go

create database [practice_db]
print 'practice_db created'
go


use [practice_db]
go


create table dbo.result(
	result_id int identity(1,1) not null,
	student_id int not null,
	unit_code char(7) not null,
	semester tinyint not null,
	[year] smallint not null,
	ass_1 int not null,
	ass_2 int not null,
	exam int not null,
	/* insert computed columns here */
	unit_mark as ass_1 + ass_2 + exam,
	grade as(
		case
			when ass_1 + ass_2 + exam <= 49 then 'f'
			when ass_1 + ass_2 + exam >= 50 and ass_1 + ass_2 + exam <= 59 then 'p'
			when ass_1 + ass_2 + exam >= 60 and ass_1 + ass_2 + exam <= 69 then 'c'
			when ass_1 + ass_2 + exam >= 70 and ass_1 + ass_2 + exam <= 79 then 'd'
			when ass_1 + ass_2 + exam >= 80 and ass_1 + ass_2 + exam <=100 then 'hd'
		else
			null
		end)
	CONSTRAINT [PK_result] PRIMARY KEY CLUSTERED 
	(
		[result_id] ASC
	)
)
go

/****** Object:  Table [dbo].[student]    Script Date: 22/10/2017 11:25:42 PM ******/
CREATE TABLE [dbo].[student](
	[student_id] [int] NOT NULL,
	[student_first_name] [varchar](50) NOT NULL,
	[student_last_name] [varchar](50) NOT NULL,
	[photo] [nvarchar](max) NOT NULL,

	CONSTRAINT [PK_student] PRIMARY KEY CLUSTERED 
		(
			student_id ASC
		)
	)
GO

/****** Object:  Table [dbo].[unit]    Script Date: 22/10/2017 11:25:42 PM ******/
CREATE TABLE [dbo].[unit](
	[unit_code] [char](7) NOT NULL,
	[unit_title] [varchar](50) NOT NULL,
	[unit_coordinator] [varchar](50) NOT NULL,
	[unit_outline_pdf_document] [nvarchar](max) NOT NULL,


	CONSTRAINT [PK_unit] PRIMARY KEY CLUSTERED 
	(
		[unit_code] ASC
	)
)
GO

/* Tables created, now create the relationships, you can also do it when defining the constraints but I like it this way */
/* check constraints limit value ranges allowed to be placed in column */
/* here a check is being placed on the FK relationship */

alter table dbo.result with check
	add constraint fk_result_student foreign key (student_id) references dbo.student (student_id)
go

alter table dbo.result check constraint fk_result_student
go

alter table dbo.result with check add constraint fk_result_unit foreign key (unit_code) references dbo.unit (unit_code)
go

alter table dbo.result check constraint fk_result_unit
go

alter table dbo.result with check add constraint ck_ass1 check ((ass_1 >= 0 and ass_1 <=20))
go

alter table dbo.result check constraint ck_ass1
go

alter table dbo.result with check add constraint ck_ass2 check ((ass_2 >= 0 and ass_2 <=20))
go

alter table dbo.result check constraint ck_ass2
go

alter table dbo.result with check add constraint ck_exam check ((exam >= 0 and exam <= 60))
go

alter table dbo.result check constraint ck_exam
go

alter table dbo.result with check add constraint ck_semester check ((semester like '[1-2]'))
go

alter table dbo.result check constraint ck_semester
go

alter table dbo.result with check add constraint ck_year check ((len(convert(char(4), [year])) = 4))
go

alter table dbo.result check constraint ck_year
go

/* add key relationships and constraints to student table */
alter table dbo.student with check add constraint ck_student_id check ((student_id like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
go

alter table dbo.student check constraint ck_student_id
go

/* add key relationships and constraints to unit table */
alter table dbo.unit with check add constraint ck_unit_code check ((unit_code like '[a-zA-Z][a-zA-Z][a-zA-Z][0-9][0-9][0-9][0-9]'))
go

alter table dbo.unit check constraint ck_unit_code
go

/* insert dummy values into database */
insert into dbo.unit (unit_code, unit_title, unit_coordinator, unit_outline_pdf_document)
	values ('SCI1125', 'Professional Science Essentials', 'Dr Anna Jenny Hopkins', '~/UnitOutlines/302269 Risk Management 421 Semester 1 2013 Bentley Campus INT.pdf'),
						('ENS1161', 'Computer Fundamentals', 'Dr Wlodzimierz Gornisiewicz', '~/UnitOutlines/307594 Engineering, Its Evolution, Development, Successes and Failures 100.pdf'),
						('CSP1150', 'Programming Principles', 'Dr Gregory Baatard', '~/UnitOutlines/310206 Engineering Foundations  Principles and Communications 100.pdf'),
						('CSI1241', 'Systems Analysis', 'Dr Syed Mohammed Islam', '~/UnitOutlines/20170501-Junior-Developer-Role-Description.pdf');
print 'Dummy data inserted into units table...'
go

insert into dbo.student (student_id, student_first_name, student_last_name, photo)
	values (99573784 , 'Blinky', 'Bill', '~/Photos/koala.jpeg'),
						(11111111, 'Lion', 'King', '~/Photos/lion.jpeg'),
						(22222222, 'Henry', 'Duck', '~/Photos/duck.jpeg'),
						(33333333, 'Fred', 'Baboon', '~/Photos/baboon.jpeg');
print 'dummy data inserted into students table...'
go

insert into dbo.result (student_id, unit_code, semester, [year], ass_1, ass_2, exam)
	values ((select student_id from dbo.student where student_id = 99573784), (select unit_code from dbo.unit where unit_code = 'SCI1125'), 1, 2011, 18, 17, 30),
						((SELECT [student_id] FROM [dbo].[student] WHERE [student_id] = 11111111),(SELECT [unit_code] FROM [dbo].[unit] WHERE [unit_code] = 'ENS1161'), 1, 2012, 9, 20, 26),
						((SELECT [student_id] FROM [dbo].[student] WHERE [student_id] = 22222222),(SELECT [unit_code] FROM [dbo].[unit] WHERE [unit_code] = 'CSP1150'), 2, 2013, 19, 20, 34),
						((SELECT [student_id] FROM [dbo].[student] WHERE [student_id] = 33333333),(SELECT [unit_code] FROM [dbo].[unit] WHERE [unit_code] = 'CSI1241'), 2, 2015, 20, 20, 50);
						
print 'dummy data inserted into results table...'
go


/* IT IS BETTER AND CLEARER FOR YOU TO PUT THE [] around column headers to DISCERN FROM system types e.g. [year] becomes pink because it is a reserved as a type and it may
work but better to be safe!
-Also, inserting query values into the results table is a bit weird, was getting syntax error, but it's because of the brackets.... and the way the values keyword works
*/

/* not sure if try/catch blocks maybe better instead of checks */
/* probably should insert data BEFORE altering table, delcaring relations etc. but in this case because its a new db and i'm inserting it myself, want to check
the data is valid or not before saving in the DB. Normally, would check this on the logic/server side layer...
*/

/*IMPORTANT!!! You can't delete STUDENT and UNICODE records that have FK CONSTRAINTS DEPENDENCIES! These must be deleted from the results table FIRST before you can delete from the primary key tables.
YOU SHOULD PROGRAM SOME LOGIC TO HANDLE EXCEPTIONS AND DISPLAY ERROR MESSAGE TO USER IN THIS CASE WITH TRY CATCH in the application*/
