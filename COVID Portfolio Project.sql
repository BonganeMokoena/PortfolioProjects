--exec sp_help 'CovidDeaths'
alter table CovidVaccines
alter column new_vaccinations float

SELECT *
FROM CovidDeaths

----------------------------------------------------------------------------------------
-- Death Percentage in South Africa (Likelihood of dying after contracting COVID-19)
----------------------------------------------------------------------------------------
SELECT iso_code,location, date, total_cases, total_deaths, (total_deaths/total_cases)*100
AS Death_percentage
FROM CovidDeaths
WHERE total_cases != 0 AND location LIKE '%South Africa%'  -- total_cases cannot be zero, since you cannot divide by zero
ORDER BY 3           -- Order by date because order is everything!
-----------------------------------------------------------------------------------------
-- Case Percentage in the world (Likelihood of contracting COVID-19)
----------------------------------------------------------------------------------------
SELECT iso_code,location, population, total_cases, (total_cases/population)*100
AS Case_percentage
FROM CovidDeaths
ORDER BY 2                        -- Order by location because order is everything!
-----------------------------------------------------------------------------------------
-- The country with the highest infection rate
-----------------------------------------------------------------------------------------
SELECT location, population, MAX(total_cases) AS HighestInfectionCount,
MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC
------------------------------------------------------------------------------------------
-- Countries with the highest death count per population
------------------------------------------------------------------------------------------
SELECT location, MAX(total_deaths) AS HighestDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeathCount DESC
------------------------------------------------------------------------------------------
-- Beaking it down by continent
SELECT continent, MAX(total_deaths) AS HighestDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount DESC
------------------------------------------------------------------------------------------
--Continent with the highest death count per population
SELECT continent, MAX(total_deaths) AS HighestDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount DESC
--------------------------------------------------------------------------------------
-- Global deaths 
--------------------------------------------------------------------------------------
SELECT SUM(new_cases) AS Global_cases, SUM(new_deaths) AS Global_deaths, 
(SUM(new_deaths)/SUM(new_cases))*100 AS GlobalDeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2
-------------------------------------------------------------------------------------
-- JOINING tables
-------------------------------------------------------------------------------------
SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations,
SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date)
AS RollingVaccinatedPeople
FROM CovidDeaths cd
JOIN CovidVaccines cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3
--------------------------------------------------------------------------------------
-- FInding out the percentage of people vaccinated compared to location population
WITH VaccinatedPopulants(continent, location, date, population, new_vaccinations, 
RollingVaccinatedPeople)
AS(
SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date)
AS RollingVaccinatedPeople
FROM CovidDeaths cd
JOIN CovidVaccines cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
)
SELECT *, (RollingVaccinatedPeople/Population)*100 AS PopulationVaccinated_percentage
FROM 
VaccinatedPopulants
------------------------------------------------------------------------------------------
-- Creating Views
------------------------------------------------------------------------------------------
CREATE VIEW DeathPercentage_SouthAfrica AS
SELECT iso_code,location, date, total_cases, total_deaths, (total_deaths/total_cases)*100
AS Death_percentage
FROM CovidDeaths
WHERE total_cases != 0 AND location LIKE '%South Africa%'  -- total_cases cannot be zero, since you cannot divide by zero
--ORDER BY 3  
-------------------------------------------------------------------------------------------
CREATE VIEW CasePercentage_Global AS
SELECT iso_code,location, population, total_cases, (total_cases/population)*100
AS Case_percentage
FROM CovidDeaths
--ORDER BY 2 
---------------------------------------------------------------------------------------------
CREATE VIEW HighestInfectionRate AS
SELECT location, population, MAX(total_cases) AS HighestInfectionCount,
MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM CovidDeaths
GROUP BY location, population
--ORDER BY PercentagePopulationInfected DESC
----------------------------------------------------------------------------------------------
CREATE VIEW DeathCount_Population AS
SELECT location, MAX(total_deaths) AS HighestDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
--ORDER BY HighestDeathCount DESC
------------------------------------------------------------------------------------------------
CREATE VIEW GlobalDeath AS
SELECT SUM(new_cases) AS Global_cases, SUM(new_deaths) AS Global_deaths, 
(SUM(new_deaths)/SUM(new_cases))*100 AS GlobalDeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 1, 2
-----------------------------------------------------------------------------------------------------
CREATE VIEW PercentVaccinated_Population AS
WITH VaccinatedPopulants(continent, location, date, population, new_vaccinations, 
RollingVaccinatedPeople)
AS(
SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date)
AS RollingVaccinatedPeople
FROM CovidDeaths cd
JOIN CovidVaccines cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
)
SELECT *, (RollingVaccinatedPeople/Population)*100 AS PopulationVaccinated_percentage
FROM 
VaccinatedPopulants