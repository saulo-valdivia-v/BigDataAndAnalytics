-- String Split
select title, value 
from hr.Employees
cross apply string_split(title, ' ')

select title, LEFT(title, CHARINDEX(' ', title)), RIGHT(title, LEN(title) - CHARINDEX(' ', title)) FROM HR.Employees