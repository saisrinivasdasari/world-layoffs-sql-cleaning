-- World layoffs data cleaning
-- Dataset cleaned using MySQL
-- Goal: make the data usable for analysis

USE world_layoffs;

SELECT * 
FROM layoffs;


-- 1. Create a working copy
-- Keeping the raw table untouched

CREATE TABLE layoffsworkspace
LIKE layoffs;

INSERT INTO layoffsworkspace
SELECT *
FROM layoffs;

SELECT * 
FROM layoffsworkspace;


-- 2. Check for duplicate rows
-- Using ROW_NUMBER to spot duplicates

WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry,
                            total_laid_off, percentage_laid_off,
                            `date`, stage, country
           ) AS row_num
    FROM layoffsworkspace
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


-- 3. Store duplicates info in a new table
-- row_num will help remove extra records

CREATE TABLE layoffsws1 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT,
    row_num INT
);

INSERT INTO layoffsws1
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry,
                        total_laid_off, percentage_laid_off,
                        `date`, stage, country
       ) AS row_num
FROM layoffsworkspace;

SET SQL_SAFE_UPDATES = 0;

SELECT * 
FROM layoffsws1;


-- 4. Remove duplicate rows
-- Keeping only the first occurrence

DELETE
FROM layoffsws1
WHERE row_num > 1;

SELECT *
FROM layoffsws1;


-- 5. Clean and standardize text columns

-- Remove extra spaces from company names
UPDATE layoffsws1
SET company = TRIM(company);

-- Review industry values
SELECT DISTINCT industry
FROM layoffsws1
ORDER BY industry;

-- Merge crypto-related industry names
UPDATE layoffsws1
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Clean country values
SELECT DISTINCT country
FROM layoffsws1
ORDER BY country;

UPDATE layoffsws1
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- 6. Fix date column
-- Convert text dates into DATE format

UPDATE layoffsws1
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffsws1
MODIFY COLUMN `date` DATE;


-- 7. Handle missing values

-- Check rows with missing industry
SELECT *
FROM layoffsws1
WHERE industry IS NULL OR industry = '';

-- Convert blank industries to NULL
UPDATE layoffsws1
SET industry = NULL
WHERE industry = '';

-- Fill missing industry using same company records
UPDATE layoffsws1 t1
JOIN layoffsws1 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Remove rows with no layoff data at all
DELETE
FROM layoffsws1
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- 8. Final cleanup
-- row_num column no longer needed

ALTER TABLE layoffsws1
DROP COLUMN row_num;


-- Data cleaning finished
-- Table is ready for analysis
