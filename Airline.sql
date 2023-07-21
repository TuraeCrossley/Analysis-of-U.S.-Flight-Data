--bulk inserts
BULK INSERT Airlines
FROM 'airlines.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
BULK INSERT Airports
FROM 'airports.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
BULK INSERT CancellationCodes
FROM 'cancellation_codes.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
BULK INSERT Flights
FROM 'flights.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
--Creates an index on the AIRLINE column of the Flights table to speed up queries filtering or sorting by this column
CREATE INDEX idx_Flights_AIRLINE
ON Flights (AIRLINE);

--Top 3 flights with the longest delays for each airline
WITH ranked_flights AS (
    SELECT 
        f.AIRLINE, 
        f.FLIGHT_NUMBER, 
        f.DEPARTURE_DELAY, 
        RANK() OVER(PARTITION BY f.AIRLINE ORDER BY f.DEPARTURE_DELAY DESC) AS delay_rank
    FROM 
        Flights f
)
SELECT 
    rf.AIRLINE, 
    a.AIRLINE AS AIRLINE_NAME, 
    rf.FLIGHT_NUMBER, 
    rf.DEPARTURE_DELAY, 
    rf.delay_rank
FROM 
    ranked_flights rf
INNER JOIN 
    Airlines a ON rf.AIRLINE = a.IATA_CODE
WHERE 
    rf.delay_rank <= 3;

--Overall flight volume by month:
SELECT 
    MONTH, 
    COUNT(*) AS flight_volume,
    CASE 
        WHEN MONTH = 1 THEN 'January'
        WHEN MONTH = 2 THEN 'February'
        WHEN MONTH = 3 THEN 'March'
        WHEN MONTH = 4 THEN 'April'
        WHEN MONTH = 5 THEN 'May'
        WHEN MONTH = 6 THEN 'June'
        WHEN MONTH = 7 THEN 'July'
        WHEN MONTH = 8 THEN 'August'
        WHEN MONTH = 9 THEN 'September'
        WHEN MONTH = 10 THEN 'October'
        WHEN MONTH = 11 THEN 'November'
        WHEN MONTH = 12 THEN 'December'
        ELSE 'Unknown'
    END AS month_name
FROM 
    Flights
GROUP BY 
    MONTH
ORDER BY 
    MONTH;

--Overall flight volume by day of the week
SELECT 
    DAY_OF_WEEK, 
    COUNT(*) AS flight_volume,
    CASE 
        WHEN DAY_OF_WEEK = 1 THEN 'Monday'
        WHEN DAY_OF_WEEK = 2 THEN 'Tuesday'
        WHEN DAY_OF_WEEK = 3 THEN 'Wednesday'
        WHEN DAY_OF_WEEK = 4 THEN 'Thursday'
        WHEN DAY_OF_WEEK = 5 THEN 'Friday'
        WHEN DAY_OF_WEEK = 6 THEN 'Saturday'
        WHEN DAY_OF_WEEK = 7 THEN 'Sunday'
        ELSE 'Unknown'
    END AS day_name
FROM 
    Flights
GROUP BY 
    DAY_OF_WEEK
ORDER BY 
    DAY_OF_WEEK;

--Percentage of flights that experienced a departure delay in 2015:
SELECT 
    Round((CAST(SUM(CASE WHEN DEPARTURE_DELAY > 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100,2) AS delay_percentage
FROM 
    Flights
WHERE 
    YEAR = 2015;

--Average delay time for flights that experienced a departure delay in 2015:
SELECT 
    AVG(DEPARTURE_DELAY) AS average_delay
FROM 
    Flights
WHERE 
    YEAR = 2015 
    AND DEPARTURE_DELAY > 0;


--Percentage of delayed flights throughout the year:
SELECT 
    MONTH, 
    round((CAST(SUM(CASE WHEN DEPARTURE_DELAY > 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100,2) AS delay_percentage
FROM 
    Flights
GROUP BY 
    MONTH
ORDER BY 
    MONTH;

--Percentage of delayed flights throughout the year for flights leaving from Boston (BOS):
SELECT 
    MONTH, 
    round((CAST(SUM(CASE WHEN DEPARTURE_DELAY > 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100,2) AS delay_percentage
FROM 
    Flights
WHERE ORIGIN_AIRPORT = 'BOS'
GROUP BY 
    MONTH
ORDER BY 
    MONTH;

--Top 3 flights with the longest delays for each airline
WITH ranked_flights AS (
    SELECT 
        f.AIRLINE, 
        f.FLIGHT_NUMBER, 
        f.DEPARTURE_DELAY, 
        RANK() OVER(PARTITION BY f.AIRLINE ORDER BY f.DEPARTURE_DELAY DESC) AS delay_rank
    FROM 
        Flights f
)
SELECT 
    rf.AIRLINE, 
    a.AIRLINE AS AIRLINE_NAME, 
    rf.FLIGHT_NUMBER, 
    rf.DEPARTURE_DELAY, 
    rf.delay_rank
FROM 
    ranked_flights rf
INNER JOIN 
    Airlines a ON rf.AIRLINE = a.IATA_CODE
WHERE 
    rf.delay_rank <= 3;

--How many flights were cancelled in 2015? What % of cancellations were due to weather? What % were due to the Airline/Carrier?
SELECT 
    COUNT(*) AS num_cancelled_flights
FROM 
    Flights
WHERE 
    YEAR = 2015 
    AND CANCELLED = 1;


SELECT 
    round((CAST(SUM(CASE WHEN CANCELLATION_REASON = 'B' THEN 1 ELSE 0 END) AS FLOAT) / SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END)) * 100,2) AS weather_cancellation_percentage
FROM 
    Flights
WHERE 
    YEAR = 2015 
    AND CANCELLED = 1;

SELECT 
    round((CAST(SUM(CASE WHEN CANCELLATION_REASON = 'A' THEN 1 ELSE 0 END) AS FLOAT) / SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END)) * 100,2) AS carrier_cancellation_percentage
FROM 
    Flights
WHERE 
    YEAR = 2015 
    AND CANCELLED = 1;

--Which airlines seem to be most and least reliable, in terms of on-time departure?
SELECT 
    a.AIRLINE, 
    round((CAST(SUM(CASE WHEN f.DEPARTURE_DELAY <= 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100,2) AS on_time_percentage
FROM 
    Flights f
JOIN 
    Airlines a ON f.AIRLINE = a.IATA_CODE
WHERE 
    YEAR = 2015
GROUP BY 
    a.AIRLINE
ORDER BY 
    on_time_percentage DESC;
