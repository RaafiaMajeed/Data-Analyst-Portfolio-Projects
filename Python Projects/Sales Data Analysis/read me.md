# Sales Data Analysis Project
## Overview
This project involves the analysis of sales data for a company using the Python programming language and the Pandas library. The sales data is spread across 12 months, with each month's data stored in separate CSV files. The goal is to merge the data, clean it, and perform various analyses to gain insights into the company's sales performance.

## Project Structure
The project is organized as follows:

## Data Import and Merging: 
The sales data from 12 months is stored in separate CSV files. The data is imported, combined, and saved into a single CSV file named combined_sales_data.csv.

## Data Cleaning: 
The combined data is cleaned to handle missing values. Null values are identified and removed from the dataset.

## Data Transformation: 
The data types of certain columns (e.g., Quantity Ordered, Price Each) are converted to the appropriate numeric types. Additional columns, such as 'Month', 'Sales', 'City', 'Hour', and 'Minute', are added to facilitate analysis.

## Data Analysis and Visualization:

- Question 1: Best Month for Sales: The total sales for each month are calculated and visualized using a bar chart.
- Question 2: City with the Highest Sales: The total sales for each city are calculated and visualized using a bar chart.
- Question 3: Optimal Advertisement Time: The order times are analyzed to determine the peak time for orders, helping in deciding when to display advertisements.
- Question 4: Popular Product Combinations: Products that are frequently bought together are identified by analyzing duplicated order IDs.
