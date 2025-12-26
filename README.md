#  World Layoffs — Data Cleaning Using SQL

This project focuses on cleaning and preparing a global layoffs dataset
for analysis using **MySQL**.

The raw dataset contained:

- Duplicate records  
- Inconsistent formatting  
- Blank and NULL values  
- Incorrect date format  
- Unnecessary rows

My goal was to transform the raw data into a clean, reliable dataset
ready for analysis and visualization.

---

## Project Structure
├── data/
│ └── world_layoffs.csv
│
├── sql/
│ └── data_cleaning.sql
│
└── README.md


- `world_layoffs.csv` → raw dataset  
- `data_cleaning.sql` → complete SQL cleaning workflow  

---

## Objectives

✔ Remove duplicate records  
✔ Standardize text fields  
✔ Fix inconsistent industry names  
✔ Convert string dates into proper DATE format  
✔ Handle NULL and blank values  
✔ Delete rows with no meaningful information  

---

## Tools & Skills Used

**Language**
- SQL (MySQL)

**Concepts**
- CTEs
- Window functions (`ROW_NUMBER`)
- Data validation
- Handling NULLs
- Data standardization
- Date formatting
- Duplicate removal

---

## Key Cleaning Steps

### 1️ Create a Working Copy
Never modify original data — create a duplicate table.

### 2️ Detect & Remove Duplicates
Used `ROW_NUMBER()` to identify repeated records.

### 3️ Standardize Text Values
- Trim extra spaces
- Normalize industry names (e.g., "Crypto", "Crypto Currency" → `Crypto`)
- Clean up country strings (`United States.` → `United States`)

### 4️ Fix Dates
Converted string dates to `DATE` format.

### 5️ Handle Missing Data
- Replace blanks with NULL
- Fill missing industries based on same company rows
- Remove rows where layoff information is completely missing

### 6️ Remove Helper Columns
Dropped `row_num` after cleanup.

---

##  How to Run

1️ Import dataset into MySQL

```sql
USE world_layoffs;

