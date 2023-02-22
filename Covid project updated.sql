--Overview
SELECT *
FROM coviddeaths
WHERE continent IS NOT NULL

SELECT *
FROM covidvacc
WHERE continent IS NOT NULL

--1.Total cases vs Total deaths

--1.a.Death rate worldwide for top 10 total cases
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percent
FROM coviddeaths
WHERE continent IS NOT NULL
AND date = '2023-02-16'
ORDER BY total_cases DESC
LIMIT 10

--1.b.Death rate progress of COVID in Lebanon
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percent
FROM coviddeaths
WHERE location like 'Lebanon'
ORDER BY location, date

--2.Total cases vs Population

--2.a.Infection rate for population for top 10 total cases worldwide
SELECT location, date, total_cases, population, (total_cases/population)*100 AS infection_rate
FROM coviddeaths
WHERE continent IS NOT NULL
AND date = '2023-02-16'
ORDER BY total_cases DESC
LIMIT 10

--2.b.Infection rate progress in Lebanon
SELECT location, date, total_cases, population, (total_cases/population)*100 AS infection_rate
FROM coviddeaths
WHERE location like 'Lebanon'
ORDER BY location, date

--3.Highest infection rate for population
SELECT location, MAX(total_cases) AS max_cases, population, MAX((total_cases/population))*100 AS max_infection_rate
FROM coviddeaths
WHERE continent IS NOT NULL
AND total_cases IS NOT NULL
GROUP BY location, population
ORDER BY max_infection_rate DESC
LIMIT 5

--4.Highest deaths totals by country
SELECT location, MAX(total_deaths) AS max_deaths
FROM coviddeaths
WHERE continent IS NOT NULL
AND total_deaths IS NOT NULL
GROUP BY location, population
ORDER BY max_deaths DESC
LIMIT 10

--5.Highest total cases by country
SELECT location, MAX(total_cases) AS max_cases
FROM coviddeaths
WHERE continent IS NOT NULL
AND total_deaths IS NOT NULL
GROUP BY location, population
ORDER BY max_cases DESC
LIMIT 10

--6.Highest deaths totals by continent
SELECT continent, MAX(total_deaths) AS max_deaths
FROM coviddeaths
WHERE continent IS NOT NULL
AND total_deaths IS NOT NULL
GROUP BY continent
ORDER BY max_deaths DESC

--7.Highest cases totals by continent
SELECT continent, MAX(total_cases) AS max_cases
FROM coviddeaths
WHERE continent IS NOT NULL
AND total_cases IS NOT NULL
GROUP BY continent
ORDER BY max_cases DESC

--8.Global numbers
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date

--9.Total population vs total vaccination

--9.a. For the top 10 countries in total cases
SELECT coviddeaths.location, coviddeaths.population,MAX(coviddeaths.total_cases) AS total_cases, MAX(covidvacc.people_fully_vaccinated) AS total_fully_vacc, (MAX(covidvacc.people_fully_vaccinated)/coviddeaths.population)*100 AS percent_fully_vacc
FROM coviddeaths
JOIN covidvacc
 ON coviddeaths.location = covidvacc.location
 AND coviddeaths.date = covidvacc.date
WHERE coviddeaths.continent IS NOT NULL AND covidvacc.people_fully_vaccinated IS NOT NULL AND total_cases IS NOT NULL
GROUP BY coviddeaths.location, coviddeaths.population
ORDER BY total_cases DESC
LIMIT 10

--9.b.For Lebanon
SELECT coviddeaths.location, coviddeaths.population,MAX(coviddeaths.total_cases) AS total_cases, MAX(covidvacc.people_fully_vaccinated) AS total_fully_vacc, (MAX(covidvacc.people_fully_vaccinated)/coviddeaths.population)*100 AS percent_fully_vacc
FROM coviddeaths
JOIN covidvacc
 ON coviddeaths.location = covidvacc.location
 AND coviddeaths.date = covidvacc.date
WHERE coviddeaths.location = 'Lebanon'
GROUP BY coviddeaths.location,coviddeaths.population

--10.Full vaccination progress in Lebanon
SELECT coviddeaths.location, coviddeaths.date, coviddeaths.population,covidvacc.people_fully_vaccinated AS total_fully_vacc, (covidvacc.people_fully_vaccinated/coviddeaths.population)*100 AS percent_fully_vacc
FROM coviddeaths
JOIN covidvacc
 ON coviddeaths.location = covidvacc.location
 AND coviddeaths.date = covidvacc.date
WHERE coviddeaths.location = 'Lebanon' AND covidvacc.people_fully_vaccinated IS NOT NULL
GROUP BY coviddeaths.date, coviddeaths.location,coviddeaths.population,covidvacc.people_fully_vaccinated


 
