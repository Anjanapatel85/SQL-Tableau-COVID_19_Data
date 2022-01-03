
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
--1.
Select dea.continent,dea.location,dea.date,dea.population,
Max(vac.total_vaccinations) as RollingPeopleVaccinated
from CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3


--2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null
order by 1,2

--Just a double check based off the data provided
--numbers are extremly close so we will keep them - the Second includes "International" Location
--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
--From CovidDeaths
--where location = 'World'
----group by Date
--order by 1,2

--3.
--We take these out as they are not included in the above queries and want to stay consistent
--European Union is a part of Europe
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
where continent is null
and location not in ('World','European Union','International','Lower Middle Income','High Income','Upper middle income','Low income')
group by location
order by TotalDeathCount desc

--4.
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX ((Total_cases/population))*100 as PercentPoulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPoulationInfected desc

--5.
--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From CovidDeaths
----Where location like 'India'
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From CovidDeaths
where continent is not null 
order by 1,2


--6.

With PopvsVac(Continent, Location, Date, Population, New_vaccination, RollingPeopleVaccinated)
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated from PopvsVac


--7.
Select Location, Population, date, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
Group by Location, population, date
order by PercentPopulationInfected desc