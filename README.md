# E-Commerce Data Warehouse ETL Project (SSIS) – Olist Dataset

## Project Overview

This project involves designing and implementing a data warehouse for an e-commerce platform using Microsoft SQL Server and **SQL Server Integration Services (SSIS)**. The data warehouse is modeled as a **star schema** to facilitate efficient analytical queries, with a central fact table linked to multiple dimension tables. The source data comes from a public Brazilian e-commerce dataset (from Olist, an online marketplace) containing approximately **100,000 orders from 2016 to 2018** across various marketplaces. The ETL process (Extract, Transform, Load) is implemented in SSIS to **extract** raw data from CSV files, **transform**/clean it (e.g., converting product category names from Portuguese to English), and **load** it into the SQL Server data warehouse.

## Objectives and Scope

- **Data Warehouse Design:** Develop a **star-schema** data warehouse for an e-commerce sales dataset.
- **ETL Pipeline Implementation:** Create an **ETL process** using SSIS to migrate data from the source operational datasets.
- **Data Integration and Quality:** Integrate data from multiple source files (orders, order items, customers, products, etc.).
- **Documentation and Reproducibility:** Provide clear documentation describing the project’s methodology and usage.

## Tools and Technologies Used

- Microsoft SQL Server 2022
- SQL Server Integration Services (SSIS)
- SQL (T-SQL)
- Visual Studio 2022 with SSDT
- Olist e-commerce dataset (CSV format)

## Data Flow and ETL Process

1. **Extraction to Staging:** Loads raw CSV files into staging tables using SSIS.
2. **Transformation and Loading:** Cleans and enriches data, builds dimension tables and fact tables using lookups and joins.
3. **Fact Table Loading:** Constructs the fact table at order-item level, with surrogate keys for all dimensions.
4. **Dimension Tables:** Built from staging data with relevant attributes and surrogate keys.

## Star Schema Design

- **Fact Table:** fact_order_items (contains keys: customer_key, product_key, seller_key, date_key, and measures like price, freight, quantity)
- **Dimension Tables:**
  - dim_customer (customer info)
  - dim_product (product category, dimensions)
  - dim_seller (seller location)
  - dim_date (calendar breakdown)

## Repository Structure and Files

```
├── ecom_StagingLoad.sln              # Visual Studio Solution
├── ecom_StagingLoad/                 # SSIS Project folder
│   ├── load_staging.dtsx             # Package for loading staging tables
│   ├── ETL Data Transformation.dtsx  # Package for building DW schema
│   ├── *.conmgr                      # Connection manager files
```

## Steps to Run the Project

1. Clone the repo and open the `.sln` in Visual Studio with SSDT.
2. Update connection managers to match your SQL Server and file paths.
3. Create staging and warehouse databases in SQL Server.
4. Run `load_staging.dtsx` to populate staging tables.
5. Run `ETL Data Transformation.dtsx` to transform and load warehouse schema.
6. Validate the tables using SQL queries or connect to a BI tool like Power BI.

## Author and Academic Info

**Author:** A.R.S. De Silva (Student ID: IT22586834)  
**Affiliation:** Undergraduate Student – B.Sc. in Information Technology  
**Project Purpose:** Submitted as part of a Data Warehousing and Business Intelligence course.  
