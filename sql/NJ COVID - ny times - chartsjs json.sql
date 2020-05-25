select top 5 * from nytdata


DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
select 'var sqlCasesData = {labels: [' + STUFF ((
	select ',''' + date + ''''
	from (
		select date 
		from nytdata
		where State = 'New Jersey'
		group by date, State
	) as x
	order by date
	for xml path('')), 1, 1, '') + '],' + @NewLineChar + 
	'    totalcases: [' + STUFF ((
	select ',' + ISNULL(convert(varchar, cases),'')
	from (
		select state,date,sum("Total Cases") as cases
		from nytdata
		where state = 'New Jersey'
		group by date, state
	) as x
	order by state, date
	for xml path('')), 1, 1, '') + '],' + @NewLineChar +
	'    cases14days: [' + STUFF ((
	select ',' + ISNULL(convert(varchar, cases),'')
	from (
		select state,date,sum("New Cases 14 Days") as cases
		from nytdata
		where state = 'New Jersey'
		group by date, state
	) as y
	order by state, date
	for xml path('')), 1, 1, '') + '],' + @NewLineChar +
	'    casesToday: [' + STUFF ((
	select ',' + ISNULL(convert(varchar, cases),'')
	from (
		select state,date,sum("New Cases") as cases
		from nytdata
		where state = 'New Jersey'
		group by date, state
	) as y
	order by state, date
	for xml path('')), 1, 1, '') + ']' + @NewLineChar +
	'};' + @NewLineChar
	as list

