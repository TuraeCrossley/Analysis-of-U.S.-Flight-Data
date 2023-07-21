# Analysis-of-U.S.-Flight-Data

Introduction:
This project involved an in-depth analysis of flight data in the United States. The primary goal was to gain insights into various aspects of flight operations, including delays, cancellations, and the reliability of different airlines. The dataset used in this project consisted of flight data from the year 2015, with detailed information about each flight such as airline, flight number, origin and destination airports, scheduled and actual departure and arrival times, delays, and cancellations.

Data:
The data used in this project came from four CSV files, representing different SQL tables:

airlines.csv: Information about different airlines, including their IATA codes and names.
airports.csv: Information about different airports, including their IATA codes, names, and geographical locations.
cancellation_codes.csv: Codes representing different reasons for flight cancellations.
flights.csv: Detailed data about over 5 million flights, including information about departure and arrival times, delays, cancellations, and the airlines and airports involved.
Methodology:
The project was primarily conducted using SQL, a language designed for managing and manipulating relational databases. SQL was particularly suitable for this project due to its powerful querying capabilities, which allowed for complex analyses to be performed efficiently.

Several key SQL concepts and functions were used throughout the project:

Joins: Used to combine rows from two or more tables, based on a related column. This was essential for linking data across the different tables.
Aggregate functions: Functions such as COUNT(), SUM(), and AVG() were used to calculate summary statistics for different groups of flights.
Group By: This clause was used in conjunction with aggregate functions to group flights by various attributes such as airline, month, or day of the week.
Window functions: These functions perform calculations across a set of rows related to the current row. They were used to rank flights within each airline based on delay times.
Subqueries: These are queries nested inside other queries. Subqueries were used to calculate averages for comparison with individual group statistics.
Common Table Expressions (CTEs): These are temporary result sets that can be referenced within another SQL statement. CTEs were used to simplify complex queries by breaking them down into more manageable parts.
Case statements: These were used to add conditional logic to the queries, allowing for more flexible calculations.
Indexes: These were used to speed up queries by creating a data structure that improves the speed of data retrieval operations on a database table.
Results:
The analysis provided valuable insights into U.S. flight operations. For example, it revealed how the volume of flights varies by month and day of the week, and how the percentage of delayed flights changes throughout the year. It also identified the airlines with the highest and lowest percentages of on-time departures, providing an indication of their reliability.

The project demonstrated the power and flexibility of SQL for data analysis, as well as the value of having a structured approach to querying and analyzing data.
