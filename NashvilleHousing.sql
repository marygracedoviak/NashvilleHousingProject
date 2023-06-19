/* Cleaning the Data */

-- Transfer table into temp table so that we can have the original data if it is needed
DROP TABLE IF EXISTS #UpdatedHousing
SELECT * 
INTO #UpdatedHousing
FROM housing


-- Use ROW_NUMBER to get rid of duplicates 
DELETE
FROM up
FROM (
SELECT *, row_num = 
	ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID)
FROM #UpdatedHousing) AS up
WHERE up.row_num > 1


-- Standardizing the date format
ALTER TABLE #UpdatedHousing
ADD SaleDateConverted Date;

UPDATE #UpdatedHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Filling in any NULL PropetyAddress' that we can based off of matching ParcelID's 
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM #UpdatedHousing AS a
JOIN #UpdatedHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- Separating PropertyAddress into segments using PARSENAME
ALTER TABLE #UpdatedHousing
ADD PropertyStreet NVARCHAR(255)

ALTER TABLE #UpdatedHousing
ADD PropertyCity NVARCHAR(255)

UPDATE #UpdatedHousing
SET PropertyStreet = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)

UPDATE #UpdatedHousing
SET PropertyCity = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)


-- Separating OwnerAddress into segments using PARSENAME
ALTER TABLE #UpdatedHousing
ADD OwnerStreet NVARCHAR(255)

ALTER TABLE #UpdatedHousing
ADD OwnerCity NVARCHAR(255)

ALTER TABLE #UpdatedHousing
ADD OwnerState NVARCHAR(255)

UPDATE #UpdatedHousing
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE #UpdatedHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE #UpdatedHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


-- Standardize SoldAsVacant column into just 'Yes' and 'No'
UPDATE #UpdatedHousing
SET SoldAsVacant = 
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM #UpdatedHousing


-- Create a total count of baths
ALTER TABLE #UpdatedHousing
ADD TotalBaths DECIMAL(30, 1)

UPDATE #UpdatedHousing
SET TotalBaths = (FullBath + (HalfBath * 0.5))


-- Separate the SaleDate into year, month and day
ALTER TABLE #UpdatedHousing
ADD SaleYear INT

ALTER TABLE #UpdatedHousing
ADD SaleMonth INT

ALTER TABLE #UpdatedHousing
ADD SaleDay INT

UPDATE #UpdatedHousing
SET SaleYear = PARSENAME(REPLACE(SaleDateConverted, '-', '.'),3)

UPDATE #UpdatedHousing
SET SaleMonth = PARSENAME(REPLACE(SaleDateConverted, '-', '.'),2)

UPDATE #UpdatedHousing
SET SaleDay = PARSENAME(REPLACE(SaleDateConverted, '-', '.'),1)


-- Delete columns that are not needed
ALTER TABLE #UpdatedHousing
DROP COLUMN TaxDistrict, SaleDate, OwnerAddress, PropertyAddress


/* Querying the data */


-- Check popularity of different areas of Nashville
SELECT PropertyCity, COUNT(PropertyCity) AS cityCount
FROM #UpdatedHousing
GROUP BY PropertyCity
ORDER BY 2


-- Check popularity of bedroom count in single family homes 
SELECT Bedrooms, COUNT(Bedrooms) AS bedroomCount
FROM #UpdatedHousing
WHERE LandUse = 'SINGLE FAMILY'
AND Bedrooms IS NOT NULL
GROUP BY Bedrooms
ORDER BY 1


-- Used the data found above to look at average SalePrice for houses built in different decades
SELECT AVG(SalePrice) AS '1800sAvgPrice'
FROM #UpdatedHousing
WHERE Bedrooms = 3 
AND PropertyCity = ' NASHVILLE'
AND YearBuilt >= 1799 
AND YearBuilt <= 1899

SELECT AVG(SalePrice) AS '1900sAvgPrice'
FROM #UpdatedHousing
WHERE Bedrooms = 3 
AND PropertyCity = ' NASHVILLE'
AND YearBuilt > 1899 
AND YearBuilt <= 1999

SELECT AVG(SalePrice) AS '2000sAvgPrice'
FROM #UpdatedHousing
WHERE Bedrooms = 3 
AND PropertyCity = ' NASHVILLE'
AND YearBuilt > 1999 
AND YearBuilt <= 2009

SELECT AVG(SalePrice) AS '2010sAvgPrice'
FROM #UpdatedHousing
WHERE Bedrooms = 3 
AND PropertyCity = ' NASHVILLE'
AND YearBuilt > 2009 
AND YearBuilt <= 2019

SELECT *
FROM #UpdatedHousing
WHERE YearBuilt IS NOT NULL
ORDER BY YearBuilt 


-- See which months the most sales were made in
SELECT SaleMonth, COUNT(SaleMonth) AS saleCount
FROM #UpdatedHousing
GROUP BY SaleMonth
ORDER BY 2 DESC