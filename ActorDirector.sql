-- The most productive actor
Select Count(*) MovieCount, name
from MovieCredit
Where MovieCredit.role = 'ACTOR'
Group by name
order by 1 desc

/*
 Their movies
*/
Select name, character, title 
From MovieCredit
Join MovieTitle
	On MovieTitle.id = MovieCredit.id
	Where MovieCredit.name = 'Boman Irani' Or MovieCredit.name = 'Kareena Kapoor Khan'
Order by MovieTitle.title

/*
They play together in some movies
*/
Create Table #Temp_Productive
(Actor_name NVARCHAR(255),
Character_name NVARCHAR(255),
Movie_title NVARCHAR(255)
)

INSERT INTO #Temp_Productive
Select name, character, title 
From MovieCredit
Join MovieTitle
	On MovieTitle.id = MovieCredit.id
	Where MovieCredit.name = 'Boman Irani' Or MovieCredit.name = 'Kareena Kapoor Khan'
Order by MovieTitle.title

SELECT Movie_title, Count(Actor_name)
FROM #Temp_Productive
GROUP BY Movie_title
Having Count(Actor_name) > 1 

-- The most productive director
Select Count(*) MovieCount, name
from MovieCredit
Where MovieCredit.role = 'DIRECTOR'
Group by name
order by 1 desc

/* all of his movies */
Select * from MovieCredit
Join MovieTitle
	on MovieTitle.id = MovieCredit.id
Where MovieCredit.name = 'Raúl Campos'

/*  His average movie score  */
Select Avg(imdb_score) AvgIMDBScore
from MovieCredit
Join MovieTitle
	on MovieTitle.id = MovieCredit.id
Where MovieCredit.name = 'Raúl Campos'

-- Most productive Director/Actor with highest average IMDB score
Select name, Avg(imdb_score) as AvgScore, Count(title) as MoviesCount
From MovieCredit
Join MovieTitle
	on MovieTitle.id = MovieCredit.id
Where imdb_score is Not NULL and role = 'DIRECTOR' 
Group by name
Order by MoviesCount DESC, AvgScore DESC

Select name, Avg(imdb_score) as AvgScore, Count(title) as MoviesCount
From MovieCredit
Join MovieTitle
	on MovieTitle.id = MovieCredit.id
Where imdb_score is Not NULL and role = 'ACTOR' 
Group by name
Order by MoviesCount DESC, AvgScore DESC



