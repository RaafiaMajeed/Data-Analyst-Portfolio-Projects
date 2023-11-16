
--This file will show you how to clean data using SQL
SELECT * 
FROM PortfolioProjectSQL.dbo.NashvilleHousing

----Standardising the Date

SELECT SaleDate,CONVERT(Date,SaleDate)
FROM PortfolioProjectSQL.dbo.NashvilleHousing

--Update NashvilleHousing
--SET SaleDate=CONVERT(Date,SaleDate)
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

 SELECT * 
FROM PortfolioProjectSQL.dbo.NashvilleHousing

-------- lets populate Property address Data------------------------------------------
 SELECT PROPERTYaddress
FROM PortfolioProjectSQL.dbo.NashvilleHousing

SELECT * 
FROM PortfolioProjectSQL.dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY PARCELID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM PortfolioProjectSQL.dbo.NashvilleHousing a 
JOIN PortfolioProjectSQL.dbo.NashvilleHousing b
   on a.ParcelID=b.ParcelID
   AND a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress is NULL

Update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProjectSQL.dbo.NashvilleHousing a 
JOIN PortfolioProjectSQL.dbo.NashvilleHousing b
   on a.ParcelID=b.ParcelID
   AND a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress is NULL

------------------------------Seperating Property Address Data into different Columns .e address and city
SELECT PROPERTYaddress
FROM PortfolioProjectSQL.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS City
FROM PortfolioProjectSQL.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);
Update NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255)
Update NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

-------------------------------------Splitting owner Address into different columns using Parsename------------------

SELECT owneraddress
FROM PortfolioProjectSQL.dbo.NashvilleHousing

SELECT
PARSENAME(Replace(Owneraddress, ',','.'),3),
PARSENAME(Replace(Owneraddress, ',','.'),2),
PARSENAME(Replace(Owneraddress, ',','.'),1)
FROM PortfolioProjectSQL.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);
Update NashvilleHousing
SET OwnerSplitAddress=PARSENAME(Replace(Owneraddress, ',','.'),3) 

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255)
Update NashvilleHousing
SET OwnerSplitCity=PARSENAME(Replace(Owneraddress, ',','.'),2)
ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255)
Update NashvilleHousing
SET OwnerSplitState=PARSENAME(Replace(Owneraddress, ',','.'),1)
SELECT *
FROM PortfolioProjectSQL.dbo.NashvilleHousing

---------------------Replacing 'y' with 'yes' and 'n' with 'No' in SoldAsVacant
Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
FROM PortfolioProjectSQL.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
 Case
    WHEN SoldAsVacant='Y' THEN 'YES'
	WHEN SoldAsVacant='N' THEN 'NO'
	else SoldAsVacant
	END
FROM PortfolioProjectSQL.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=
 Case
    WHEN SoldAsVacant='Y' THEN 'YES'
	WHEN SoldAsVacant='N' THEN 'NO'
	else SoldAsVacant
	END

--------------------------Remove Duplicates using Row_num() and partition by
With RownumCTE as(

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY PARCELID,PropertyAddress,SalePrice,SaleDate,LegalReference
order by UniqueID) As row_num
FROM PortfolioProjectSQL.dbo.NashvilleHousing
)
Delete
From RownumCTE
Where row_num>1


-----------------------------Delete Unused Columns

ALTER TABLE NashvilleHousing
DROP Column PropertyAddress,OwnerAddress,TaxDistrict,SaleDate

SELECT * 
FROM PortfolioProjectSQL.dbo.NashvilleHousing