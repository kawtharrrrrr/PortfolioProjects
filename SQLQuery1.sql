use [Portfolio Project]

select *
from CovidDeaths1
where continent is not null
order by 3,5

select * 
from CovidVaccinations1
order by 3,4

alter table coviddeaths1
alter column new_deaths float

--select data that we are going to be using

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths1
ORDER BY 1,2
--LOOKING AT TOTAL CASES VS TOTAL DEATHS

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from CovidDeaths1
where location = 'Saudi Arabia'
ORDER BY 1,2


--looking at total cases vs population
select location,date,total_cases,population,(total_cases/population)*100 as deathpercentage
from CovidDeaths1
--where location = 'Saudi Arabia'
ORDER BY 1,2

--looking at countries with highest rate compared to populaiton

select location,max(total_cases) as highest_infectioncount,population,max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths1
group by location,population
ORDER BY PercentPopulationInfected desc

--showing countries with highest death count per population 

select location,max(total_deaths) as TotalDeathesCount
from CovidDeaths1
where continent is not null
group by location,population
ORDER BY TotalDeathesCount desc

--showing continents with highest death count per population 

select location,max(total_deaths) as TotalDeathesCount
from CovidDeaths1
where continent is  null
group by location,population
ORDER BY TotalDeathesCount desc


--Global numbers

select date,sum(new_cases) as Total_cases,sum(new_deaths) as total_deaths,(sum(new_deaths)/sum(new_cases))*100 as deathpercentage
from CovidDeaths1
where continent is not null
group by date
ORDER BY 1,2

 --

 select sum(new_cases) as Total_cases,sum(new_deaths) as total_deaths,(sum(new_deaths)/sum(new_cases))*100 as deathpercentage
from CovidDeaths1
where continent is not null
--group by date
ORDER BY 1,2




--join tabals

select * 
from CovidDeaths1 dea
join CovidVaccinations1 vac
 on dea.location = vac.location
 and dea.date = vac.date

--looking at total population vs vaccinations

 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from CovidDeaths1 dea
join CovidVaccinations1 vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 --

 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as int )) over (partition by dea.location order by dea.location,dea.date) as RollingPoeoleVaccinated
from CovidDeaths1 dea
join CovidVaccinations1 vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 -- use CTE

 with PopvsVac (continent, location,date,population,new_vaccinations,rollingpoplevaccinated)
 as
 (
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as int )) over (partition by dea
 .location order by dea.location,dea.date) as RollingPoeoleVaccinated
from CovidDeaths1 dea
join CovidVaccinations1 vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 )

 select *
 from PopvsVac 

 --TEMP Table
 drop table if exists #PercentPopulationVaccinated
 create table #PercentPopulationVaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 New_vaccinated numeric,
 RollingPeoplevacinated numeric
 )
 
 insert into #PercentPopulationVaccinated
  select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as int )) over (partition by dea
 .location order by dea.location,dea.date) as RollingPoeoleVaccinated
from CovidDeaths1 dea
join CovidVaccinations1 vac
 on dea.location = vac.location
 and dea.date = vac.date
 --where dea.continent is not null
 
 select *
 from #PercentPopulationVaccinated

 --creating view to store data for later visualizations

create view PercentPopulationVaccinated as
  select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as int )) over (partition by dea
 .location order by dea.location,dea.date) as RollingPoeoleVaccinated
from CovidDeaths1 dea
join CovidVaccinations1 vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null

 select *
 from PercentPopulationVaccinated