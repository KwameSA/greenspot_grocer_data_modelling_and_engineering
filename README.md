# Greenspot Grocer Data Project

## Project Overview

This project focuses on cleaning, normalizing, and analyzing transactional data from Greenspot Grocer, a fictional grocery retailer. The original dataset was unstructured and contained inconsistencies, missing values, and redundant information. The goal was to transform this raw data into a well-designed relational database schema that supports accurate reporting and business analysis.

---

## Repository Structure

- `normalized tables csvs/`  
  Contains CSV files representing normalized tables generated from the cleaned dataset. These are ready to be loaded into a relational database.

- `business_related_queries.sql`  
  SQL queries demonstrating key business insights such as sales summaries, inventory levels, vendor supplies, and profitability.

- `Greenspot Grocer EERD and Relational Schema.pdf`  
  Visual documentation of the database design, including the Entity-Relationship Diagram (ERD) and the final relational schema.

- `greenspot_grocer_schema.sql`  
  SQL script defining the database schema (tables, primary keys, foreign keys, constraints) for Greenspot Grocer.

- `load_table_script.sql`  
  SQL script to load the normalized CSV data into the corresponding database tables.

- `greenspot_data.ipynb`  
  Jupyter Notebook containing the full data cleaning and transformation process, including exploration, missing value handling, normalization, and preparation for database loading.

- `Greenspot_Grocer_Uncleaned.csv`  
  The original raw dataset provided by Greenspot Grocer before cleaning and processing.

---

## How to Use

1. **Explore and Understand Data**  
   Review the Jupyter Notebook `greenspot_data.ipynb` for step-by-step data cleaning, transformation logic, and exploratory data analysis.

2. **Create Database Schema**  
   Use `greenspot_grocer_schema.sql` to create the relational database structure in MySQL or a compatible RDBMS.

3. **Load Normalized Data**  
   Execute `load_table_script.sql` to import normalized CSV files from the `normalized tables csvs/` folder into the database.

4. **Run Business Queries**  
   Use `business_related_queries.sql` to execute SQL queries that provide insights into sales, inventory, vendor supplies, and profitability.

---

## Key Features and Highlights

- Data cleaning includes handling missing values, standardizing formats, and inferring missing costs/prices.
- The vendor attribute was parsed and normalized into multiple fields (name, street, city, state, ZIP).
- Dates and numeric columns were properly typed for database compatibility.
- Transaction data was normalized into distinct tables for products, customers, vendors, inventory, purchases, and sales.
- Foreign key constraints ensure referential integrity across related tables.
- Business-related queries demonstrate practical use cases for the normalized database.

---

## Technologies Used

- Python (Pandas) for data cleaning and transformation
- Jupyter Notebook for interactive data exploration
- MySQL for relational database schema and data loading
- SQL for writing queries and views to analyze business data

---

## Potential Extensions

- Add a data validation layer during import to catch anomalies.
- Build dashboards or reports using the normalized data.
- Extend the customer table with demographic data for richer analysis.
- Automate the ETL process with scheduled scripts or workflows.

---

## Author

Samuel Akuffo

---

*This project was developed as part of my <a href="https://kwamesa.github.io/portfolio/index.html" _blank" rel="noopener noreferrer">portfolio</a> to showcase backend data engineering skills including data cleaning, normalization, and SQL querying.*

