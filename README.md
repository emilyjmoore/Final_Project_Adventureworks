# AdventureWorks Data Lakehouse – Batch + Streaming Integration

This project implements a complete **Dimensional Data Lakehouse** in Databricks using batch, incremental, and real-time streaming ingestion. It integrates data from **MySQL**, **MongoDB**, and **DBFS files**, and models it using a dimensional schema with a Bronze → Silver → Gold architecture.

The goal is to enable sales analytics across customers, employees, territories, and products using both static and real-time data.

---

## Dimensional Model

### **Dimensions**
- **Date** – Standard date dimension (provided SQL)
- **Customer** – Customer master data from MySQL and CSV
- **Employee** – Employee attributes from MySQL
- **Product** – Product catalog from MongoDB
- **Territory** – Sales region metadata from MySQL

Each dimension includes:
- Surrogate primary key  
- Cleaned & conformed attributes  
- Removal of fields not needed for analytics (e.g., `rowguid`)  

### **Fact Table**
**FactSales**

Contains:
- Customer, product, employee, territory, and date keys  
- Order metrics (quantity, unit_price, tax, discount, shipping_fee, etc.)  
- Records ingested from streaming JSON files using Autoloader  

---

## Medallion Architecture (Bronze → Silver → Gold)

### **Bronze Layer**
- Raw JSON files ingested using **Spark Autoloader**
- Schema inference and incremental ingestion

### **Silver Layer**
- Cleansed and standardized data  
- Casts date fields  
- Joins streaming fact data with static dimension tables  
- Ensures unique column naming through aliases  
- Adds surrogate keys  

### **Gold Layer**
- Final analytics-ready fact table  
- Aggregations available for BI and reporting  
- Supports customer, product, and time-based analysis  

---

## Functional Requirements – How This Project Meets Them

### **1. Batch Execution**
- Loads static dimension tables from:
  - MySQL / SQL Server  
  - MongoDB Atlas  
  - CSV files on DBFS  
- Performs incremental dimension loads  
- Generates surrogate keys via SQL window functions  

### **2. Real-Time Streaming with Autoloader**
- Sales data split into **3 separate JSON files** to simulate streaming intervals  
- Autoloader ingests "mini-batches" automatically  
- Each micro-batch flows through:
  - **Bronze:** raw JSON →  
  - **Silver:** cleaned, joined with dimensions →  
  - **Gold:** analytics-ready fact table  

### **3. Integration of Different Granularities**
- Static dimensions (slow-changing)  
- Real-time fact records (fast-changing)  
- Joined at the Silver layer to create a unified dataset  

### **4. Business Value Demonstration**
Example SQL query executed against the Gold layer:
```sql 
SELECT 
    c.customer_key,
    p.product_key,
    SUM(f.quantity * f.unit_price) AS total_sales
FROM fact_sales_gold f
JOIN dim_customer c ON f.customer_key = c.customer_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY c.customer_key, p.product_key
ORDER BY total_sales DESC;
