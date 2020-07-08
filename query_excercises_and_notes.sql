/* query excercises: projection (projection: column query, selection: record query, joining: bring data together from diff tables)
joins kind of remove the purpose of keys though?

common query terms/commands: select, *, from, where
select columns from entity

Guidelines for writing SQL
o	SQL statements not case sensitive
o	SQL statements can be one or more lines
o	Keywords cannot be abbreviated or split
o	Keywords entered in UPPERCASE
o	New clauses are placed on SEPARATE LINES
o	Indents to increase readability


aliases using AS keyword
- can be in columns or tables
- general use cases: calculations, missing headings
- USED with SELECT keyword, alias heading sshould be uppercase
- if alias name contains spaces/special characters (WHICH IT SHOULDNT) enclose in ''

arithmatic follows basic BIMDAS rules and brackets
NULL fields DOES NOT mean 0 or blanks, there has to be an entry assigned if declared a not null column


concatenation operators work with text based columns and aliases if desired, just like in other languages
e.g. select job_id + job_title as 'job id and title' from job;

Examples:
select distinct <column_name> from <table>
- returns only unique records

select first_name, last_name, gender from employee where gender = 'f'
- character values are NOT CASE SENSITIVE
- DATES are FORMAT SENSITIVE - default YYYY-MM-DD, check DB to see what the format is
- where clauses allow other compariosn operators <=, >= != etc.
- NUMERIC comparisons do NOT need ''
- SQL does not use ""

Other operators:
-between (inclusive)
- and (inclusive)
- NOT -> see MSDN for more info
- IN (test something equal to a value)
- LIKE ('character pattern')
	- Search character and numeric type checking
	- common wildcards available
- IS NULl
- IS NOT NULL
- Escape
	-treat next character as a literal instead of its semantic meaning
	- common use case is \ character or quotation marks
- More conditional operators for WHERE
	- AND, OR, NOT
	- Watch out for OR, can replace with IN
- ORDER BY clause
	- use last in select statement
	- ORDER BY <column> ASC
	- can't be used in WHERE clauses
- TOP clause
	- select top rows

More Data types for characters:
- char(n), varchar(n), text, nchar(n), nvarchar(n)
- fixed length, variable length, variable length, fixed length unicode, variable length unicode
- 8k, 8k, >8k, 4k, 4k sizing respectively
- char and varchar often used, with allowances
- text stores large amounts of unformatted text, lines and line breaks

Numeric data types
- tinyint, smallint, int, bigint
	- use int if unsure
- float, real, decimal, numeric, money and smallmoney
	- can specify unsigned (positive values only - doubles range of positive data by converting negative portion of the storage to positive range)
- decimal used more than float/real
- money, smallmoney same as decimal and numeric but no precision and scale needed to be specified
	- preicison: total no. of digits from left to right of decimal point
	- scale: total no. of digits to right of decimal point, default 0, max is precision

Data/time types
- datetime, smalldatetime, date, time
	- date more used
- other
	binary, bit, xml, table, image etc.
		- if you know what you're storing and size constraint, use smallest type but allow scalability

Tip: use char/varchar for phone numbers, but beaware of arithmatic only works with numerics

naming rules for db, table and columns
- begin with lettter or an _
- no whitespace/reserved words

Tips for general command usage:
- refresh object explorer in SSMS if objects (table, db etc.) not appearing
- columns can be given a default value
- IDENTITY option creates an auto-incrementing integer only for INT data type columns
	- parameters allow specifying initials and increment, otherwise start at 1 and increments by 1
	- use to create PK when one does not exist
- save a copy of table creation scripts
	- reuse to create DB structure in future/migration scripts
	update creation script after alter table operations performed
- add comments
- add drop table/database first so every time the script executes, creates everything from scratch each time (unless data needs to be preserved for whatever reason...)
- single line comment (--)
- blockc omment (/**/)
- add FK after tables created to avoid errors
	- can't reference something that wouldn't exist yet
	including self declarative/referencing recursive
- drop database if it exists -> create new db -> set current db using USE
- stored procedures, SSRS etc. and can generate ERDs in SSMS (advanced extras)
- Left side: object explorer
- Toolbar: bottom

CONSTRAINT
	- applies to table or columns
	- Maintain data integrity during an insert, update or delete
	- allows usage of null, not null, primary key/identity, unique, foriegn key
	- REFERENCES for key relationships are important
		- creation order is important
	- CHECK
		- limits values accepted by column with an expression
		- expression must equate true and use normal logic/arithmetic operators
		- CHecks for whenever insert or updating row of data
	- constraints on columns do not work for compound PKs, only on tables

ALTER
- add, alter or drop columns, tables
- use with check constraints to ensure no data loss from modifying or illegal data types added
- can't drop columns part of a constraint or using default value attached
	- these need to be removed first
	- e.g. drop constraint <constraint_name>
	- order is important when dropping constraints, e.g. FK constraints before the PK
- better ensure table properly created before adding these

Drop
- tables, databases, columns etc.

joins
(INNER) JOIN: Returns records that have matching values in both tables
LEFT (OUTER) JOIN: Returns all records from the left table, and the matched records from the right table
RIGHT (OUTER) JOIN: Returns all records from the right table, and the matched records from the left table
FULL (OUTER) JOIN: Returns all records when there is a match in either left or right table

create views for when you want to save joined tables etc.
- so you dont hasve to execute query again

*/

/* THE TABLES HAVE dbo in front of it BECAUSE YOU DIDN't PUT IT IN [] WHEN RUNNING SCRIPT! */

/* if not specify what kind of join, it will just do a full outer join */

--https://it.toolbox.com/question/sql-select-frm-table-except-one-column-071112
-- declarative language, have to unfortunately say I WANT ALL OF THESE and list them out, even in mizco work had to do that
--https://www.google.com/search?q=select+columns+except+sql&rlz=1C1GCEA_enAU867AU868&oq=select+columns+except+sql&aqs=chrome..69i57.8481j0j4&sourceid=chrome&ie=UTF-8

use practice_db;

select result.*,
	   student.*
from dbo.result


inner join student on result.student_id = student.student_id

