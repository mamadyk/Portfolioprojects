-- select data that we are going to use 

select location, date, total_cases, new_cases, total_deaths, population
from Portfolio_projects.coviddeaths
where continent is not null
order by 1,2;

--Looking at the total cases vs total deaths 
-- this shows the likelyhood of dying in your country 

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from Portfolio_projects.coviddeaths
where location= "Nigeria" 
order by 1,2;

-- looking at the total cases vs population

select location, date, population, total_cases, (total_cases/population)*100 as percentage_of_population_infection
from Portfolio_projects.coviddeaths
where location= "Nigeria"
order by 1,2;

-- looking at countries with highest infection rate compared to. population 

select location, population, MAX(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentage_of_infection
from Portfolio_projects.coviddeaths
where continent is not null
group by location, population
order by percentage_of_infection desc;

-- Showing countries with highest death count per population

select location, Max(cast (total_deaths as int )) as highestdeathrecorded ,Max((total_deaths/population))*100 as highest_percentage_of_death_recorded
from Portfolio_projects.coviddeaths
where continent is not null
group by location
order by highest_percentage_of_death_recorded desc ;

-- lets break things down by continent 

select continent, Max(cast (total_deaths as int )) as highestdeathrecorded ,Max((total_deaths/population))*100 as highest_percentage_of_death_recorded
from Portfolio_projects.coviddeaths
where continent is not null
group by continent
order by highest_percentage_of_death_recorded desc;


select location, Max(cast (total_deaths as int )) as highestdeathrecorded ,Max((total_deaths/population))*100 as highest_percentage_of_death_recorded
from Portfolio_projects.coviddeaths
where continent is  null
group by location
order by highest_percentage_of_death_recorded desc;

-- Global numbers 

select date, sum(total_cases) as daily_total_cases,sum(total_deaths) as daily_total_deaths,(sum(total_deaths)/sum(total_cases)) *100 as daily_Deathpercentage
from Portfolio_projects.coviddeaths
-- where location= "Nigeria" 
where continent is not null
group by date 
order by 1,2;

-- looking at total population vs vaccination

SELECT dea.continent,
 dea.location,
 dea.date,
 dea.population,
 vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM Portfolio_projects.coviddeaths dea 
JOIN Portfolio_projects.covidvaccinations vac 
ON dea.location = vac.location 
AND dea.date = vac.date
where dea.continent is not null
ORDER BY 1,2,3;

-- Use CTE
WITH PopvsVac   AS 
(
  SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
  FROM
    Portfolio_projects.coviddeaths dea
  JOIN
    Portfolio_projects.covidvaccinations vac
  ON
    dea.location = vac.location
    AND dea.date = vac.date
  WHERE
    dea.continent IS NOT NULL
)
SELECT
  *, (RollingPeopleVaccinated/population)*100 as percentageVaccinated
FROM
  PopvsVac;



-- creating view to store data for data visualisation later 

create view Portfolio_projects.Percentpopulationvaccinated as 

WITH PopvsVac   AS 
(
  SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
  FROM
    Portfolio_projects.coviddeaths dea
  JOIN
    Portfolio_projects.covidvaccinations vac
  ON
    dea.location = vac.location
    AND dea.date = vac.date
  WHERE
    dea.continent IS NOT NULL
)
SELECT
  *, (RollingPeopleVaccinated/population)*100 as percentageVaccinated
FROM
  PopvsVac;

create view Portfolio_projects.globalnumbers as  
select 
   date,
   sum(total_cases) as daily_total_cases,
   sum(total_deaths) as daily_total_deaths,
   (sum(total_deaths)/sum(total_cases)) *100 as daily_Deathpercentage
from Portfolio_projects.coviddeaths 
where continent is not null
group by date 
order by 1,2;


create view Portfolio_projects.highestrateofdeath as 
select location, Max(cast (total_deaths as int )) as highestdeathrecorded ,Max((total_deaths/population))*100 as highest_percentage_of_death_recorded
from Portfolio_projects.coviddeaths
where continent is not null
group by location
order by highest_percentage_of_death_recorded desc;

create view Portfolio_projects.highestrateofinfection as
select location, population, MAX(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentage_of_infection
from Portfolio_projects.coviddeaths
where continent is not null
group by location, population
order by percentage_of_infection desc;


create view Portfolio_projects.rateofdeath as 
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from Portfolio_projects.coviddeaths
where continent is not null 
order by 1,2;

create view Portfolio_projects.rateofinfection as 
select location, date, population, total_cases, (total_cases/population)*100 as percentage_of_population_infection
from Portfolio_projects.coviddeaths
where continent is not null
order by 1,2;























