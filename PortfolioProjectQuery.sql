select total_cases, new_cases
from CovidDeaths
where continent is not null
order by total_cases

-- Looking at total cases VS total deaths

-- Sows the likelihood of mortality if one contracts COVID19

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathPercent 
from CovidDeaths
where location = 'India'
order by 1, 2

-- Percent population that contracted COVID in INDIA.

select top 1 location, population, date, total_cases, total_cases/population*100 as covidPercent
from CovidDeaths
where location = 'India'
order by covidPercent desc


-- Looking at countries with highest infection rate with respect to population.
select location, population, max(total_cases) as total_cases, max(total_cases/population)*100 as infection_rate
from CovidDeaths
group by location, population
order by infection_rate desc


-- Showing the countries with highest death count 
 select location, max(cast(total_deaths as int)) as total_deaths
from CovidDeaths
where continent is not null
group by location
order by total_deaths desc


-- Let's break down things by continent
select continent,  MAX(CAST(total_deaths as int)) as total_deaths
from CovidDeaths
where continent is not null
group by continent
order by total_deaths desc

-- Global Numbers
select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as deaths, Sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null

-- Looking at total Population vs Vaccination

select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidVaccination.new_vaccinations,
sum(cast(CovidVaccination.new_vaccinations as int)) Over (partition by CovidDeaths.location Order by CovidDeaths.location, 
CovidDeaths.date) as VaccinatedPeople
from CovidDeaths join CovidVaccination
on CovidDeaths.location = CovidVaccination.location 
where CovidDeaths.continent is not null
order by 2

