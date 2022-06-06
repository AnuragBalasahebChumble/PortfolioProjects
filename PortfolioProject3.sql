/*
cleaning data in SQL
*/

select * from HousingData

-- Standardize Date format

select top 3 SaleDate, CONVERT(date, SaleDate) as date_format
from HousingData

-- let's add the column 'SaleDateConverted'
alter table HousingData
add SaleDateConverted Date

--Let's add the value to it
update HousingData
set SaleDateConverted = CONVERT(date, SaleDate)

-- let's check

select SaleDate, SaleDateConverted from HousingData

-------------------------------------------------------------------------------------------------------

-----Populate Property Address data

select PropertyAddress 
from HousingData
where PropertyAddress is null

-- We'll do self join(joining the table by itself)
select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from HousingData a
join HousingData b
On a.ParcelID = b.ParcelID
where a.[UniqueID ] <> b.[UniqueID ]
and a.PropertyAddress is NULL

--let's fill in the NULLS from PropertyAddress

--note need to use alias with 'update' or it won't work.
update a 
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from HousingData a
join HousingData b
On a.ParcelID = b.ParcelID
where a.[UniqueID ] <> b.[UniqueID ]
and a.PropertyAddress is NULL


-------------------------------------------------------------------------

--------Breaking out address into individual columns (address, city, state)
select PropertyAddress from HousingData

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyaddress)-1) as address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress)) as address
from HousingData

--Add table

alter table HousingData
add PropertySplitAddress Nvarchar(255)

--Update new table
update HousingData
set propertysplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyaddress)-1)

--Add tabe
alter table HousingData
add PropertySplitCity Nvarchar(255)

--Update new table
update HousingData
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress))

select * from HousingData

--------------------------------------------------------------------------------------------

--this is the other way around to split the strings on the delimitors.

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(owneraddress, ',', '.'), 2),
PARSENAME(REPLACE(owneraddress, ',', '.'), 1)
from HousingData


alter table housingdata
add OwnerSplitAddress nvarchar(255)

update HousingData
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

alter table housingdata
add OwnerSplitCity nvarchar(55)

update HousingData
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

alter table housingdata
add OwnerSplitState nvarchar(55)

update HousingData
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


select OwnerAddress, Ownersplitaddress, OwnerSplitCity, OwnerSplitState
from HousingData

-----------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from HousingData
group by(SoldAsVacant)
order by 2

select SoldAsVacant, 
CASE when SoldAsVacant = 'Y' then 'Yes' 
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
END
from HousingData


update HousingData
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes' 
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
END
from HousingData


-------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select * 
from HousingData

--alter table HousingData
-- drop column OwnerAddress, TaxDistrict, PropertyAddress
