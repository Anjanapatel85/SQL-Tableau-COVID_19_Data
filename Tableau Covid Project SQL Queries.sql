/*

Queries used for Tableau Project


*/

--1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage from CovidDeaths
where continent is not null
order by 1,2

--2

Select location, SUM(cast(new_deaths as int)) as total_deaths from CovidDeaths
where continent is not null
and location not in ('World','European Union', 'INternational')
Group by Location
order by total_deaths desc

--3.

Select location, population, MAX(total_cases) as HighestInfectionCount,
max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
where continent is not null
and location not in ('World','European Union', 'INternational')
Group by Location, Population
order by PercentPopulationInfected desc

--4.
Select location, population,date, MAX(total_cases) as HighestInfectionCount,
max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
--where continent is not null and location not in ('World','European Union', 'INternational')
Group by Location, Population,Date
order by PercentPopulationInfected desc


--Here only in case you want to check them out
Select dea.continent,dea.location,dea.date,dea.population,
Max(vac.total_vaccinations) as RollingPeopleVaccinated
from CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3





