# COVID-19 EDA SQL Script

Designed for data analysis and exploration of COVID-19 data sourced from [Our World in Data](https://ourworldindata.org/covid-deaths). 
Employing SQL operations including server functions, common table expressions (CTEs), temporary tables, and subqueries to derive meaningful insights from the available dataset.

## Queries Overview

A brief overview of each query:

1. Query 1: Selects records with specified continents from the `CovidDeaths` table.
2. Query 2: Selects specific columns from the `CovidDeaths` table with continents.
3. Query 3: Calculates the death percentage for states in the USA.
4. Query 4: Calculates the percentage of population infected with COVID-19.
5. Query 5: Finds countries with the highest infection rate compared to population.
6. Query 6: Finds countries with the highest death count per population.
7. Query 7: Finds continents with the highest death count per population.
8. Query 8: Calculates global COVID-19 statistics.
9. Query 9: Calculates the percentage of the population that has received at least one COVID-19 vaccine.
10. Query 10: Uses a CTE to perform the same calculation as Query 9.
11. Query 11: Uses a temporary table to perform the same calculation as Query 9.
12. Query 12: Selects data from the temporary table in Query 11 and calculates the percentage of the population vaccinated.
13. Query 13: Creates a view to store data for later visualizations.

## Data Source

Data sourced from [Our World in Data](https://ourworldindata.org/covid-deaths).
