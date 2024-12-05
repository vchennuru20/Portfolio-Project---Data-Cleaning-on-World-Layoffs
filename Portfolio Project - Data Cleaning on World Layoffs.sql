-- SQL Project on Data Cleaning on World Layoffs
	-- 1. Remove Duplicates
	-- 2. Standardize the Data
    -- 3. Null Values or blank values
    -- 4. Remove any columns

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022 (Layoffs Dataset)

SELECT *
FROM layoffs;

-- 1. Remove Duplicates

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT 	*
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Cazoo';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- 2. Standardize the Data

SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2;

SELECT DISTINCT(location)
FROM layoffs_staging2
ORDER BY 1;

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. Null Values or blank values

SELECT *
FROM layoffs_staging2
WHERE industry;

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

-- 4. Remove any columns

SELECT *
FROM layoffs_staging2
WHERE row_num IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;








