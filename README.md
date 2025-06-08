# Task 4: SQL for Data Analysis

## Overview
- **Objective**: Use SQL queries to extract and analyze data.
- **Tools**: MySQL.
- **Deliverables**: SQL queries file + screenshots of output.

The queries cover:
- Top product categories by sales.
- Average review score by seller state.
- Top customers by number of orders.
- Monthly revenue trends.
- Creation of a view for high-value customers.
- Query optimization using indexes.

## Files
- `Task4_Database_Setup.sql`: SQL script to create the database and import the Olist datasets.
- `Task4_SQL_Queries.sql`: The SQL queries file containing all queries used for analysis.
- `Screenshots/`: Screenshots of the query outputs:
  - `Q1_Output.png`: Top product categories by sales.
  - `Q2_Output.png`: Average review score by seller state.
  - `Q3_Output.png`: Top customers by number of orders.
  - `Q4_Output.png`: Monthly revenue trends.
  - `Q5_Output.png`: High-value customers view.
  - `Q6_Output.png`: Optimized monthly revenue query.

**Note**: The dataset files are not included in this repository. You can download the Brazilian Olist Store dataset from Kaggle: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

## Key Insights
- **Top Categories**: The category "health_beauty" had the highest sales at $1,233,131.72.
- **Seller Performance**: Sellers in Pará (PA) have the highest average review score of 4.5.
- **Top Customers**: The top customer placed 15 orders and is from São Paulo, with the top 5 customers placing 7-15 orders, mostly from cities in São Paulo state (São Paulo, Praia Grande, Santos), plus Ituiutaba (Minas Gerais) and Recife (Pernambuco).
- **Revenue Trends**: Revenue peaked in November 2017 at $1,153,528.05, likely due to Black Friday sales.

## How to Run
1. Install MySQL and MySQL Workbench.
2. Download the Brazilian Olist Store dataset from Kaggle: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
3. Run the `Task4_Database_Setup.sql` script to create the database and import the data.
4. Open and execute the queries in `Task4_SQL_Queries.sql` to reproduce the analysis.
5. View the outputs in the `Screenshots/` folder.

## Tools Used
- MySQL for querying and analysis.
- Dataset: Brazilian Olist Store dataset (Kaggle).

## Date and Time of Submission
- Submitted on: 11:40 AM IST, Sunday, June 08, 2025.
