-- selecao de dados a usar

select location, dates, total_cases, new_cases, total_deaths, population
from covid
order by 1,2

-- casos totais vs letalidade

select location, dates, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as Lethality
from covid
where location = 'Brazil'
order by 1,2

-- % de populacao infectada

select location, dates,population, total_cases, max(round((total_cases/population)*100,2)) as infected
from covid
order by 1,2

-- paises com maior taxa de infeccao por populacao

select location,population,max(total_cases) as Highest_infection_count, max(round((total_cases/population)*100,2)) as infected
from covid
group by location,population
order by infected desc

-- paises com maior mortalidade por populacao

select location, max(total_deaths) as death_count
from covid
where continent is not null
group by location
having max(total_deaths) is not null
order by death_count desc

-- por continente 1

select location, max(total_deaths) as death_count
from covid
where continent is null
group by location
order by death_count desc

-- por continente 2

select continent, max(total_deaths) as death_count
from covid
where continent is not null
group by continent
order by death_count desc

-- numeros globais

select dates, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(total_deaths)/sum(total_cases)*100 as Lethality
from covid
where continent is not null
group by dates
order by 1,2

-- populacao total vs populacao vacinada, como common table expression(cte)

with pop_vac (continent,location,dates,population,new_vaccinations,rolling_vaccination) AS
(select cov.continent,cov.location, cov.dates, cov.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (Partition by cov.location order by cov.location, cov.dates) as rolling_vaccination
from covid as cov
join vaccination as vac
on cov.location = vac.location
and cov.dates = vac.dates
where cov.continent is not null
order by 2,3
)
select *, (rolling_vaccination/population)*100 as rolling_percentage
from pop_vac

-- populacao total vs populacao vacinada, como temp table

drop table if exists percent_population_vaccinated
create temp table percent_population_vaccinated
(
continent varchar(50),
location varchar(50),
dates date,
population numeric,
new_vaccinations numeric,
rolling_vaccination numeric,
rolling_percentage numeric
)

insert into percent_population_vaccinated
select cov.continent,cov.location, cov.dates, cov.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (Partition by cov.location order by cov.location, cov.dates) as rolling_vaccination
from covid as cov
join vaccination as vac
on cov.location = vac.location
and cov.dates = vac.dates
where cov.continent is not null
order by 2,3

select *
from percent_population_vaccinated

-- view

create view population_vaccinated as
select cov.continent,cov.location, cov.dates, cov.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (Partition by cov.location order by cov.location, cov.dates) as rolling_vaccination
from covid as cov
join vaccination as vac
on cov.location = vac.location
and cov.dates = vac.dates
where cov.continent is not null
order by 2,3

select *
from population_vaccinated 