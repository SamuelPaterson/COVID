SELECT * INTO temp_continents
FROM COVID..All_Data
WHERE continent = ''
	AND location NOT LIKE '%income%'
	AND NOT location = 'International'
	AND NOT location = 'European Union'
	AND location != 'World';


-- Location Comparison Data
SELECT location, date, total_cases, total_deaths, population, people_vaccinated, people_fully_vaccinated, total_boosters
	FROM COVID..All_Data
	ORDER BY location, date

-- For comparing Covid reponses
WITH cte AS (
	SELECT location,
		(MAX(total_cases)/MAX(population))*100 AS percentage_contracted_covid,
		(MAX(total_deaths)/MAX(population))*100 AS percentage_population_death
	FROM temp_continents
	GROUP BY location
	)
SELECT location, percentage_contracted_covid,
	(percentage_population_death/percentage_contracted_covid)*100 AS percentage_death_rate
	FROM cte;


-- Vaccinations vs % deaths per case for each continent
-- Used to evaluate the effectiveness of vaccinations
SELECT date, location,
	(SUM(people_vaccinated)/SUM(population))*100 AS percentage_total_vacc, 
	(SUM(people_fully_vaccinated)/SUM(population))*100 AS percentage_fully_vacc, 
	(SUM(total_boosters)/SUM(population))*100 AS percentage_boosters,
	CASE
		WHEN SUM(new_cases) != 0 THEN (SUM(new_deaths)/SUM(new_cases))*100
	END AS death_percentage
FROM temp_continents
GROUP BY date, location, population
ORDER BY location, date;


-- Percentage of population that contracted covid and percentage deaths for those that caught it. In europe
-- Going to be used to evaluate the effect of each countires response
SELECT location, population,
	(MAX(total_cases)/population)*100 AS percentage_contracted_covid,
	(MAX(total_deaths)/MAX(total_cases))*100 AS percentage_deaths_percase
FROM COVID..All_Data
WHERE continent = 'Europe' AND total_cases>0
GROUP BY location, population
ORDER BY population;


-- New cases each day vs tests conducted
-- Used to evaluate effect of mass testing on case numbers.
SELECT date, SUM(new_cases) AS cases_today, SUM(new_tests) AS tests_today
FROM COVID..All_Data
GROUP by date
ORDER BY date;