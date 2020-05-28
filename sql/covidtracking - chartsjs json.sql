select  datename(dw, convert(date,date)) as "Day of Week", 
	sum(convert(int, negativeIncrease)) as "Negative Test Results", 
	sum(convert(int, positiveIncrease)) as "Positive Test Results", 
	sum(convert(int, totalTestResultsIncrease)) as "Total Test Results",
	sum(convert(int, deathIncrease)) as "Deaths",
	count(*) as "Number of Occurrences in Dataset"
from covidtracking
where state = 'NJ'
group by datename(dw, convert(date,date)), datepart(dw, convert(date,date))
order by datepart(dw, convert(date,date))

select * from covidtracking where state = 'NJ' order by date

select convert(date,date) as "Date",
	convert(int, positive) as "Positive",
	convert(int, totalTestResults) as "Results",
	convert(int, death) as "Deaths" 
from covidtracking
where state = 'WI'
order by date asc

DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
DECLARE @State AS CHAR(2) = 'NJ'
select 'var sqlData = {labels: [' + STUFF ((
	select ',''' + convert(varchar,date) + ''''
	from (
		select convert(date,date) "date"
		from covidtracking
		where State = @State
		group by date, State
	) as x
	order by convert(date,date) 
	for xml path('')), 1, 1, '') + '],' + @NewLineChar + 
	'    totalcases: [' + STUFF ((
	select ',' + ISNULL(positive,'0')
	from (
		select positive, convert(date,date) "date"
		from covidtracking
		where state=@State
	) as x
	order by date
	for xml path('')), 1, 1, '') + '],' + @NewLineChar +
	'    totaltests: [' + STUFF ((
	select ',' + ISNULL(totalTestResults,'0')
	from (
		select totalTestResults, convert(date,date) "date"
		from covidtracking
		where state=@State
	) as x
	order by date
	for xml path('')), 1, 1, '') + '],' + @NewLineChar +
	'    totaldeaths: [' + STUFF ((
	select ',' + ISNULL(death,'0')
	from (
		select death, convert(date,date) "date"
		from covidtracking
		where state=@State
	) as x
	order by date
	for xml path('')), 1, 1, '') + '],' + @NewLineChar 
		+ '};' + @NewLineChar
	as list


