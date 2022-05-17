-- Vaccinations vs % deaths per case for each continent
-- Used to evaluate the effectiveness of vaccinations
SELECT date, location,
	(SUM(people_vaccinated)/SUM(population))*100 AS percentage_total_vacc, 
	(SUM(people_fully_vaccinated)/SUM(population))*100 AS percentage_fully_vacc, 
	(SUM(total_boosters)/SUM(population))*100 AS percentage_boosters,
	CASE
		WHEN SUM(new_cases) != 0 THEN (SUM(new_deaths)/SUM(new_cases))*100
	END AS death_percentage
FROM All_Data
WHERE continent = ''
	AND location NOT LIKE '%income%'
	AND NOT location = 'International'
	AND NOT location = 'European Union'
	AND location != 'World'
GROUP BY date, location, population;


-- Percentage of population that contracted covid and percentage deaths for those that caught it. In europe
-- Going to be used to evaluate the effect of each countires response
SELECT location, population,
	(MAX(total_cases)/population)*100 AS percentage_contracted_covid,
	(MAX(total_deaths)/MAX(total_cases))*100 AS percentage_deaths_percase
FROM All_Data
WHERE continent = 'Europe' AND total_cases>0
GROUP BY location, population;


-- New cases each day vs tests conducted
-- Used to evaluate effect of mass testing on case numbers.
SELECT date, SUM(new_cases) AS cases_today, SUM(new_tests) AS tests_today
FROM All_Data
GROUP by date;