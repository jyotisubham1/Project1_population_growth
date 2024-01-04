# Retrieve the columns for all districts in the state of 'Orissa'.

SELECT district FROM data1 WHERE state = 'Orissa' ORDER BY district;

# Find the average literacy rate for all districts in the state of Orissa

SELECT AVG(literacy) AS average_literacy_rate FROM data1 WHERE state = 'Orissa';

# Retrieve the population of the district 'Mayurbhanj' in the state of 'Orissa'.

SELECT population FROM data2
WHERE district = 'Mayurbhanj' AND state = 'Orissa';

# Identify districts with a population higher than the average population of Orissa.

SELECT district, population FROM data2
WHERE state = 'Orissa' AND population > (SELECT AVG(population) FROM data2 WHERE state = 'Orissa');

# Retrieve districts with a literacy rate above 80% and a growth rate above 2.

SELECT `District`,`Growth`,`Literacy` FROM data1 WHERE literacy > 80 AND growth > 0.3;

# Rank the states based on the average growth rate of their districts, showing only the top 5.

SELECT state, AVG(growth) AS avg_growth_rate
FROM data1
GROUP BY state
ORDER BY avg_growth_rate DESC
LIMIT 5;

# Find the states where the total population is greater than 50 million.

SELECT state, SUM(population) AS total_population
FROM data2
GROUP BY state
HAVING total_population > 50000000
ORDER BY total_population DESC;

# Calculate the percentage growth for each district.

SELECT district, (growth * 100) AS percentage_growth
FROM data1;

# Find districts with a population greater than the average population of districts in Maharashtra.

SELECT district, population
FROM data2
WHERE population > (
    SELECT AVG(population)
    FROM data2
    WHERE state = 'Maharashtra'
);

# Retrieve the districts, states, and populations where data is available in both datasets.

SELECT d.district, d.state, d.growth, p.population
FROM data1 AS d
INNER JOIN data2 AS p
ON d.district = p.district AND d.state = p.state;

# Retrieve all districts and states from the first dataset along with their populations (if available) from the second dataset.

SELECT d.district, d.state, d.growth, COALESCE(p.population, 'Data not available') AS population
FROM data1 AS d
LEFT JOIN data2 AS p
ON d.district = p.district AND d.state = p.state;

# Retrieve all districts and states from the second dataset along with their growth rates (if available) from the first dataset.

SELECT COALESCE(d.district, 'Data not available') AS district, COALESCE(d.state, 'Data not available') AS state,
       COALESCE(d.growth, 'Data not available') AS growth, p.population
FROM data1 AS d
RIGHT JOIN data2 AS p
ON d.district = p.district AND d.state = p.state;

# Find pairs of districts within the same state with similar growth rates.

SELECT d1.district AS district1, d2.district AS district2, d1.state, d1.growth
FROM data1 AS d1
JOIN data1 AS d2 ON d1.state = d2.state AND d1.growth = d2.growth AND d1.district <> d2.district;

# Find states where the average growth rate is higher than the average growth rate of neighboring states.

SELECT d1.state, AVG(d1.growth) AS avg_growth_state, AVG(d2.growth) AS avg_growth_neighboring
FROM data1 AS d1
JOIN data1 AS d2 ON d1.state <> d2.state
WHERE ABS(d1.growth - d2.growth) < 5 -- Adjusting the threshold as needed
GROUP BY d1.state
HAVING avg_growth_state > avg_growth_neighboring;

# Identify districts where the population falls within a range of +/- 10% of the average population for the corresponding state.

SELECT d.district, d.state, d.growth, p.population
FROM data1 AS d
JOIN data2 AS p ON d.district = p.district AND d.state = p.state
WHERE p.population BETWEEN 0.9 * (SELECT AVG(population) FROM data2 WHERE state = d.state)
                        AND 1.1 * (SELECT AVG(population) FROM data2 WHERE state = d.state);

