-- viewing dataset

select *
from master..CovidDeaths
order by 3, 4

-- selecting specific columns from dataset
  
select location, date, total_cases, new_cases, total_deaths, population
from master..CovidDeaths
order by 1, 2

-- total cases vs total deaths in the united states

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from master..CovidDeaths
where location like '%states%'
order by 1, 2

-- total cases vs population in the united states

select location, date, total_cases, population, (total_cases/population)*100 as percent_population_infected
from master..CovidDeaths
where location like '%states%'
order by 1, 2

-- countries with highest infection rate compared to population

select location, population, max(total_cases) as highest_infection_count, max((total_cases/population))*100 as percent_population_infected 
from master..CovidDeaths
group by location, population
order by percent_population_infected desc

-- countries with highest deaths

select location, max(cast(total_deaths as int)) as total_death_count --converted into integer due to data type issue
from master..CovidDeaths
where continent is not null --noticed a ton of null values in the continent column
group by location
order by total_death_count desc

-- total death count per location

select location, max(cast(total_deaths as int)) as total_death_count 
from master..CovidDeaths
group by location
order by total_death_count desc

-- total cases vs total deaths in the world

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage --same data type issue (so I converted to int)
from master..CovidDeaths
where continent is not null

-- joining 2 tables (CovidDeaths and CovidVaccinations)

select *
from master..CovidDeaths
join master..CovidVaccinations
on CovidDeaths.location = CovidVaccinations.location
and CovidDeaths.date = CovidVaccinations.date

-- total population vs vaccinations

select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations,
sum(cast(CovidVaccinations.new_vaccinations as int)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date) as rolling_people_vaccinated
from master..CovidDeaths
join master..CovidVaccinations
on CovidDeaths.location = CovidVaccinations.location
and CovidDeaths.date = CovidVaccinations.date
where (CovidDeaths.continent is not null)
order by 2, 3 
