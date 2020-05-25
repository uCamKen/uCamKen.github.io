select top 5 * from nytdata


DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
select 'labels: [' + STUFF ((
	select ',''' + date + ''''
	from (
		select date 
		from nytdata
		where State = 'New Jersey'
		group by date, State
	) as x
	order by date
	for xml path('')), 1, 1, '') + '],' + @NewLineChar + 
	'datasets: [{' + @NewLineChar +
	'    type: ''line'',' + @NewLineChar +
	'    label: ''Total Cases'',' + @NewLineChar +
	'    backgroundColor: ''rgb(255,99,132)'',' + @NewLineChar +
	'    borderColor: ''rgb(255,99,132)'',' + @NewLineChar +
	'    fill: false,' + @NewLineChar +
	'    yAxisID: ''y-axis-1'',' + @NewLineChar + 
	'    data: [' + STUFF ((
	select ',' + ISNULL(convert(varchar, cases),'')
	from (
		select state,date,sum("Total Cases") as cases
		from nytdata
		where state = 'New Jersey'
		group by date, state
	) as x
	order by state, date
	for xml path('')), 1, 1, '') + ']' + @NewLineChar +
	'},{' + @NewLineChar +
	'    type: ''line'',' + @NewLineChar +
	'    label: ''New Cases Past 14 Days'',' + @NewLineChar +
	'    backgroundColor: ''rgb(132,99,255)'',' + @NewLineChar +
	'    borderColor: ''rgb(132,99,255)'',' + @NewLineChar +
	'    fill: true,' + @NewLineChar +
	'    yAxisID: ''y-axis-2'',' + @NewLineChar + 
	'    data: [' + STUFF ((
	select ',' + ISNULL(convert(varchar, cases),'')
	from (
		select state,date,sum("New Cases 14 Days") as cases
		from nytdata
		where state = 'New Jersey'
		group by date, state
	) as y
	order by state, date
	for xml path('')), 1, 1, '') + ']' + @NewLineChar +
	'},{' + @NewLineChar +
	'    type: ''bar'',' + @NewLineChar +
	'    label: ''New Cases Today'',' + @NewLineChar +
	'    backgroundColor: ''rgb(132,255,99)'',' + @NewLineChar +
	'    borderColor: ''rgb(132,255,99)'',' + @NewLineChar +
	'    fill: true,' + @NewLineChar +
	'    yAxisID: ''y-axis-2'',' + @NewLineChar + 
	'    data: [' + STUFF ((
	select ',' + ISNULL(convert(varchar, cases),'')
	from (
		select state,date,sum("New Cases") as cases
		from nytdata
		where state = 'New Jersey'
		group by date, state
	) as y
	order by state, date
	for xml path('')), 1, 1, '') + ']' + @NewLineChar +
	'}]' + @NewLineChar
	as list

