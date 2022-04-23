SELECT * 
FROM  coviddeaths
WHERE  continent IS NOT NULL  
order by 3,4;

SELECT * 
FROM  coviddeaths
WHERE  iso_code = 'OWID_AFR';

SELECT * 
FROM covidvaccinations c 
order by 3,4;

-- SELECT  Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population  
FROM  coviddeaths
WHERE  continent IS NOT NULL 
order by 1,2;

--- Looking at Total Cases vs Total Deaths
--- Shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as  DeathPercentage
FROM  coviddeaths
WHERE  location like '%india%'
AND  continent IS NOT NULL 
order by 1,2;


--- Looking at Total Cases vs Population 
--- Shows  what percentage of population got covid 

SELECT location, date, Population, total_cases,  (total_cases /population)*100 as  PercentPopulationInfected
FROM  coviddeaths
where location like '%india%'
order by 1,2;

--- Looking at Countries with Highest Infection Rate compared to Population

SELECT location, Population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population)*100) as  PercentPopulationInfected
FROM  coviddeaths
--where location like '%india%'
Group by location , population 
order by PercentPopulationInfected DESC;


--- Showing Countries with Highest Death Count per Population

SELECT location, MAX(total_deaths) as TotalDeathCount 
FROM  coviddeaths
--where location like '%india%'
WHERE  continent IS NOT NULL 
Group by location
order by TotalDeathCount  DESC;


-- LET'S BREAK THINGS DOWN BY CONTINENT

-- showing continents with the highest death count per population 

SELECT continent , MAX(total_deaths) as TotalDeathCount 
FROM  coviddeaths
--where location like '%india%'
WHERE  continent IS NOT NULL 
Group by continent
order by TotalDeathCount  DESC;


--- GLOBAL NUMBERS

SELECT  sum(new_cases) as total_cases, SUM(new_deaths) as total_deaths ,SUM(new_deaths)/SUM(new_cases)*100  as  DeathPercentage
FROM  coviddeaths
--WHERE  location like '%india%'
WHERE  continent IS NOT NULL
--GROUP BY date
order by 1,2;


--- Lookin at Total Population vs Vaccinations

SELECT c.continent , c.location , c.date , c2.new_vaccinations ,
SUM(c2.new_vaccinations) OVER (PARTITION by c.location ORDER BY c.location, c2.date) as RollingPeopleVaccinated
FROM coviddeaths c 
Join covidvaccinations c2 
    on c.location = c2.location 
    and c.date = c2.date
   WHERE  c.continent IS NOT NULL
  ORDER BY 2,3;

-- With CTE
With populvsvaccination (continent,location,date, new_vaccinations,RollingPeopleVaccinated) 
as(
 SELECT c.continent , c.location , c.date , c2.new_vaccinations ,
SUM(c2.new_vaccinations) OVER (PARTITION by c.location ORDER BY c.location, c2.date) as RollingPeopleVaccinated
FROM coviddeaths c 
Join covidvaccinations c2 
    on c.location = c2.location 
    and c.date = c2.date
   WHERE  c.continent IS NOT NULL
  --ORDER BY 2,3;
 )
 
 SELECT * , (RollingPeopleVaccinated/population)*100
 FROM populvsvaccination;



--- TEMP Table
DROP Table if exists #PercentPopulationVaccinated
Create  Table #PercentPopulationVaccinated
(
continent VARCHAR(16),
location  VARCHAR(16),
date       VARCHAR(1),
Population INTEGER,
new_vaccinations VARCHAR(4),
RollingPeopleVaccinated  VARCHAR(4)
) 


Insert into #PercentPopulationVaccinated
 SELECT c.continent , c.location , c.date , c2.new_vaccinations ,
SUM(c2.new_vaccinations) OVER (PARTITION by c.location ORDER BY c.location, c2.date) as RollingPeopleVaccinated
FROM coviddeaths c 
Join covidvaccinations c2 
    on c.location = c2.location 
    and c.date = c2.date
   WHERE  c.continent IS NOT NULL
  --ORDER BY 2,3;
 

 
 SELECT * , (RollingPeopleVaccinated/population)*100
 FROM #PercentPopulationVaccinated;



--- View for PercentPopulationVaccinated 

Create View PercentPopulationVaccinated  as
SELECT c.continent , c.location , c.date , c2.new_vaccinations ,
SUM(c2.new_vaccinations) OVER (PARTITION by c.location ORDER BY c.location, c2.date) as RollingPeopleVaccinated,
FROM coviddeaths c 
Join covidvaccinations c2 
    on c.location = c2.location 
    and c.date = c2.date
   WHERE  c.continent IS NOT NULL
  ORDER BY 2,3;
 
 SELECT *
 FROM PercentPopulationVaccinated




 












