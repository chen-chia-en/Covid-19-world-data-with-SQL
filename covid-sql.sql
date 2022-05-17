SELECT top 3 * FROM CovidDeaths where continent is not null
SELECT Top 3 * FROM CovidVaccination

select location, date, total_cases, new_cases, total_deaths, population 
from CovidDeaths
order by 1,2

-- the likelihood of dying if you contract covid in your country
select sum(new_cases) as totalcase
,sum(cast(new_deaths as int)) as totaldeath
,(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
--where location like '%states%'
order by 1,2


-- looking at total cases vs population 
select location, population, 
max(total_cases) as MaxInfectionCount, 
(max(total_cases/population))*100 as PercentPopulationInfected
from  CovidDeaths
group by location, population
having population > 10000000
order by  PercentPopulationInfected DESC

-- showing contries with highest Death countries per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from  CovidDeaths
where continent is not null
group by location 
order by TotalDeathCount desc

-- TotalDeathCount of continents
select continent,sum(cast(new_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount DESC

-- PercentpopulationInfected
select location, population,  max(cast(total_cases as int)) as HighestInfectionCounts,
( max(cast(total_cases as int))/population)*100 as PercentpopulationInfected
from CovidDeaths
where continent is not null
group by location, population
order by 4 DESC

--Global number
select date, sum(total_cases) as totalcase
, sum(cast(total_deaths as int)) as totaldeath
, sum(new_cases) as newcases
, sum(cast(new_deaths as int)) as newdeaths
from CovidDeaths
where continent is null
group by date
order by date



--looking at totalvaccination vs. population
--Use CTE
with TestAndPopulation(location, population, SumNewVaccination, PercentVacAndPopulation)
as(
	select dea.location, dea.population, sum(cast(cav.new_vaccinations as float)),
	(sum(cast(cav.new_vaccinations as float))/dea.population)*100
	from CovidDeaths dea
	inner join CovidVaccination cav
	on dea.location = cav.location and dea.date = cav.date
	where dea.continent is not null
	group by dea.location, dea.population
)
select * from TestAndPopulation
order by PercentVacAndPopulation 

--create view
Create View PercentPopularionVaccinated as 
select dea.location, dea.population, sum(cast(cav.new_vaccinations as float)) as totalvaciinated,
(sum(cast(cav.new_vaccinations as float))/dea.population)*100 as percentvaccinated
from CovidDeaths dea
inner join CovidVaccination cav
on dea.location = cav.location and dea.date = cav.date
where dea.continent is not null
group by dea.location, dea.population

select * from PercentPopularionVaccinated order by percentvaccinated
