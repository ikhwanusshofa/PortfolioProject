
SELECT *
FROM PortfolioProject..CovidDeath
Where continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVax
--ORDER BY 3,4

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeath
--ORDER BY 1,2

----Total cases vs total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS 'DeathPercentage(%)'
FROM PortfolioProject..CovidDeath
WHERE location like '%indonesia%'
ORDER BY 1,2

--Total cas vs Population
--SELECT location, date, total_cases, population, (total_cases/population)*100 AS 'CasesPercentage(%)'
--FROM PortfolioProject..CovidDeath
--WHERE location like '%indonesia%'
--ORDER BY 5 DESC

SELECT location, population, MAX(total_cases) AS'HighestCases', MAX((total_cases/population))*100 AS 'CasesPercentage(%)'
FROM PortfolioProject..CovidDeath
--WHERE location like '%indonesia%'
GROUP BY location, population
ORDER BY 4 DESC


-- SHOWING THE COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION
SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
--WHERE location like '%indonesia%'
Where continent is not null
GROUP BY location, population
ORDER BY 2 DESC


--lets break things down by continent
SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
--WHERE location like '%indonesia%'
Where continent is null
GROUP BY location
ORDER BY 2 DESC

--SHOWING THE CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION
SELECT continent, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
--WHERE location like '%indonesia%'
Where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, 
	(SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as total_percentage --total_cases, total_deaths, (total_deaths/total_cases)*100 AS 'DeathPercentage(%)'
FROM PortfolioProject..CovidDeath
--WHERE location like '%indonesia%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


--use cte
With PopvsVax (continent, location, date, population, new_vaccinations, rolling_count_vax)
as
(
-- Looking at Total Population vs Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
	,SUM(Cast(vax.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.date) as rolling_count_vax
	
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVax vax
	ON dea.location = vax.location
	and dea.date = vax.date
WHERE dea.continent is not null
--ORDER BY 1,2,3
)
Select *, (rolling_count_vax/population)*100
From PopvsVax
Where location Like '%Indonesia%'

--temp table
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
new_vaccinations numeric,
rolling_count_vax numeric
)

INSERT INTO  #PercentPopulationVaccinated
-- Looking at Total Population vs Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
	,SUM(Cast(vax.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.date) as rolling_count_vax
	
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVax vax
	ON dea.location = vax.location
	and dea.date = vax.date
WHERE dea.continent is not null
--ORDER BY 1,2,3

Select *, (rolling_count_vax/population)*100
From #PercentPopulationVaccinated




-----------------------------------------------------------------------

Select MAX(population), SUM(cast(total_vaccinations as int))
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVax vax
	ON dea.location = vax.location
	and dea.date = vax.date
GROUP BY dea.location

Select * 
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVax vax
	ON dea.location = vax.location
	and dea.date = vax.date

--------------------------------------------------------------------------------

-- creating view to store data for later
Create View PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
	,SUM(Cast(vax.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.date) as rolling_count_vax
	
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVax vax
	ON dea.location = vax.location
	and dea.date = vax.date
WHERE dea.continent is not null
--ORDER BY 1,2,3
