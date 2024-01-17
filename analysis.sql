-- Query 1: Select all records from CovidDeaths table for locations with continents specified, ordered by columns 3 and 4
Select *
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3, 4

-- Query 2: Select specific columns from CovidDeaths table for locations with continents specified, ordered by columns 1 and 2
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1, 2

-- Query 3: Calculate death percentage for states in the USA
Select Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1, 2

-- Query 4: Calculate the percentage of population infected with Covid
Select Location, date, Population, total_cases, (total_cases / population) * 100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
order by 1, 2

-- Query 5: Find countries with the highest infection rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases / population)) * 100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

-- Query 6: Find countries with the highest death count per population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Query 7: Find continents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Query 8: Calculate global Covid statistics
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(New_Cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 

-- Query 9: Calculate the percentage of population that has received at least one Covid vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--  calculates the cumulative sum of new_vaccinations for each location (dea.Location) ordered by location and date. 
--  rolling sum resets whenever the location changes.
       SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2, 3

-- Query 10: Calculate the percentage of population that has received at least one Covid vaccine using a CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated / Population) * 100
From PopvsVac

-- Query 11: Calculate the percentage of population that has received at least one Covid vaccine using a temporary table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date

-- Query 12: Select data from the temporary table and calculate the percentage of population vaccinated
Select *, (RollingPeopleVaccinated / Population) * 100
From #PercentPopulationVaccinated

-- Query 13: Create a view to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
